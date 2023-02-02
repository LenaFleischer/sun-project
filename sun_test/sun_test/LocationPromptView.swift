//
//  LocationPromptView.swift
//  sun_test
//
//  Created by Ellen Moore on 2/1/23.
//

import Foundation
import SwiftUI

let backgroundColor = LinearGradient(
    colors: [Color.pink, Color.orange],
    startPoint: .top, endPoint: .bottom)
//var city =  ""
//var state =  ""

var location = ""


struct LocationPrompt: View {
    @State private var city: String = ""
    @State private var state: String = ""
    //@State private var location = ""
    @State var areYouGoingToSecondView = false
    @State var location: String = ""

    
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
                        NavigationLink(destination: ContentView(location: $location), isActive: $areYouGoingToSecondView) { EmptyView() }
                            Button(action: {location = city.replacingOccurrences(of: " ", with: "") + "," + state
                                self.areYouGoingToSecondView = true
                                print(location)
                                callAPI()
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


// andys code to call the api
func callAPI() {
    guard let url = URL(string: "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/weatherdata/forecast?locations=" + location + "&aggregateHours=1&forecastDays=1&unitGroup=us&shortColumnNames=false&contentType=csv&key=4UR84GUK6HRFRTNBQXWNSVFJ4")
    else{
        return
    }
    let task = URLSession.shared.dataTask(with: url){
        data, response, error in
        
        if let data = data, let string = String(data: data, encoding: .utf8){
            print(string)
        } else {
        }
    }
    task.resume()
}


// This function will get the condition of the sunrise to use in ContentView
// Will use the callAPI() func
func getCondition() {
    
}

