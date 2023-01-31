//
//  LocationPrompt.swift
//  sun_test
//
//  Created by Ellen Moore on 1/31/23.
//

import Foundation
//
//  ContentView.swift
//  sun_test
//
//  Created by Lena Fleischer on 1/30/23.
//

import SwiftUI

let backgroundColor = LinearGradient(
    colors: [Color.pink, Color.orange],
    startPoint: .top, endPoint: .bottom)
//var city =  ""
//var state =  ""


struct LocationPrompt: View {
    @State private var city: String = ""
    @State private var state: String = ""
    
    var body: some View {
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
                    
                    Button(action: get_location(user_city:city, user_state:state), label: {
                                            Image(systemName: "arrow.right.square")
                                                .font(.title)
                                        })
                }
            }
        }
    }
}

func get_location(user_city: String, user_state: String) -> String {
    return user_city + "," + user_state
}


struct LocationPrompt_Previews: PreviewProvider {
    static var previews: some View {
        LocationPrompt()
    }
}
