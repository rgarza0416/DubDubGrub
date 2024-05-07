//
//  LocationMapViewModel.swift
//  DubDubGrub
//
//  Created by Ricardo Garza on 1/24/24.
//

import MapKit
import CloudKit
import SwiftUI


extension LocationMapView {
    
   @Observable final class LocationMapViewModel: NSObject, CLLocationManagerDelegate {
        
        var checkedInProfiles: [CKRecord.ID: Int] = [:]
        var isShowingDetailView = false
        var isShowingLookAround = false
       var route: MKRoute? 
//        var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054),
//                                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//       

        var alertItem: AlertItem?
        var cameraPosition: MapCameraPosition = .region(.init(center: CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054), latitudinalMeters: 1200, longitudinalMeters: 1200))
       
       var lookAroundScene: MKLookAroundScene? {
           didSet {
               if let _ = lookAroundScene {
                   isShowingLookAround = true
               }
           }
       }
       
        
        let deviceLocationManager = CLLocationManager()
        
        override init() {
            super.init()
            deviceLocationManager.delegate = self
        }
        
        func requestAllowOnceLocationPermission() {
            deviceLocationManager.requestLocation()
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let currentLocation = locations.last else { return }
            
            withAnimation {
//                region = MKCoordinateRegion(center: currentLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                
                cameraPosition = .region(.init(center: currentLocation.coordinate, latitudinalMeters: 1200, longitudinalMeters: 1200))
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("did fail with error")
        }
        
        @MainActor func getLocations(for locationManager: LocationManager) {
            Task {
                do {
                    locationManager.locations = try await CloudKitManager.shared.getLocation()
                } catch {
                    alertItem = AlertContext.unableToGetLocations
                }
            }
            
            
            
//            CloudKitManager.shared.getLocations { [self] result in
//                DispatchQueue.main.async {
//                    switch result {
//                    case .success(let locations):
//                        locationManager.locations = locations
//                    case .failure(_):
//                        alertItem = AlertContext.unableToGetLocations
//                    }
//                }
//            }
        }
        
        @MainActor func getCheckedInCounts() {
            Task {
                do {
                    checkedInProfiles = try await CloudKitManager.shared.getCheckedInProfilesCount()
                } catch {
                    alertItem = AlertContext.checkedInCount
                }
            }
        }
        
        @MainActor @ViewBuilder func  createLocationDetailView(for location: DDGLocation, in dynamicTypeSize: DynamicTypeSize) -> some View {
            if dynamicTypeSize >= .accessibility3 {
                LocationDetailView(viewModel: LocationDetailViewModel(location: location)).embedInScrollView()
            } else {
                LocationDetailView(viewModel: LocationDetailViewModel(location: location))
            }
        }
       
       @MainActor
       func getLookAroundScene(for location: DDGLocation) {
           Task {
               let request = MKLookAroundSceneRequest(coordinate: location.location.coordinate)
               lookAroundScene = try? await request.scene
           }
       }
       
       @MainActor
       func getDirections(to location: DDGLocation) {
           guard let userLocation = deviceLocationManager.location?.coordinate else { return }
           let destination = location.location.coordinate
           
           let request = MKDirections.Request()
           request.source = MKMapItem(placemark: .init(coordinate: userLocation))
           request.destination = MKMapItem(placemark: .init(coordinate: destination))
           request.transportType = .walking
           
           Task {
               let directions = try? await MKDirections(request: request).calculate()
               route = directions?.routes.first
           }
       }
    }
}

