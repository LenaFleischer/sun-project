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
    var body: some View {
        
        let condition = "fine";
        if (condition == "good"){
            ZStack{
                backgroundGood
                VStack{
                    Text("Sunrise is good!")
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
                    Text("Sunrise is fine!")
                        .padding()
                }
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
