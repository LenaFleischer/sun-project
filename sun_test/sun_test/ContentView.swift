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
    
    let model = try! newmodel()
    
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
                        let cloudPercentage  = percentageAndCondition.0
                        let condition = percentageAndCondition.1
                        // these if statements change the background color
                        if (condition == "good"){
                            backgroundGood
                        }
                        else if (condition == "bad"){
                            backgroundBad
                        }
                        else{
                            backgroundFine
                        }
                        VStack{
                            if (state == "Sunrise"){
                                getImage(riseOrSet: state)
                                    .resizable()
                                    .scaledToFit()
                            }
                            Text(location)
                                .foregroundColor(Color.white)
                                .font(.system(size: 30, weight: .light, design: .serif))
                            Text("Cloud Cover \(String(cloudPercentage))%")
                                .foregroundColor(Color.white)
                                .font(.system(size: 30, weight: .light, design: .serif))
                            Text("\(state) is \(condition)!")
                                .foregroundColor(Color.white)
                                .font(.system(size: 30, weight: .light, design: .serif))
                            if (state == "Sunset"){
                                getImage(riseOrSet: state)
                                    .resizable()
                                    .scaledToFit()
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

func getImage(riseOrSet: String)-> Image{
    if (riseOrSet == "Sunrise"){
        return Image("sunrise")
    }
    else{
        return Image("sunset")
    }
}
