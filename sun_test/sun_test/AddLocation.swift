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


    @State var printError = false
    
    @ObservedObject private var autocomplete = AutocompleteObject()
        //variables for location service
    @StateObject var locationService = LocationService.shared
    @State var tokens: Set<AnyCancellable> = []
    @State var coordinates: (lat: Double, lon:Double) = (0,0)
    
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
                            .font(.system(size: 30, design: .default))
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
                         if (coordinates.lat != 0 && coordinates.lon != 0 && currLocation == ""){
                            let roundedLat = Double(round(1000 * coordinates.lat) / 1000)
                            let roundedLon = Double(round(1000 * coordinates.lon) / 1000)
                            let userLocation = String(roundedLat) + "," + String(roundedLon)
                            getLocationFromLatLon(lat: roundedLat, lon: roundedLon) { (location)  in
                                currLocation = location
                                print(currLocation)
                                //FIX HERE!!! NOT CLOUD COVER ANYMORE, PERCENTAGE
                                decodeAPI(userLocation: userLocation) { (sunrisePrediction,sunsetPrediction, sunriseTime, sunsetTime) in
                                    locationArray.insert(currLocation, at: 0)
                                    locDict[currLocation] = [sunrisePrediction, sunsetPrediction]
                                    print(locationArray)
                                    print(locDict)
                                }
                            }
                            
                            
                        }
                        if( location != "" && location == autocomplete.suggestions[0] ){
                            goToCompositePage = true
                            //FIX HERE!!! NOT CLOUD COVER ANYMORE, PERCENTAGE
                            decodeAPI(userLocation: location.replacingOccurrences(of: " ", with: "")) { (sunrisePrediction,sunsetPrediction, sunriseTime, sunsetTime) in
                                // so that the current location is always on top
                                    // but the other locations are in order of when they were added
                                if locationArray.count == 0{
                                    locationArray.insert(location, at: 0)
                                } else {
                                    locationArray.insert(location, at: 1)
                                }
                                
                                locDict[location] = [sunrisePrediction, sunsetPrediction]
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
            }.onAppear(){
                observeCoordinateUpdates()
                observeLocationAccessDenied()
                locationService.requestLocationUpdates()

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
