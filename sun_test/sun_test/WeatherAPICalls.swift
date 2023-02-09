//
//  WeatherAPICalls.swift
//  sun_test
//
//

import Foundation

struct LocationInfo:Codable{
    let name: String
    let local_names: LocalNames
    let lat: Double
    let lon: Double
    let country: String
    let state: String
}

struct LocalNames:Codable{
    let en: String
}


extension Date {
   static var tomorrow:  Date { return Date().dayAfter }
   static var today: Date {return Date()}
   var dayAfter: Date {
      return Calendar.current.date(byAdding: .day, value: 1, to: Date())!
   }
}


struct Weather:Codable{
    let remainingCost: Int?
    let queryCost: Int?
    let messages: String?
    let location: Locations
}

 struct Locations:Codable{
     let stationContributions: String?
     let values: [Values]
     let id: String?
     let address: String?
     let name: String?
     let index: Int?
     let latitude: Double?
     let longitude: Double?
     let distance: Double?
     let time: Double?
     let tz: String?
     let currentConditions: CurrentConditions
     let alerts: String?
 }

struct Values: Codable{
    let wdir: Double?
    let uvindex: Double?
    let sunrise: String
    let datetimeStr: String
    let precriptype: String?
    let cin: Double?
    let cloudcover: Double
    let pop: Double?
    let datetime: Int
    let precip: Double?
    let solarradiation: Double?
    let dew: Double?
    let humidity: Double?
    let temp: Double?
    let visibility: Double?
    let wspd: Double?
    let severerisk: Double?
    let solarenergy: Double?
    let heatindex: Double?
    let moonphase: Double?
    let snowdepth: Double?
    let sealevelpressure: Double?
    let snow: Double?
    let sunset: String
    let wgust: Double?
    let conditions: String?
    let windchill: Double?
    let cape: Double?
}

struct CurrentConditions:Codable{
    let wdir: Double?
    let temp: Double?
    let sunrise: String
    let visibility: Double?
    let wspd: Double?
    let icon: String?
    let stations: String?
    let heatindex: Int?
    let cloudcover: Double
    let datetime: String
    let precip: Double?
    let moonphase: Double?
    let snowdepth: Double?
    let sealevelpressure: Double?
    let dew: Double?
    let sunset: String
    let humidity: Double?
    let wgust: Double?
    let windchill: Double?
}

func decodeAPI(userLocation:String, completionHandler: @escaping (Double,Double)->Void){
    var sunsetCloudCover = -1.0
    var sunriseCloudCover = -1.0
    
    guard let url = URL(string: "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/weatherdata/forecast?locations="+userLocation+"&aggregateHours=1&forecastDays=1&includeAstronomy=true&unitGroup=us&shortColumnNames=true&contentType=json&locationMode=single&key=4UR84GUK6HRFRTNBQXWNSVFJ4") else{return}

    let task = URLSession.shared.dataTask(with: url){
        data, response, error in
        
        let decoder = JSONDecoder()

        if let data = data{
            do{
                var sunrisePassed = false
                var sunsetPassed = false
                
                let weatherinfo = try decoder.decode(Weather.self, from: data)
                let currentTime = weatherinfo.location.currentConditions.datetime
                let firstHourIndex = currentTime.index(currentTime.startIndex, offsetBy: 11)
                let secondHourIndex = currentTime.index(currentTime.startIndex, offsetBy: 12)
                let firstHour = currentTime[firstHourIndex]
                let secondHour = currentTime[secondHourIndex]
                let hourString = String(firstHour)+String(secondHour)
                let hour = Int(hourString) ?? 0
                
                let sunriseTime = weatherinfo.location.currentConditions.sunrise
                let firstSunriseHourIndex = sunriseTime.index(sunriseTime.startIndex, offsetBy: 11)
                let secondSunriseHourIndex = sunriseTime.index(sunriseTime.startIndex, offsetBy: 12)
                let firstSunriseHour = sunriseTime[firstSunriseHourIndex]
                let secondSunriseHour = sunriseTime[secondSunriseHourIndex]
                let sunriseHourString = String(firstSunriseHour)+String(secondSunriseHour)
                let sunriseHour = Int(sunriseHourString) ?? 0
                
                let sunsetTime = weatherinfo.location.currentConditions.sunset
                let firstSunsetHourIndex = sunsetTime.index(sunsetTime.startIndex, offsetBy: 11)
                let secondSunsetHourIndex = sunsetTime.index(sunsetTime.startIndex, offsetBy: 12)
                let firstSunsetHour = sunsetTime[firstSunsetHourIndex]
                let secondSunsetHour = sunsetTime[secondSunsetHourIndex]
                let sunsetHourString = String(firstSunsetHour)+String(secondSunsetHour)
                let sunsetHour = Int(sunsetHourString) ?? 0
                
                if(hour > sunriseHour){
                    sunrisePassed = true
                }
                
                if(hour > sunsetHour){
                    sunsetPassed = true
                }
                
                sunsetCloudCover = findCloudCoverAtSunset(values:weatherinfo.location.values, sunsetPassed: sunsetPassed)
                sunriseCloudCover = findCloudCoverAtSunrise(values:weatherinfo.location.values, sunrisePassed: sunrisePassed)
                completionHandler(sunriseCloudCover,sunsetCloudCover)
            }catch{
                print(error)
            }
        }
    }
    task.resume()

}

func findCloudCoverAtSunset(values: [Values], sunsetPassed: Bool) -> Double {
    var sunsetTime:String = ""
    if(sunsetPassed == true){
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = "YYYY-MM-dd"

        // Convert Date to String
        let tomorrow = dateFormatter.string(from: Date.tomorrow)
        
        let dateString = values.first!.datetimeStr
        
        let endOfDateIndex = dateString.firstIndex(of: "T")!
        
        let endOfDate = dateString[endOfDateIndex...]
        
        let thisString = tomorrow + endOfDate
        
        var dateChars = Array(thisString)
        dateChars[11] = "0"
        dateChars[12] = "0"
        
        let correctedString = String(dateChars)
        
        values.forEach{ i in
            if(i.datetimeStr == correctedString){
                sunsetTime = i.sunset
            }
        }
    } else {
        sunsetTime = values.first!.sunset
    }
    
    var chars = Array(sunsetTime)
    
    chars[14] = "0"
    chars[15] = "0"
    chars[17] = "0"
    chars[18] = "0"

    let correctedSunsetTime = String(chars)
    var cloudcover:Double = -1
    
    values.forEach{ i in
        if(i.datetimeStr == correctedSunsetTime){
            cloudcover = i.cloudcover
        }
    }
    return cloudcover
}

func findCloudCoverAtSunrise(values: [Values], sunrisePassed:Bool) -> Double {
    var sunriseTime:String = ""
    if(sunrisePassed == true){
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = "YYYY-MM-dd"

        // Convert Date to String
        let tomorrow = dateFormatter.string(from: Date.tomorrow)
        
        let dateString = values.first!.datetimeStr
        
        let endOfDateIndex = dateString.firstIndex(of: "T")!
        
        let endOfDate = dateString[endOfDateIndex...]
        
        let thisString = tomorrow + endOfDate
        
        var dateChars = Array(thisString)
        dateChars[11] = "0"
        dateChars[12] = "0"
        
        let correctedString = String(dateChars)
        
        values.forEach{ i in
            if(i.datetimeStr == correctedString){
                sunriseTime = i.sunrise
            }
        }
        
    } else {
        sunriseTime = values.first!.sunrise
    }
    
    var chars = Array(sunriseTime)
    
    chars[14] = "0"
    chars[15] = "0"
    chars[17] = "0"
    chars[18] = "0"

    let correctedSunriseTime = String(chars)
    
    var cloudcover:Double = -1
    
    print(correctedSunriseTime)

    values.forEach{ i in
        if(i.datetimeStr == correctedSunriseTime){
            cloudcover = i.cloudcover
        }
    }
    return cloudcover
}


func getLocationFromLatLon(lat: Double, lon: Double, completionHandler: @escaping (String)->Void){
    let latstring = String(format: "%f", lat)
    let lonstring = String(format: "%f", lon)
    guard let url = URL(string: "https://api.openweathermap.org/geo/1.0/reverse?lat="+latstring+"&lon="+lonstring+"&limit=1&appid=b8e47752de82ded76fddfd3f9608c08e") else{return}

    let task = URLSession.shared.dataTask(with: url){
        data, response, error in
        
        let decoder = JSONDecoder()

        if let data = data{
            do{
                let locationinfo = try decoder.decode([LocationInfo].self, from: data)
                let name = locationinfo.first!.name
                completionHandler(name)
            }catch{
                print(error)
            }
        }
    }
    task.resume()
}
