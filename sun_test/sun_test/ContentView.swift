//
//  ContentView.swift
//  sun_test
//
//  Created by Lena Fleischer on 1/30/23.
//

import SwiftUI

let backgroundGood = LinearGradient(
    colors: [Color.pink, Color.orange],
    startPoint: .top, endPoint: .bottom)
let backgroundBad = LinearGradient(
    colors: [Color.black, Color.blue],
    startPoint: .top, endPoint: .bottom)
let backgroundFine = LinearGradient(
    colors: [Color.blue, Color.yellow],
    startPoint: .top, endPoint: .bottom)

struct ContentView: View {
    
    //Binding allows us to get the location from a different view
    //@State var location = "Springfield,MO"
    @Binding var userLocation: String
    
    var body: some View {
        
        let clouds = 50
        let condition = getQuality(cloudCover: clouds)
        if (condition == "good"){
            ZStack{
                backgroundGood
                VStack{
                    Text("Sunrise is good!")
                        .foregroundColor(Color.white)
                        .padding()
                }
            }
        }
        else if (condition == "bad"){
            ZStack{
                backgroundBad
                VStack{
                    Text("Sunrise is bad!")
                        .padding()
                }
            }
        }
        else {
            ZStack{
                backgroundFine
                VStack{
                    Text(userLocation)
                    Text("Sunrise is fine!")
                        .padding()
                }
            }
        }
        
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}


func getQuality(cloudCover: Int) -> String{
    var condition = ""
    if (cloudCover < 25){
        condition = "good"
    }
    else if (cloudCover > 75){
        condition = "bad"
    }
    else {
        condition = "fine"
    }
    return condition
}
