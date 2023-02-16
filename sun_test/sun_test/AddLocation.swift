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

    @State var printError = false
    
    @ObservedObject private var autocomplete = AutocompleteObject()
    
    var body: some View {
        NavigationView{
            ZStack{
                backgroundC
                    .background(pinky.edgesIgnoringSafeArea(.top))
                    .background(orangey.edgesIgnoringSafeArea(.bottom))
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
                            .font(.system(size: 22, weight: .bold, design: .default))
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
                        if( location != "" && location == autocomplete.suggestions[0] ){
                            goToCompositePage = true
                            decodeAPI(userLocation: location.replacingOccurrences(of: " ", with: "")) { (sunriseCloudCover,sunsetCloudCover) in
                                locationArray.append(location)
                                locDict[location] = [sunriseCloudCover, sunsetCloudCover]
                            }
                        } else if (location != ""){
                            printError = true
                        }
                    }
                           , label: {
                        Text("Add Location")
                            .padding([.leading], 5)
                            .padding([.trailing], 5)
                            .padding([.top], 5)
                            .padding([.bottom], 5)
                            .font(.system(size: 20, weight: .bold, design: .default))
                        //Image(systemName: "arrow.right.square")
                            //.foregroundColor(Color.white)
                        
                    }).buttonStyle(.borderedProminent)
                        .tint(Color(red: 1.00, green: 1.00, blue: 1.00, opacity: 0.3))
                        .padding([.bottom],20)
                        .padding([.top],20)
                    if(printError){
                        Text("Please select location from list")
                            .font(.system(size: 16, design: .default))
                            .foregroundColor(.white)
                            .padding([.bottom],10)
                    }
                }
            }
        }
        // this hised the back button
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}
