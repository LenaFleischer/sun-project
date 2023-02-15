//
//  AddLocation.swift
//  sun_test
//
//  Created by Ellen Moore on 2/13/23.
//


import SwiftUI

struct AddLocation: View {
    @State var goToCompositePage = false
    @State var location: String = ""
    @State var locationArray: [String] = []
    
    @ObservedObject private var autocomplete = AutocompleteObject()
    
    var body: some View {
        NavigationView{
            ZStack{
                backgroundC
                VStack{
                    Image("introSun")
                        .resizable()
                        .scaledToFit()
                        .padding()
                    TextField("Enter Your Location", text: $location)
                        .textFieldStyle(.roundedBorder)
                        .font(.system(size: 20, weight: .light, design: .serif))
                        .background(Color.white)
                        .opacity(0.2)
                        .padding()
                        .onChange(of: location) { newValue in
                            autocomplete.autocomplete(location)
                        }
                    LazyVStack {
                        ForEach(autocomplete.suggestions, id: \.self) { suggestion in
                            Text(suggestion)
                            .font(
                                .custom("Inter", size: 20)
                                .weight(.semibold)
                            )
                            .foregroundColor(.white)
                            .padding([.bottom],5)
                            .onTapGesture {
                                location = suggestion
                            }
                        }
                    }
                    
                   NavigationLink(destination: CompositePage(locationArray: $locationArray), isActive: $goToCompositePage) { EmptyView() }
                    Button(action: {
                        goToCompositePage = true
                        decodeAPI(userLocation: location.replacingOccurrences(of: " ", with: "")) { (sunriseCloudCover,sunsetCloudCover) in
                            locationArray.append(location)
                            locDict[location] = [sunriseCloudCover, sunsetCloudCover]
                        }
                        
                    }
                           , label: {
                        Image(systemName: "arrow.right.square")
                            .foregroundColor(Color.white)
                        
                    })
                }
            }
        }
        // this hised the back button
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}
