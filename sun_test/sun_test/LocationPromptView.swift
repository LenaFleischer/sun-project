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


struct LocationPrompt: View {
    @State private var city: String = ""
    @State private var state: String = ""
    @State private var location = ""
    @State var areYouGoingToSecondView = false

    
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
                        NavigationLink(destination: ContentView(), isActive: $areYouGoingToSecondView) { EmptyView() }
                            Button(action: {location = city + "," + state
                                self.areYouGoingToSecondView = true
                                print(location)
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
