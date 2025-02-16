//
//  LocationMapView.swift
//  DubDubGrub
//
//  Created by Ricardo Garza on 1/21/24.
//
import CoreLocationUI
import SwiftUI
import MapKit

struct LocationMapView: View {
    
    
    @EnvironmentObject private var locationManager: LocationManager
    @State private var viewModel = LocationMapViewModel()
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    var body: some View {
        ZStack(alignment: .top) {
            
            Map(initialPosition: viewModel.cameraPosition) {
                ForEach(locationManager.locations) { location in
                    Annotation(location.name, coordinate: location.location.coordinate) {
                        DDGAnnotation(location: location, number: viewModel.checkedInProfiles[location.id, default: 0])
                            .onTapGesture {
                                locationManager.selectedLocation = location
                                viewModel.isShowingDetailView = true
                            }
                            .contextMenu {
                                Button("Look Around", systemImage: "eyes") {
                                    viewModel.getLookAroundScene(for: location)
                                }
                                Button("Get Directions", systemImage: "arrow.triangle.turn.up.right.circle") {
                                    viewModel.getDirections(to: location)
                                }
                            }
                    }
                    .annotationTitles(.hidden)
                }
                UserAnnotation()
                
                if let route = viewModel.route {
                    MapPolyline(route)
                        .stroke(.brandPrimary, lineWidth: 8)
                }
            }
            .lookAroundViewer(isPresented: $viewModel.isShowingLookAround, initialScene: viewModel.lookAroundScene)
            .tint(.grubRed)
            .mapStyle(.standard)
            .mapControls {
                MapCompass()
                MapUserLocationButton()
                MapPitchToggle()
                MapScaleView()
            }
            
/// OLD MAP CODE FOR IOS16 and BELOW
//            Map(coordinateRegion: $viewModel.region, showsUserLocation: true, annotationItems: locationManager.locations) { location in
//                MapAnnotation(coordinate: location.location.coordinate, anchorPoint: CGPoint(x: 0.5, y: 0.75)) {
//                    DDGAnnotation(location: location, number: viewModel.checkedInProfiles[location.id, default: 0])
//                        .onTapGesture {
//                            locationManager.selectedLocation = location
//                            viewModel.isShowingDetailView = true
//                        }
//                }
//            }
//            .tint(.grubRed)
//            .ignoresSafeArea()
            
                LogoView(frameWidth: 125).shadow(radius: 10)
        }
        .sheet(isPresented: $viewModel.isShowingDetailView) {
            NavigationStack {
                viewModel.createLocationDetailView(for: locationManager.selectedLocation!, in: dynamicTypeSize)
                    .toolbar {
                        Button("Dismiss", action: {viewModel.isShowingDetailView = false})
                    }
            }
        }
        .overlay(alignment: .bottomLeading) {
            LocationButton(.currentLocation) {
                viewModel.requestAllowOnceLocationPermission()
            }
            .foregroundColor(.white)
            .symbolVariant(.fill)
            .tint(.grubRed)
            .labelStyle(.iconOnly)
            .clipShape(Circle())
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 40, trailing: 0))
        }
        .alert(item: $viewModel.alertItem, content: { $0.alert })
        .task {
            if locationManager.locations.isEmpty {
                viewModel.getLocations(for: locationManager)
            }
            
            viewModel.getCheckedInCounts()
        }
    }
}

#Preview {
    LocationMapView().environmentObject(LocationManager())
}

