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
                    HStack{
                        Image(systemName: "magnifyingglass")
                            .padding([.leading],10)
                            .padding([.trailing],5)
                            .foregroundColor(.white)
                        TextField("Enter Location", text: $location)
                            .font(.system(size: 30, weight: .bold, design: .default))
                            .foregroundColor(.white)
                            .onChange(of: location) { newValue in
                                autocomplete.autocomplete(location)
                            }
                    }.background(Color(red: 1.00, green: 0.74, blue: 0.61))
                        .cornerRadius(10)
                        .padding([.leading], 40)
                        .padding([.trailing], 40)
                        .padding([.top], 20)
                        .padding([.bottom], 20)
                    LazyVStack(alignment: .leading) {
                        ForEach(autocomplete.suggestions, id: \.self) { suggestion in
                            Text(suggestion)
                            .font(.system(size: 25, weight: .bold, design: .default))
                            .foregroundColor(.white)
                            .padding([.bottom],2)
                            .padding([.leading], 40)
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
