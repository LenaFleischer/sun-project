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


struct LocationPrompt: View {
    @State private var city: String = ""
    @State private var state: String = ""
    @State var goToLocationPrompt = false
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
                        // this is to allow the button to open the LocationPromptView
                        NavigationLink(destination: ContentView(location: $location), isActive: $goToLocationPrompt) { EmptyView() }
                            Button(action: {location = city.replacingOccurrences(of: " ", with: "") + "," + state
                                self.goToLocationPrompt = true
                                print(location)
                                callAPI(location: location)
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
func callAPI(location: String) {
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



