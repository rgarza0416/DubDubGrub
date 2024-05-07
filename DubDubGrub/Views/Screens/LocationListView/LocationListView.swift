//
//  LocationListView.swift
//  DubDubGrub
//
//  Created by Ricardo Garza on 1/21/24.
//

import SwiftUI

struct LocationListView: View {
    
//    This was used for dummy data
//    @State private var locations: [DDGLocation] = [DDGLocation(record: MockData.location)]
    // this code down below is for real data
    @EnvironmentObject private var locationManager: LocationManager
    @State private var viewModel = LocationListViewModel()
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(locationManager.locations) { location in
                    NavigationLink(value: location) {
                        LocationCell(location: location, profiles: viewModel.checkedInProfiles[location.id, default: []])
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel(Text(viewModel.createVoiceOverSummary(for: location)))
                    }
                    
                    //old navigationLink WITH the NEW ONE you pass in a VALUE, THEN YOU have to use the DESTINATION that WAS in this old code, and add it to the bottom modifier (.navigationDestination) which holds the destination
                    
//                    NavigationLink(destination: viewModel.createLocationDetailView(for: location, in: dynamicTypeSize)) {
//                        LocationCell(location: location, profiles: viewModel.checkedInProfiles[location.id, default: []])
//                            .accessibilityElement(children: .ignore)
//                            .accessibilityLabel(Text(viewModel.createVoiceOverSummary(for: location)))
//                    }
                }
                
            }
                .navigationTitle("Grub Spots")
                .navigationDestination(for: DDGLocation.self, destination: { location in
                    viewModel.createLocationDetailView(for: location, in: dynamicTypeSize)
                })
                .listStyle(.plain)
                .task { await viewModel.getCheckedInProfilesDictionary() }
                .refreshable { await viewModel.getCheckedInProfilesDictionary() }
                .alert(item: $viewModel.alertItem, content: { $0.alert })
        }
    }
}

#Preview {
    LocationListView()
}





