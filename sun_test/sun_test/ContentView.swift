//
//  ContentView.swift
//  sun_test
//
//  Created by Lena Fleischer on 1/30/23.
//

import SwiftUI

let grayBlue = Color(red: 0.4353, green: 0.6392, blue: 0.8588)
let gray = Color(red: 0.3098, green: 0.3765, blue: 0.4471)

let backgroundGood = LinearGradient(
    colors: [Color.pink, Color.orange],
    startPoint: .top, endPoint: .bottom)
let backgroundBad = LinearGradient(
    colors: [gray, grayBlue],
    startPoint: .top, endPoint: .bottom)
let backgroundFine = LinearGradient(
    colors: [Color.blue, Color.yellow],
    startPoint: .top, endPoint: .bottom)

struct ContentView: View {
    
    //Binding allows us to get the location from a different view
    @Binding var location: String
    @Binding var sunrisePer: Double
    @Binding var sunsetPer: Double
    
    private let states: [String] =  ["Sunset", "Sunrise"]

    var body: some View {
        
        VStack{
            TabView{
                ForEach(states, id: \.self){ state in
                    ZStack{
                        let percentageAndCondition = getPercentageAndCondition (riseOrSet: state)
                        var cloudPercentage  = percentageAndCondition.0
                        let condition = percentageAndCondition.1
                        
                        if (condition == "good"){
                            ZStack{
                                backgroundGood
                                VStack{
                                    Text(location)
                                        .foregroundColor(Color.white)
                                    Text("Cloud Cover \(String(cloudPercentage))%")
                                        .foregroundColor(Color.white)
                                    Text("\(state) is good!")
                                        .foregroundColor(Color.white)
                                }
                            }
                        }
                        else if (condition == "bad"){
                            ZStack{
                                backgroundBad
                                VStack{
                                    Text(state)
                                        .foregroundColor(Color.white)
                                    Text(location)
                                        .foregroundColor(Color.white)
                                    Text("Cloud Cover \(String(cloudPercentage))%")
                                        .foregroundColor(Color.white)
                                    Text("\(state) is bad!")
                                        .foregroundColor(Color.white)
                                }
                            }
                        }
                        else {
                            ZStack{
                                backgroundFine
                                VStack{
                                    Text(state)
                                        .foregroundColor(Color.white)
                                    Text(location)
                                        .foregroundColor(Color.white)
                                    Text("Cloud Cover \(String(cloudPercentage))%")
                                        .foregroundColor(Color.white)
                                    Text("\(state) is fine!")
                                        .foregroundColor(Color.white)
                                }
                            }
                        }
                    }
                }
            }
            .tabViewStyle(.page)
        }
        
    }
    func getPercentageAndCondition (riseOrSet: String) -> (Double, String){
        if (riseOrSet == "Sunrise"){
            
            return (sunrisePer, getQuality(cloudCover: sunrisePer))
        }
        else{
            return (sunsetPer, getQuality(cloudCover: sunsetPer))
        }
        
    }
}



func getQuality(cloudCover: Double) -> String{
    var condition = ""
    if (cloudCover < 30){
        condition = "fine"
    }
    else if (cloudCover > 60){
        condition = "bad"
    }
    else {
        condition = "good"
    }
    return condition
}

