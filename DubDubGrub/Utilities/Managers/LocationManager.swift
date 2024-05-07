//
//  LocationManager.swift
//  DubDubGrub
//
//  Created by Ricardo Garza on 1/24/24.
//

import Foundation

final class LocationManager: ObservableObject {
    
    @Published var locations: [DDGLocation] = []
    var selectedLocation: DDGLocation?
}
