//
//  LocationDetailViewModel.swift
//  DubDubGrub
//
//  Created by Ricardo Garza on 2/8/24.
//

import SwiftUI
import MapKit
import CloudKit

enum CheckInStatus { case checkedIn, checkedOut }

    
   @MainActor @Observable final class LocationDetailViewModel {
        
        var checkedInProfiles: [DDGProfile] = []
        var alertItem: AlertItem?
        var isShowingProfileModal = false
        var isShowingProfileSheet = false
        var isCheckedIn = false
        var isLoading = false
        
    //    let columns = [GridItem(.flexible()),
    //                   GridItem(.flexible()),
    //                   GridItem(.flexible())]
        
       @ObservationIgnored var location: DDGLocation
       @ObservationIgnored var selectedProfile: DDGProfile?
        var buttonColor: Color { isCheckedIn ? .grubRed : .brandPrimary }
        var buttonImageTitle: String { isCheckedIn ? "person.fill.xmark" : "person.fill.checkmark" }
        var buttonA11yLabel: String { isCheckedIn ? "Check out of location" :"Check into location" }
        
        init(location: DDGLocation) { self.location = location }
        
        func determineColumns(for dynamicTypeSize: DynamicTypeSize) -> [GridItem] {
            let numberOfColumns = dynamicTypeSize >= .accessibility3 ? 1 : 3
            return Array(repeating: GridItem(.flexible()), count: numberOfColumns)
        }
        
        func getDirectionsToLocation() {
            let placemark = MKPlacemark(coordinate: location.location.coordinate)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = location.name
            
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
        }
        
        func callLocation() {
            guard let url = URL(string: "tel://\(location.phoneNumber)") else {
                alertItem = AlertContext.invalidPhoneNumber
                return
            }
            UIApplication.shared.open(url)
        }
        
        func getCheckedInStatus() {
            guard let profileRecordID = CloudKitManager.shared.profileRecordID else { return }
            
            Task {
                do {
                    let record = try await CloudKitManager.shared.fetchRecord(with: profileRecordID)
                    if let reference = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference {
                        isCheckedIn = reference.recordID == location.id
                    } else {
                        isCheckedIn = false
                    }
                } catch {
                    alertItem = AlertContext.unableToGetCheckedInStatus
                }
            }
        }
        
        
        
       func updateCheckInStatus(to checkedInStatus: CheckInStatus) {
           // Retrieve the DDGProfile
           guard let profileRecordID = CloudKitManager.shared.profileRecordID else {
               alertItem = AlertContext.unableToGetProfile
               return
           }
           showLoadingView()
           
           Task {
               do {
                   let record = try await CloudKitManager.shared.fetchRecord(with: profileRecordID)
                   switch checkedInStatus {
                   case .checkedIn:
                       record[DDGProfile.kIsCheckedIn] =  CKRecord.Reference(recordID: location.id, action: .none)
                       record[DDGProfile.kIsCheckedInNilCheck] = 1
                   case .checkedOut:
                       record[DDGProfile.kIsCheckedIn] = nil
                       record[DDGProfile.kIsCheckedInNilCheck] = nil
                   }
                   let savedRecord = try await CloudKitManager.shared.save(record: record)
                   HapticManager.playSuccess()
                   let profile = DDGProfile(record: savedRecord)
                   switch checkedInStatus {
                       
                   case .checkedIn:
                       checkedInProfiles.append(profile)
                   case .checkedOut:
                       checkedInProfiles.removeAll(where:{$0.id == profile.id})
                   }
                   
                   isCheckedIn.toggle()
                   hideLoadingView()
               } catch {
                   alertItem = AlertContext.unableToCheckInOrOut
               }
           }
       }
        
        func getCheckedInProfiles() {
            showLoadingView()
            
            Task {
                do {
                    checkedInProfiles = try await CloudKitManager.shared.getCheckedInProfiles(for: location.id)
                    hideLoadingView()
                } catch {
                    hideLoadingView()
                    alertItem = AlertContext.unableToGetCheckInProfiles
                }
            }
        }
        
        func show(_ profile: DDGProfile, in dynamicTypeSize: DynamicTypeSize) {
            selectedProfile = profile
            if dynamicTypeSize >= .accessibility3 {
                isShowingProfileSheet = true
            } else {
                isShowingProfileModal = true
            }
        }
        private func showLoadingView() { isLoading = true }
        private func hideLoadingView() { isLoading = false }
    }
