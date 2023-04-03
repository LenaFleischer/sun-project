//
//  AddLocation.swift
//  sun_test
//
//  Created by Ellen Moore on 2/13/23.
//



import Foundation
import SwiftUI
import Combine
import UIKit
import CoreML

struct AddLocation: View {
    @State var goToCompositePage = false
    @State var location: String = ""
    @State var locationArray: [String] = []


    @State var listError = false // for if a user adds without selecting from suggestions
    
    // object so autocomplete works
    @ObservedObject private var autocomplete = AutocompleteObject()
        //variables for location service
    @StateObject var locationService = LocationService.shared
    @State var tokens: Set<AnyCancellable> = []
    @State var coordinates: (lat: Double, lon:Double) = (0,0)
    
    var body: some View {
        NavigationView{
            ZStack{
                //background plus covering white spaces at top and bottom
                backgroundC
                    .background(pinky.edgesIgnoringSafeArea(.top))
                    .background(orangey.edgesIgnoringSafeArea(.bottom))

                VStack{
                    Image("introSun")
                        .resizable()
                        .scaledToFit()
                        .padding()
                    HStack{
                        //hstack for search bar w/ magnifying glass and text field
                        Image(systemName: "magnifyingglass")
                            .padding([.leading],10)
                            .padding([.trailing],5)
                            .foregroundColor(.white)
                        TextField("Enter Location", text: $location)
                            .font(.system(size: 30, design: .default))
                            .foregroundColor(.white)
                        //autocompletes location
                            .onChange(of: location) { newValue in
                                autocomplete.autocomplete(location)
                            }
                        //making background of textfield look opaque
                    }.background(Color(red: 1.00, green: 0.74, blue: 0.61))
                        .cornerRadius(10)
                        .padding([.leading], 40)
                        .padding([.trailing], 40)
                        .padding([.top], 20)
                        .padding([.bottom], 20)
                    //autocompleted suggestions that are displayed in a lazy vstack
                    LazyVStack(alignment: .leading) {
                        ForEach(autocomplete.suggestions, id: \.self) { suggestion in
                            Text(suggestion)
                                .font(.system(size: 22, weight: .bold, design: .default))
                                .foregroundColor(.white)
                                .padding([.bottom],2)
                                .padding([.leading], 40)
                            //makes the tapped location the text in the text field
                                .onTapGesture {
                                    location = suggestion
                                }
                        }
                    }
                    
                    NavigationLink(destination: CompositePage(locationArray: $locationArray), isActive: $goToCompositePage) { EmptyView() }
                    //add location button that when pressed creates location
                    
                    
                    Button(action: {
                        if (coordinates.lat != 0 && coordinates.lon != 0 && currLocation == ""){
                            let roundedLat = Double(round(1000 * coordinates.lat) / 1000)
                            let roundedLon = Double(round(1000 * coordinates.lon) / 1000)
                            let userLocation = String(roundedLat) + "," + String(roundedLon)
                            getLocationFromLatLon(lat: roundedLat, lon: roundedLon) { (location)  in
                                currLocation = location
                                print(currLocation)
                                decodeAPI(userLocation: userLocation) { (sunrisePrediction,sunsetPrediction, sunriseTime, sunsetTime) in
                                    locationArray.insert(currLocation, at: 0)
                                    percentDict[currLocation] = [sunrisePrediction, sunsetPrediction]
                                    timeDict[currLocation] = [sunriseTime, sunsetTime]
                                    print(locationArray)
                                    print(percentDict)
                                    print(timeDict)
                                }
                            }
                        }
                        // if location is not empty but there are no suggestions
                        // Lena's edit 3/30/23
                        if (location != "" && autocomplete.suggestions.count == 0){
                            listError = true
                        }
                        
                        // if location is not empty AND we have chosen from the list
                        else if( location != "" && location == autocomplete.suggestions[0] ){
                            goToCompositePage = true
                            decodeAPI(userLocation: location.replacingOccurrences(of: " ", with: "")) { (sunrisePrediction,sunsetPrediction, sunriseTime, sunsetTime) in
                                // so that the current location is always on top
                                    // but the other locations are in order of when they were added
                                    // if there is a current location
                                if (locationArray.count == 0 && coordinates.lat != 0 && coordinates.lon != 0 && currLocation == "") {
                                    locationArray.insert(location, at: 0)
                                } else {
                                    // check to see if location is already in array (we dont want duplicates)
                                    // maybe later make it be the second element
                                    if !locationArray.contains(location){
                                        locationArray.insert(location, at: 1)
                                    }
                                    
                                }
                                
                                percentDict[location] = [sunrisePrediction, sunsetPrediction]
                                timeDict[location] = [sunriseTime, sunsetTime]
                                print(locationArray)
                                print(percentDict)
                                print(timeDict)
                            }
                            
                        // If there are available
                        } else if (location != ""){
                            listError = true
                        }
                    }
                           //button that adds the location
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
                    
                    if (coordinates.lat != 0 && coordinates.lon != 0 && currLocation == ""){
                        Button(action: {
                            goToCompositePage = true
                            let roundedLat = Double(round(1000 * coordinates.lat) / 1000)
                            let roundedLon = Double(round(1000 * coordinates.lon) / 1000)
                            let userLocation = String(roundedLat) + "," + String(roundedLon)
                            getLocationFromLatLon(lat: roundedLat, lon: roundedLon) { (location)  in
                                currLocation = location
                                print(currLocation)
                                decodeAPI(userLocation: userLocation) { (sunrisePrediction,sunsetPrediction, sunriseTime, sunsetTime) in
                                    locationArray.insert(currLocation, at: 0)
                                    percentDict[currLocation] = [sunrisePrediction, sunsetPrediction]
                                    timeDict[currLocation] = [sunriseTime, sunsetTime]
                                    print(locationArray)
                                    print(percentDict)
                                    print(timeDict)
                                }
                            }
                        }
                               //button that adds the location
                               , label: {
                            Text("See Current Location")
                                .font(.system(size: 20, weight: .bold, design: .default))

                        }).buttonStyle(.borderedProminent)
                            .tint(Color(red: 1.00, green: 1.00, blue: 1.00, opacity: 0.3))
                    }
                    //error message is button is pressed when there is an invalid location
                    if(listError){
                        Text("Please select a recognized location.")
                            .font(.system(size: 16, design: .default))
                            .foregroundColor(.white)
                            .padding([.bottom],10)
                    }

                }
            }.onAppear(){
                observeCoordinateUpdates()
                observeLocationAccessDenied()
                locationService.requestLocationUpdates()
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                AppDelegate.orientationLock = .portrait
            }
        }
        // this hised the back button
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
        func observeCoordinateUpdates(){
        locationService.coordinatesPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            } receiveValue: { coordinates in
                self.coordinates = (coordinates.latitude, coordinates.longitude)
            }
            .store(in: &tokens)
    }
    
    
    func observeLocationAccessDenied(){
        locationService.deniedLocationAccessPublisher
            .receive(on: DispatchQueue.main)
            .sink {
                print("Show some kind of alert to the user")
            }
            .store(in: &tokens)
    }
}
