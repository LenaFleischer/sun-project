//
//  LocationPromptView.swift
//  sun_test
//
//  Created by Ellen Moore on 2/1/23.
//

import Foundation
import SwiftUI
import Combine

let backgroundColor = Color(red: 0.75, green: 0.83, blue: 0.95)


struct LocationPrompt: View {

    @State private var city: String = ""
    @State private var state: String = ""
    @State var goToLocationPrompt = false
    @State var userLocation: String = ""
    @State var thisSunriseCloudCover:Double = -1
    @State var thisSunsetCloudCover:Double = -1
    
    
    //variables for location service
    @StateObject var locationService = LocationService.shared
    @State var tokens: Set<AnyCancellable> = []
    @State var coordinates: (lat: Double, lon:Double) = (0,0)
    
    var body: some View {
        NavigationView {
        ZStack{
            backgroundColor
            
                VStack {
                    Image("Logo")
//                    Text("Latitude: \(coordinates.lat)")
//                    Text("Longitude: \(coordinates.lon)")
                    
                    HStack{
                        if (coordinates.lat != 0 && coordinates.lon != 0){
                            Text("Use Current Location")
                                .font(.system(size: 30, weight: .light, design: .serif))
                            // use current location button
                            NavigationLink(destination: ContentView(location: $userLocation, sunrisePer: $thisSunriseCloudCover, sunsetPer: $thisSunsetCloudCover), isActive: $goToLocationPrompt) { EmptyView() }
                            Button(action: {
                                self.goToLocationPrompt = true
                                let roundedLat = Double(round(1000 * coordinates.lat) / 1000)
                                let roundedLon = Double(round(1000 * coordinates.lon) / 1000)
                                userLocation = String(roundedLat) + "," + String(roundedLon)
                                decodeAPI(userLocation: userLocation) { (sunriseCloudCover,sunsetCloudCover) in
                                    thisSunriseCloudCover = sunriseCloudCover
                                    thisSunsetCloudCover = sunsetCloudCover
                                    
                                    print(thisSunriseCloudCover)
                                    print(thisSunsetCloudCover)
                                }
                                //userLocation = getLocationFromLatLon(lat: roundedLat, lon: roundedLon)
                                
                            }
                                   , label: {
                                Image(systemName: "arrow.right.square")
                                    .font(.title)
                            })
                        }
                        
                    }
                    HStack {
                        TextField("Enter Your City", text: $city)
                            .textFieldStyle(.roundedBorder)
                            .font(.system(size: 20, weight: .light, design: .serif))
                        TextField("Enter Your State", text: $state)
                            .textFieldStyle(.roundedBorder)
                            .font(.system(size: 20, weight: .light, design: .serif))
                        
                        // this is to allow the button to open the LocationPromptView
                        NavigationLink(destination: ContentView(location: $userLocation, sunrisePer: $thisSunriseCloudCover, sunsetPer: $thisSunsetCloudCover), isActive: $goToLocationPrompt) { EmptyView() }
                            Button(action: {userLocation = city.replacingOccurrences(of: " ", with: "") + "," + state
                                self.goToLocationPrompt = true
                                print(userLocation)
                                
                                decodeAPI(userLocation: userLocation) { (sunriseCloudCover,sunsetCloudCover) in
                                    thisSunriseCloudCover = sunriseCloudCover
                                    thisSunsetCloudCover = sunsetCloudCover
                                    
                                    print(thisSunriseCloudCover)
                                    print(thisSunsetCloudCover)
                                }
                                userLocation = userLocation.replacingOccurrences(of: ",", with: ", ")
                            }
                                   , label: {
                                Image(systemName: "arrow.right.square")
                                    .font(.title)
                            })
                        
                    }
                    
                }
                .onAppear(){
                    observeCoordinateUpdates()
                    observeLocationAccessDenied()
                    locationService.requestLocationUpdates()
                }
            }
            
        }
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


struct LocationPrompt_Previews: PreviewProvider {
    static var previews: some View {
        LocationPrompt()
    }
}
