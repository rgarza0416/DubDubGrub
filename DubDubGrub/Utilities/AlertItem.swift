//
//  AlertItem.swift
//  DubDubGrub
//
//  Created by Ricardo Garza on 1/24/24.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
    
    var alert: Alert {
        Alert(title: title, message: message, dismissButton: dismissButton)
    }
}

struct AlertContext {
    
    
 //MARK: - MapView Errors

    static let unableToGetLocations = AlertItem(title: Text("Locations Error"),
                                                message: Text("Unable to retrieve locations at this time. \nPlease try again."),
                                                dismissButton: .default(Text("Ok")))
    
    static let locationRestricted = AlertItem(title: Text("Locations Restricted"),
                                                message: Text("Your location is restricted. This may be due to parental controls."),
                                                dismissButton: .default(Text("Ok")))
    
    static let locationDenied = AlertItem(title: Text("Locations Denied"),
                                                message: Text("Dub Dub Grub does not have permission to access your location. To change that go to your phone's Setting > Dub Dub Grub > Location."),
                                                dismissButton: .default(Text("Ok")))
    
    static let locationDisabled = AlertItem(title: Text("Locations Disabled"),
                                                message: Text("Your phone's location services are disabled. To change that go to your phone's Setting > Privacy > Location Services."),
                                                dismissButton: .default(Text("Ok")))
    
    
    static let checkedInCount = AlertItem(title: Text("Server Error"),
                                                message: Text("Unable to get the number of people checked into each location. Please check your internet and try again."),
                                                dismissButton: .default(Text("Ok")))

    
    
    //MARK: - ProfileView Errors

       static let invalidProfile = AlertItem(title: Text("Invalid Profile"),
                                                   message: Text("All fields are required as well as a profile photo. Your bio must be < 100 characters.\nPlease try again."),
                                                   dismissButton: .default(Text("Ok")))
    
    
    static let noUserRecord = AlertItem(title: Text("No User Record"),
                                                message: Text("You must log into iCloud on your phone in order to utilize Dub Dub Grub's Profile. Please log into your phone's settings screen."),
                                                dismissButton: .default(Text("Ok")))
    
    
    static let createProfileSuccess = AlertItem(title: Text("Profile Created Successfully"),
                                                message: Text("Your profile has successfully been created."),
                                                dismissButton: .default(Text("Ok")))
    
    static let createProfileFailure = AlertItem(title: Text("Failed to Create Profile"),
                                                message: Text("We were unable to create your profile at this time.\n Please try again later on contact customer supper if this persist."),
                                                dismissButton: .default(Text("Ok")))
    
    static let unableToGetProfile = AlertItem(title: Text("Unable to Retrieve Profile"),
                                                message: Text("We were unable to retrieve your profile at this time. Please check your internet connection and try again later on contact customer supper if this persist."),
                                                dismissButton: .default(Text("Ok")))
    
    
    static let updateProfileSuccess = AlertItem(title: Text("Profile Update Success!"),
                                                message: Text("Your Dub Dub Grub Profile was updated successfully."),
                                                dismissButton: .default(Text("Sweet!")))
    
    static let updateProfileFailure = AlertItem(title: Text("Profile Update Failed"),
                                                message: Text("We were unable to update your profile at this time.\n Please try again later."),
                                                dismissButton: .default(Text("Ok")))



    //MARK: - LocationDetailView Errors

       static let invalidPhoneNumber = AlertItem(title: Text("Invalid Phone Number"),
                                                   message: Text("The phone number for the location is invalid. Please look up the phone number."),
                                                   dismissButton: .default(Text("Ok")))
    
    static let unableToGetCheckedInStatus = AlertItem(title: Text("Server Error"),
                                                message: Text("Unable to retrieve checked in status of the current user.\nPlease try again."),
                                                dismissButton: .default(Text("Ok")))
    
    static let unableToCheckInOrOut = AlertItem(title: Text("Server Error"),
                                                message: Text("We are unable to check in/out at this time.\nPlease try again."),
                                                dismissButton: .default(Text("Ok")))
    
    static let unableToGetCheckInProfiles = AlertItem(title: Text("Server Error"),
                                                message: Text("We are unable to get users checked into this location at this time.\nPlease try again."),
                                                dismissButton: .default(Text("Ok")))
    
    
    //MARK: - LocationListView Errors

       static let unableToGetAllCheckedInProfiles = AlertItem(title: Text("Invalid Phone Number"),
                                                   message: Text("The phone number for the location is invalid. Please look up the phone number."),
                                                   dismissButton: .default(Text("Ok")))
    
}
