//
//  AddLocation.swift
//  sun_test
//
//  Created by Ellen Moore on 2/13/23.
//


import SwiftUI


struct AddLocation: View {
    @State private var city: String = ""
    var body: some View {
        ZStack{
            backgroundC
            VStack{
                Text("Please Enter A Location")
                    .foregroundColor(Color.white)
                    .font(.system(size: 30, weight: .light, design: .serif))

                TextField("Enter Your City", text: $city)
                    .textFieldStyle(.roundedBorder)
                    .font(.system(size: 20, weight: .light, design: .serif))
                    .background(Color.white)
                    .opacity(0.3)
            }
        }
    }
}
