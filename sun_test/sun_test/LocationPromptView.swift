//
//  LocationPromptView.swift
//  sun_test
//
//  Created by Ellen Moore on 2/1/23.
//

import Foundation
import SwiftUI

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
    let windchill: Double?
}


let backgroundColor = Color(red: 0.8, green: 0.8706, blue: 1)


struct LocationPrompt: View {
    @State private var city: String = ""
    @State private var state: String = ""
    @State var goToLocationPrompt = false
    @State var userLocation: String = ""
    @State var thisSunriseCloudCover:Double = -1
    @State var thisSunsetCloudCover:Double = -1
    
    var body: some View {
        NavigationView {
        ZStack{
            backgroundColor
            
                VStack {
                    Text("Welcome")
                        .font(.title)
                    HStack {
                        TextField("Enter Your City", text: $city)
                            .textFieldStyle(.roundedBorder)
                        TextField("Enter Your State", text: $state)
                            .textFieldStyle(.roundedBorder)
                        // this is to allow the button to open the LocationPromptView
                        NavigationLink(destination: ContentView(location: $userLocation, sunrisePer: $thisSunriseCloudCover, sunsetPer: $thisSunsetCloudCover), isActive: $goToLocationPrompt) { EmptyView() }
                            Button(action: {userLocation = city.replacingOccurrences(of: " ", with: "") + "," + state
                                self.goToLocationPrompt = true
                                print(userLocation)
                                
                                //(sunriseCloudCover,sunsetCloudCover) = decodeAPI(userLocation: userLocation)
                                decodeAPI(userLocation: userLocation) { (sunriseCloudCover,sunsetCloudCover) in
                                    thisSunriseCloudCover = sunriseCloudCover
                                    thisSunsetCloudCover = sunsetCloudCover
                                    
                                    print(thisSunriseCloudCover)
                                    print(thisSunsetCloudCover)
                                }
                            }
                                   , label: {
                                Image(systemName: "arrow.right.square")
                                    .font(.title)
                            })
                        
                    }
                }
            }
            
        }
    }
}


struct LocationPrompt_Previews: PreviewProvider {
    static var previews: some View {
        LocationPrompt()
    }
}

let returnblock:((Double) -> ()) = { sunsetOrSunrise in
    //sunsetOrSunrise
    return
}

func decodeAPI(userLocation:String, completionHandler: @escaping (Double,Double)->Void){
    var sunsetCloudCover = -1.0
    var sunriseCloudCover = -1.0
    
    guard let url = URL(string: "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/weatherdata/forecast?locations="+userLocation+"&aggregateHours=1&forecastDays=1&unitGroup=us&shortColumnNames=true&contentType=json&locationMode=single&key=4UR84GUK6HRFRTNBQXWNSVFJ4") else{return}

    let task = URLSession.shared.dataTask(with: url){
        data, response, error in
        
        let decoder = JSONDecoder()

        if let data = data{
            do{
                let weatherinfo = try decoder.decode(Weather.self, from: data)
                let sunsetTime = weatherinfo.location.currentConditions.sunset
                let sunriseTime = weatherinfo.location.currentConditions.sunrise
                sunsetCloudCover = findCloudCoverAtSunset(values:weatherinfo.location.values, sunsetTime:sunsetTime)
                sunriseCloudCover = findCloudCoverAtSunrise(values:weatherinfo.location.values, sunriseTime: sunriseTime)
                completionHandler(sunriseCloudCover,sunsetCloudCover)
            }catch{
                print(error)
            }
        }
    }
    task.resume()

}

func findCloudCoverAtSunset(values: [Values], sunsetTime: String) -> Double {
    var chars = Array(sunsetTime)
    chars[14] = "0"
    chars[15] = "0"
    chars[17] = "0"
    chars[18] = "0"
    
    var cloudcover:Double = -1

    let correctedSunsetTime = String(chars)
    values.forEach{ i in
        if(i.datetimeStr == correctedSunsetTime){
            cloudcover = i.cloudcover
        }
    }
    return cloudcover
}

func findCloudCoverAtSunrise(values: [Values], sunriseTime: String) -> Double {
    var chars = Array(sunriseTime)
    
    chars[9] = "4"
    chars[14] = "0"
    chars[15] = "0"
    chars[17] = "0"
    chars[18] = "0"
    
    var cloudcover:Double = -1

    let correctedSunriseTime = String(chars)
    values.forEach{ i in
        if(i.datetimeStr == correctedSunriseTime){
            cloudcover = i.cloudcover
        }
    }
    return cloudcover
}




