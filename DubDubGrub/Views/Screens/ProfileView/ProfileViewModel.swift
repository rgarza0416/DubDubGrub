//
//  ProfileViewModel.swift
//  DubDubGrub
//
//  Created by Ricardo Garza on 2/7/24.
//


import CloudKit

enum ProfileContext { case create, update }

extension ProfileView {
    
    @MainActor @Observable final class ProfileViewModel {
        
        var firstName = ""
        var lastName = ""
        var companyName = ""
        var bio = ""
        var avatar = PlaceholderImage.avatar
        var isShowingPhotoPicker = false
        var isLoading = false
        var isCheckedIn = false
        var alertItem: AlertItem?
        
       @ObservationIgnored private var existingProfileRecord: CKRecord? {
            didSet { profileContext = .update }
        }
        
       @ObservationIgnored  var profileContext: ProfileContext = .create
        var buttonTitle: String { profileContext == .create ? "Create Profile" : "Update Profile" }
        
        func isValidProfile() -> Bool {
            
            guard !firstName.isEmpty,
                  !lastName.isEmpty,
                  !companyName.isEmpty,
                  !bio.isEmpty,
                  avatar != PlaceholderImage.avatar,
                  bio.count <= 100 else { return false }
            
            return true
        }
        
        
        func getCheckedInStatus() {
            guard let profileRecordID = CloudKitManager.shared.profileRecordID else { return }
            
            Task {
                do {
                    let record = try await CloudKitManager.shared.fetchRecord(with: profileRecordID)
                    if let _ = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference {
                        isCheckedIn = true
                    } else {
                        isCheckedIn = false
                    }
                } catch {
                    print("Unable to get checked in status")
                }
            }
        }
        
        
        func checkOut() {
            guard let profileID = CloudKitManager.shared.profileRecordID else {
                alertItem = AlertContext.unableToGetProfile
                return
            }
            showLoadingView()
            
            Task {
                do {
                    let record = try await CloudKitManager.shared.fetchRecord(with: profileID)
                    record[DDGProfile.kIsCheckedIn] = nil
                    record[DDGProfile.kIsCheckedInNilCheck] = nil
                    
                    let _ = try await CloudKitManager.shared.save(record: record)
                    HapticManager.playSuccess()
                    isCheckedIn = false
                    hideLoadingView()
                } catch {
                    hideLoadingView()
                    alertItem = AlertContext.unableToCheckInOrOut
                    
                }
            }
        }
        
        func determineButtonAction() {
            profileContext == .create ? createProfile() : updateProfile()
        }
        
        
        
      private  func createProfile() {
            guard isValidProfile() else {
                alertItem = AlertContext.invalidProfile
                return
            }
            
            // Create our CKRecord from the profile View
            let profileRecord = createProfileRecord()
            guard let userRecord = CloudKitManager.shared.userRecord else {
                alertItem = AlertContext.noUserRecord
                return
            }
            
            userRecord["userProfile"] = CKRecord.Reference(recordID: profileRecord.recordID, action: .none)
            
            showLoadingView()
            
          Task {
              do {
                  let records = try await CloudKitManager.shared.batchSave(records: [userRecord, profileRecord])
                  for record in records where record.recordType == RecordType.profile {
                      existingProfileRecord = record
                      CloudKitManager.shared.profileRecordID = record.recordID
                  }
                  hideLoadingView()
                  alertItem = AlertContext.createProfileSuccess
              } catch {
                  hideLoadingView()
                  alertItem = AlertContext.createProfileFailure
              }
          }
        }
        
        //
        //        // get our UserRecordID from the Container
        //        CKContainer.default().fetchUserRecordID { recordID, error in
        //            guard let recordID = recordID, error == nil else {
        //                print(error!.localizedDescription)
        //                return
        //            }
        //            // Get UserRecord from the Public Database
        //            CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { userRecord, error in
        //                guard let userRecord = userRecord, error == nil else {
        //                    print(error!.localizedDescription)
        //                    return
        //                }
        //
        //                // Create reference on UserRecord to the DDGProfile we created
        //                userRecord["userProfile"] = CKRecord.Reference(recordID: profileRecord.recordID, action: .none)
        //
        //
        ////                // Create a CKOperation to save our User and Profile Records
        //                let operation = CKModifyRecordsOperation(recordsToSave: [userRecord, profileRecord])
        //                operation.modifyRecordsCompletionBlock = { savedRecords, _, error in
        //                    guard let savedRecords = savedRecords, error == nil else {
        //                        print(error!.localizedDescription)
        //                        return
        //                    }
        //                    print(savedRecords)
        //                }
        //                CKContainer.default().publicCloudDatabase.add(operation)
        
        
        
        func getProfile() {
            
            guard let userRecord = CloudKitManager.shared.userRecord else {
                alertItem = AlertContext.noUserRecord
                return
            }
            
            guard let profileReference = userRecord["userProfile"] as? CKRecord.Reference else { return }
            
            let profileRecordID = profileReference.recordID
            
            showLoadingView()
            
            Task {
                do {
                    let record = try await CloudKitManager.shared.fetchRecord(with: profileRecordID)
                    existingProfileRecord = record
                    
                    let profile = DDGProfile(record: record)
                    firstName = profile.firstName
                    lastName = profile.lastName
                    companyName = profile.companyName
                    bio = profile.bio
                    avatar = profile.avatarImage
                    
                    hideLoadingView()
                
                } catch {
                    alertItem = AlertContext.unableToGetProfile
                }
            }
        }
        
        //        CKContainer.default().publicCloudDatabase.fetch(withRecordID: profileRecordID) { profileRecord, error in
        //            guard let profileRecord = profileRecord, error == nil else {
        //                print(error!.localizedDescription)
        //                return
        //            }
        //
        //        }
        
        //        CKContainer.default().fetchUserRecordID { recordID, error in
        //            guard let recordID = recordID, error == nil else {
        //                print(error!.localizedDescription)
        //                return
        //            }
        //            CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { userRecord, error in
        //                guard let userRecord = userRecord, error == nil else {
        //                    print(error!.localizedDescription)
        //                    return
        //                }
        
        
        private   func updateProfile() {
            guard isValidProfile() else {
                alertItem = AlertContext.invalidProfile
                return
            }
            guard let profileRecord = existingProfileRecord else {
                alertItem = AlertContext.unableToGetProfile
                return
            }
            
            profileRecord[DDGProfile.kFirstName] = firstName
            profileRecord[DDGProfile.kLastName] = lastName
            profileRecord[DDGProfile.kCompanyName] = companyName
            profileRecord[DDGProfile.kBio] = bio
            profileRecord[DDGProfile.kAvatar] = avatar.convertToCKAsset()
            
            showLoadingView()
            
            Task {
                do {
                    let _ = try await CloudKitManager.shared.save(record: profileRecord)
                    hideLoadingView()
                    alertItem = AlertContext.updateProfileSuccess
                } catch {
                    alertItem = AlertContext.updateProfileFailure
                }
            }
        }
        
        
        
        private func createProfileRecord() -> CKRecord {
            let profileRecord = CKRecord(recordType: RecordType.profile)
            profileRecord[DDGProfile.kFirstName] = firstName
            profileRecord[DDGProfile.kLastName] = lastName
            profileRecord[DDGProfile.kCompanyName] = companyName
            profileRecord[DDGProfile.kBio] = bio
            profileRecord[DDGProfile.kAvatar] = avatar.convertToCKAsset()
            
            return profileRecord
        }
        
        private func showLoadingView() { isLoading = true }
        private func hideLoadingView() { isLoading = false }
    }

}
