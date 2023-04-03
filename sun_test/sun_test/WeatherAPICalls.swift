//
//  WeatherAPICalls.swift
//  sun_test
//
//

import Foundation
import CoreML

//struct to get mean and std vector
struct VectorInfo:Codable {
    var vector: [Double]
}

//structs for the lat/long into location
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

//making a tomorrow variable to find tomorrow's sunrise/sunset
extension Date {
   static var tomorrow:  Date { return Date().dayAfter }
   static var today: Date {return Date()}
   var dayAfter: Date {
      return Calendar.current.date(byAdding: .day, value: 1, to: Date())!
   }
}

//structs for visual crossing api call
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
    let snowdepth: Double?
    let sealevelpressure: Double
    let snow: Double?
    let sunset: String
    let wgust: Double?
    let conditions: String
    let windchill: Double?
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
    let heatindex: Double?
    let cloudcover: Double?
    let datetime: String
    let precip: Double
    let moonphase: Double
    let snowdepth: Double?
    let sealevelpressure: Double
    let dew: Double
    let sunset: String
    let humidity: Double
    let wgust: Double?
    let windchill: Double?
}

//makes api call and returns predictions and times for the next sunrise/sunset
func decodeAPI(userLocation:String, completionHandler: @escaping (Double,Double,String,String)->Void){
    guard let url = URL(string: "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/weatherdata/forecast?locations="+userLocation+"&aggregateHours=1&forecastDays=1&includeAstronomy=true&unitGroup=us&shortColumnNames=true&contentType=json&locationMode=single&key=4UR84GUK6HRFRTNBQXWNSVFJ4") else{return}

    let task = URLSession.shared.dataTask(with: url){
        data, response, error in
        
        let decoder = JSONDecoder()

        if let data = data{
            do{
                //finding if sunrise/sunset have passed to get correct timing
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
                
                //finding correct sunrise/sunset time
                let sunrise = getSunriseTime(values: weatherinfo.location.values, sunrisePassed: sunrisePassed)
                let sunset = getSunsetTime(values: weatherinfo.location.values, sunsetPassed: sunsetPassed)
                
                //getting corrected times to find the hour the sunset/sunrise occur
                var sunriseChars = Array(sunrise)
                
                sunriseChars[14] = "0"
                sunriseChars[15] = "0"
                sunriseChars[17] = "0"
                sunriseChars[18] = "0"

                let correctedSunriseTime = String(sunriseChars)
                
                var sunsetChars = Array(sunset)
                
                sunsetChars[14] = "0"
                sunsetChars[15] = "0"
                sunsetChars[17] = "0"
                sunsetChars[18] = "0"

                let correctedSunsetTime = String(sunsetChars)
                
                //creating vectors
                var sunrise_vector = makeSunriseVector(values: weatherinfo.location.values, correctedSunriseTime: correctedSunriseTime)
                var sunset_vector = makeSunsetVector(values: weatherinfo.location.values, correctedSunsetTime: correctedSunsetTime)
                
                //normalizing vectors
                let mean_vector_info = loadJson(filename: "mean")!
                let std_vector_info = loadJson(filename: "std")!
                
                var index = 0
                while(index < 19){
                    sunrise_vector[index] = (sunrise_vector[index] - mean_vector_info.vector[index])/(std_vector_info.vector[index])
                    sunset_vector[index] = (sunset_vector[index] - mean_vector_info.vector[index])/(std_vector_info.vector[index])
                    index+=1
                }
                
                //making the multiarrays
                guard let sunriseArray = try? MLMultiArray(shape:[19], dataType:MLMultiArrayDataType.float32) else {
                        fatalError("Unexpected runtime error. MLMultiArray")
                }
                for (index, element) in sunrise_vector.enumerated() {
                    sunriseArray[index] = NSNumber(floatLiteral: element)
                }
                
                guard let sunsetArray = try? MLMultiArray(shape:[19], dataType:MLMultiArrayDataType.float32) else {
                        fatalError("Unexpected runtime error. MLMultiArray")
                }
                for (index, element) in sunset_vector.enumerated() {
                    sunsetArray[index] = NSNumber(floatLiteral: element)
                }
                
                //using the multiarrays and the model in order to get the predicted quality
                //of the sunrise and sunset
                let model = try! sunrise_model1()
                
                let sunriseInput = sunrise_model1Input(input_1: sunriseArray)
                    guard let sunrisePredictionOutput = try? model.prediction(input: sunriseInput) else {
                            fatalError("Unexpected runtime error. model.prediction")
                    }
                let sunsetInput = sunrise_model1Input(input_1: sunsetArray)
                    guard let sunsetPredictionOutput = try? model.prediction(input: sunsetInput) else {
                            fatalError("Unexpected runtime error. model.prediction")
                    }
                
                //these are the predictions, casting them to doubles to return
                var sunrisePrediction = Double(truncating: sunrisePredictionOutput.var_26[0])
                var sunsetPrediction = Double(truncating: sunsetPredictionOutput.var_26[0])
                
                //rounding and altering to be a percentage double
                sunrisePrediction = sunrisePrediction*100
                sunsetPrediction = sunsetPrediction*100
                
                let roundedSunrisePrediction = Double(round(1000 * sunrisePrediction) / 1000)
                let roundedSunsetPrediction = Double(round(1000 * sunsetPrediction) / 1000)
                
                //getting shorter string of the sunrise/sunset to return
                let finalSunrise = getTime(longTime: sunrise)
                let finalSunset = getTime(longTime: sunset)
                
                //returning
                completionHandler(roundedSunrisePrediction, roundedSunsetPrediction, finalSunrise, finalSunset)

            }catch{
                print(error)
            }
        }
    }
    task.resume()

}

//2023-02-02T07:04:38-07:00
//0123456789012345678901234
//          111111111122222
//changes long sunrise/sunset string to just the hour and minute
func getTime(longTime: String) -> String{
    // shortened time = 2023-02-02T07:04
    let shortenedTime = longTime.prefix(16)
    // time = 07:04
    let time = shortenedTime.suffix(5)
    if time.starts(with: "0"){
        // 7:04
        let newTime = time.suffix(4)
        return String(newTime) + " a.m."
        // if the hour is bigger than 9
    } else{
        let hour = Int(String(time.prefix(2))) ?? 0
        // if the hour is bigger than 12 change out of Military time
        if hour > 12{
            let newHour = hour - 12
            // the minites and the :
            let min = time.suffix(3)
            let fixedTime = String(newHour) + String(min)
            return fixedTime + " p.m."
        }
        // if string is bigger than 9 but less than 12
        return String(time) + " a.m."
    }
}
//loads the mean and std json files
func loadJson(filename fileName: String) -> VectorInfo? {
    if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode(VectorInfo.self, from: data)
            return jsonData
        } catch {
            print("error:\(error)")
        }
    }
    return nil
}

// chooses the correct variables to add to the vector for correct comparison to the model
func makeSunriseVector(values: [Values], correctedSunriseTime: String) -> [Double]{
    var sunrise_vector: [Double] = []
    values.forEach{ i in
        if(i.datetimeStr == correctedSunriseTime){
            sunrise_vector.append(i.temp)
            sunrise_vector.append(i.dew)
            sunrise_vector.append(i.humidity)
            if(i.heatindex == nil){
                sunrise_vector.append(0.0)
            } else {
                sunrise_vector.append(i.heatindex!)
            }
            sunrise_vector.append(i.wspd)
            if(i.wgust == nil){
                sunrise_vector.append(0.0)
            } else {
                sunrise_vector.append(i.wgust!)
            }
            sunrise_vector.append(i.wdir)
            if(i.windchill == nil){
                sunrise_vector.append(0.0)
            } else {
                sunrise_vector.append(i.windchill!)
            }
            sunrise_vector.append(i.precip)
            if(i.snowdepth == nil){
                sunrise_vector.append(0.0)
            } else {
                sunrise_vector.append(i.snowdepth!)
            }
            sunrise_vector.append(i.visibility)
            sunrise_vector.append(i.cloudcover)
            sunrise_vector.append(i.sealevelpressure)
            if(i.conditions == "Overcast"){
                sunrise_vector.append(1.0)
            } else {
                sunrise_vector.append(0.0)
            }
            if(i.conditions == "Partially cloudy"){
                sunrise_vector.append(1.0)
            } else {
                sunrise_vector.append(0.0)
            }
            if(i.conditions == "Clear"){
                sunrise_vector.append(1.0)
            } else {
                sunrise_vector.append(0.0)
            }
            if(i.conditions == "Rain"){
                sunrise_vector.append(1.0)
            } else {
                sunrise_vector.append(0.0)
            }
            
            let sunriseChars = Array(correctedSunriseTime)
            
            let month1 = sunriseChars[5]
            let month2 = sunriseChars[6]
            let month = String(month1)+String(month2)
            sunrise_vector.append(Double(month)!)
            
            let hour1 = sunriseChars[11]
            let hour2 = sunriseChars[12]
            let hour = String(hour1)+String(hour2)
            sunrise_vector.append(Double(hour)!)
        }
    }
    return sunrise_vector
}

//same function as above but for the sunset
func makeSunsetVector(values: [Values], correctedSunsetTime: String) -> [Double]{
    var sunset_vector: [Double] = []
    values.forEach{ i in
        if(i.datetimeStr == correctedSunsetTime){
            sunset_vector.append(i.temp)
            sunset_vector.append(i.dew)
            sunset_vector.append(i.humidity)
            if(i.heatindex == nil){
                sunset_vector.append(0.0)
            } else {
                sunset_vector.append(i.heatindex!)
            }
            sunset_vector.append(i.wspd)
            if(i.wgust == nil){
                sunset_vector.append(0.0)
            } else {
                sunset_vector.append(i.wgust!)
            }
            sunset_vector.append(i.wdir)
            if(i.windchill == nil){
                sunset_vector.append(0.0)
            } else {
                sunset_vector.append(i.windchill!)
            }
            sunset_vector.append(i.precip)
            if(i.snowdepth == nil){
                sunset_vector.append(0.0)
            } else {
                sunset_vector.append(i.snowdepth!)
            }
            sunset_vector.append(i.visibility)
            sunset_vector.append(i.cloudcover)
            sunset_vector.append(i.sealevelpressure)
            if(i.conditions == "Overcast"){
                sunset_vector.append(1.0)
            } else {
                sunset_vector.append(0.0)
            }
            if(i.conditions == "Partially cloudy"){
                sunset_vector.append(1.0)
            } else {
                sunset_vector.append(0.0)
            }
            if(i.conditions == "Clear"){
                sunset_vector.append(1.0)
            } else {
                sunset_vector.append(0.0)
            }
            if(i.conditions == "Rain"){
                sunset_vector.append(1.0)
            } else {
                sunset_vector.append(0.0)
            }
            
            let sunsetChars = Array(correctedSunsetTime)
            
            let month1 = sunsetChars[5]
            let month2 = sunsetChars[6]
            let month = String(month1)+String(month2)
            sunset_vector.append(Double(month)!)
            
            let hour1 = sunsetChars[11]
            let hour2 = sunsetChars[12]
            let hour = String(hour1)+String(hour2)
            sunset_vector.append(Double(hour)!)
            
        }
    }
    return sunset_vector
}

//gets the hour that the sunrise occurs at in the visual crossing date/time form
func getSunriseTime(values: [Values], sunrisePassed:Bool) -> String{
    var sunrise = ""
    if(sunrisePassed){
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
                sunrise = i.sunrise
            }
        }
    } else {
        sunrise = values.first!.sunrise
    }
    return sunrise
}

//same as above but for sunset
func getSunsetTime(values: [Values], sunsetPassed:Bool) -> String{
    var sunset = ""
    if(sunsetPassed){
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
                sunset = i.sunset
            }
        }
    } else {
        sunset = values.first!.sunset
    }
    return sunset
}

/**
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
*/

//changes the lat/long to a string of the location, makes api call to open weather
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
