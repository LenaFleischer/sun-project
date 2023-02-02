import UIKit

import Foundation

struct Weather:Codable{
    let remainingCost: Int
    let queryCost: Int
    let messages: String?
    let location: Locations
}

 struct Locations:Codable{
     let stationContributions: String?
     let values: [Values]
     let id: String
     let address: String
     let name: String
     let index: Int
     let latitude: Double
     let longitude: Double
     let distance: Double
     let time: Double
     let tz: String
     let currentConditions: CurrentConditions
     let alerts: String?
 }

struct Values: Codable{
    let wdir: Double
    let uvindex: Double
    let sunrise: String
    let datetimeStr: String
    let precriptype: String?
    let cin: Double
    let cloudcover: Double
    let pop: Double
    let datetime: Int
    let precip: Double
    let solarradiation: Double
    let dew: Double
    let humidity: Double
    let temp: Double
    let visibility: Double
    let wspd: Double
    let severerisk: Double
    let solarenergy: Double
    let heatindex: Double?
    let moonphase: Double
    let snowdepth: Double
    let sealevelpressure: Double
    let snow: Double
    let sunset: String
    let wgust: Double
    let conditions: String
    let windchill: Double
    let cape: Double
}

struct CurrentConditions:Codable{
    let wdir: Double
    let temp: Double
    let sunrise: String
    let visibility: Double
    let wspd: Double
    let icon: String
    let stations: String
    let heatindex: Int?
    let cloudcover: Double
    let datetime: String
    let precip: Double
    let moonphase: Double
    let snowdepth: Double?
    let sealevelpressure: Double
    let dew: Double
    let sunset: String
    let humidity: Double
    let wgust: Double?
    let windchill: Double
}

func callAPI(){
    guard let url = URL(string: "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/weatherdata/forecast?locations=ColoradoSprings,CO&aggregateHours=1&forecastDays=1&includeAstronomy=true&unitGroup=us&shortColumnNames=true&contentType=json&locationMode=single&key=4UR84GUK6HRFRTNBQXWNSVFJ4") else{return}


    let task = URLSession.shared.dataTask(with: url){
        data, response, error in
        
        if let data = data, let string = String(data: data, encoding: .utf8){
            print(string)
        } else {
            print("no")
        }
    }

    task.resume()
}
callAPI()

func decodeAPI(){
    guard let url = URL(string: "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/weatherdata/forecast?locations=ColoradoSprings,CO&aggregateHours=1&forecastDays=1&includeAstronomy=true&unitGroup=us&shortColumnNames=true&contentType=json&locationMode=single&key=4UR84GUK6HRFRTNBQXWNSVFJ4") else{return}

    let task = URLSession.shared.dataTask(with: url){
        data, response, error in
        
        let decoder = JSONDecoder()

        if let data = data{
            do{
                let weatherinfo = try decoder.decode(Weather.self, from: data)
                var currentTime = weatherinfo.location.currentConditions.datetime
                let firstHourIndex = currentTime.index(currentTime.startIndex, offsetBy: 11)
                let secondHourIndex = currentTime.index(currentTime.startIndex, offsetBy: 12)
                var firstHour = currentTime[firstHourIndex]
                var secondHour = currentTime[secondHourIndex]
                var hourString = String(firstHour)+String(secondHour)
                var hour = Int(hourString) ?? 0
                print(hour)
                
                var sunriseTime = weatherinfo.location.currentConditions.sunrise
                let firstSunriseHourIndex = sunriseTime.index(sunriseTime.startIndex, offsetBy: 11)
                let secondSunriseHourIndex = sunriseTime.index(sunriseTime.startIndex, offsetBy: 12)
                var firstSunriseHour = sunriseTime[firstHourIndex]
                var secondSunriseHour = sunriseTime[secondHourIndex]
                var sunriseHourString = String(firstSunriseHour)+String(secondSunriseHour)
                var sunriseHour = Int(sunriseHourString) ?? 0
                print(sunriseHour)
                
                var sunsetTime = weatherinfo.location.currentConditions.sunset
                let firstSunsetHourIndex = sunsetTime.index(sunsetTime.startIndex, offsetBy: 11)
                let secondSunsetHourIndex = sunsetTime.index(sunsetTime.startIndex, offsetBy: 12)
                var firstSunsetHour = sunsetTime[firstHourIndex]
                var secondSunsetHour = sunsetTime[secondHourIndex]
                var sunsetHourString = String(firstSunsetHour)+String(secondSunsetHour)
                var sunsetHour = Int(sunsetHourString) ?? 0
                print(sunsetHour)
            }catch{
                print(error)
            }
        }
    }
    task.resume()

}
//decodeAPI()

func findCloudCoverAtSunset(values: [Values], sunsetTime: String){
    var chars = Array(sunsetTime)
    chars[14] = "0"
    chars[15] = "0"
    chars[17] = "0"
    chars[18] = "0"

    let correctedSunsetTime = String(chars)
    values.forEach{ i in
        if(i.datetimeStr == correctedSunsetTime){
            print(i.cloudcover)
        }
    }
    return
}

func findCloudCoverAtSunrise(values: [Values], sunriseTime: String){
    var chars = Array(sunriseTime)
    
    chars[9] = "3"
    chars[14] = "0"
    chars[15] = "0"
    chars[17] = "0"
    chars[18] = "0"

    let correctedSunriseTime = String(chars)
    values.forEach{ i in
        if(i.datetimeStr == correctedSunriseTime){
            print(i.cloudcover)
        }
    }
    return
}
