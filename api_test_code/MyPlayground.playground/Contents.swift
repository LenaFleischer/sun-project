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
    let snowdepth: Double
    let sealevelpressure: Double
    let snow: Double
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
/**
func callAPI(){
    guard let url = URL(string: "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/weatherdata/forecast?locations=ColoradoSprings,CO&aggregateHours=1&forecastDays=1&unitGroup=us&shortColumnNames=true&contentType=json&locationMode=single&key=4UR84GUK6HRFRTNBQXWNSVFJ4") else{
        return
    }


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

//callAPI()
*/
func decodeAPI(){
    guard let url = URL(string: "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/weatherdata/forecast?locations=ColoradoSprings,CO&aggregateHours=1&forecastDays=1&unitGroup=us&shortColumnNames=true&contentType=json&locationMode=single&key=4UR84GUK6HRFRTNBQXWNSVFJ4") else{return}

    let task = URLSession.shared.dataTask(with: url){
        data, response, error in
        
        let decoder = JSONDecoder()

        if let data = data{
            do{
                let weatherinfo = try decoder.decode(Weather.self, from: data)
                print(weatherinfo.location.values)
            }catch{
                print(error)
            }
        }
    }
    task.resume()

}
decodeAPI()
