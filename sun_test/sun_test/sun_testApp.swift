//
//  sun_testApp.swift
//  sun_test
//
//  Created by Lena Fleischer on 1/30/23.
//

import SwiftUI
@main
struct sun_testApp: App {
    @Environment(\.scenePhase) private var scenePhase
    //@State var locationArray = CompositePage.publicLocationArray
    var body: some Scene {
        WindowGroup {
            AddLocation()
            //if(locationArray.isEmpty){
            //    AddLocation()
            //} else {
            //    CompositePage(locationArray:$locationArray)
            //}
        }
        .onChange(of: scenePhase) { phase in
            if phase == .background {
                
            }
            if phase == .active{
                
            }
        }
    }
}
