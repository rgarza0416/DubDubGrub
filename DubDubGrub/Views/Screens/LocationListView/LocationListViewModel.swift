//
//  LocationListViewModel.swift
//  DubDubGrub
//
//  Created by Ricardo Garza on 2/12/24.
//

import CloudKit
import SwiftUI
import Observation
// we added an extension to the view model, to secure it to the view

extension LocationListView {
    
    @MainActor @Observable final class LocationListViewModel: ObservableObject {
        
         var checkedInProfiles: [CKRecord.ID: [DDGProfile]] = [:]
         var alertItem: AlertItem? 
        
        func getCheckedInProfilesDictionary() async {
                do {
                    checkedInProfiles = try await CloudKitManager.shared.getCheckedInProfilesDictionary()
                } catch {
                    alertItem = AlertContext.unableToGetAllCheckedInProfiles
                }
        }
        
        func createVoiceOverSummary(for location: DDGLocation) -> String {
            let count = checkedInProfiles[location.id, default: []].count
            let personPlurality = count == 1 ? "person" : "people"
            
            return "\(location.name) \(count) \(personPlurality) checked in"

        }
        
         @ViewBuilder func  createLocationDetailView(for location: DDGLocation, in dynamicTypeSize: DynamicTypeSize) -> some View {
            if dynamicTypeSize >= .accessibility3 {
                LocationDetailView(viewModel: LocationDetailViewModel(location: location)).embedInScrollView()
            } else {
                LocationDetailView(viewModel: LocationDetailViewModel(location: location))
            }
        }
    }

}
