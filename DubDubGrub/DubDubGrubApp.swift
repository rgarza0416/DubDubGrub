//
//  DubDubGrubApp.swift
//  DubDubGrub
//
//  Created by Ricardo Garza on 1/18/24.
//

import SwiftUI

@main
struct DubDubGrubApp: App {
    
    let locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            AppTabView()
                .environmentObject(locationManager)
        }
    }
}
