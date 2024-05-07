//
//  AppTabViewModel.swift
//  DubDubGrub
//
//  Created by Ricardo Garza on 2/13/24.
//

import CoreLocation
import SwiftUI

// EVERYTHING IN THIS FILE THATS COMMENTED OUT WAS ALL COMMENTED OUT ONLY BC WE CREATED THE LOCATION BUTTON. HAD WE NOT DONE THAT, THE CODE THATS COMMENTED OUT WOULD STIL BE VALID AND WORK. THIS CODE HELP POP UP THE PERMISSION TO REQUEST LOCATION


extension AppTabView {
    
    final class AppTabViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
     //   @Published var alertItem: AlertItem?
        @Published var isShowingOnboardView = false
        @AppStorage("hasSeenOnboardView") var hasSeenOnboardView = false {
            didSet { isShowingOnboardView = hasSeenOnboardView }
        }
        
     //   var deviceLocationManager: CLLocationManager?
        let kHasSeenOnboardView = "hasSeenOnboardView"
        
        
        func checkIfHasSeenOnboard() {
            if !hasSeenOnboardView {
                hasSeenOnboardView = true
            }
//            else {
//                checkIfLocationServicesIsEnabled()
//            }
        }
        
//        func checkIfLocationServicesIsEnabled() {
//            if CLLocationManager.locationServicesEnabled() {
//                deviceLocationManager = CLLocationManager()
//                deviceLocationManager!.delegate = self
//            } else {
//                alertItem = AlertContext.locationDisabled
//            }
//        }
        
//      private  func checkLocationAuthorization() {
//            guard let deviceLocationManager = deviceLocationManager else { return }
//            
//            switch deviceLocationManager.authorizationStatus {
//                
//            case .notDetermined:
//                deviceLocationManager.requestWhenInUseAuthorization()
//            case .restricted:
//                alertItem = AlertContext.locationRestricted
//            case .denied:
//                alertItem = AlertContext.locationDenied
//            case .authorizedAlways,.authorizedWhenInUse:
//                break
//            @unknown default:
//                break
//            }
//        }
        
        
//        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//            checkLocationAuthorization()
//        }
    }
}

