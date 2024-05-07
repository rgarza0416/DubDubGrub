//
//  MockData.swift
//  DubDubGrub
//
//  Created by Ricardo Garza on 1/23/24.
//

import CloudKit

struct MockData {
    
    static var location: CKRecord {
        let record = CKRecord(recordType: RecordType.location)
        record[DDGLocation.kName] = "Ricardo's Booty and Grill"
        record[DDGLocation.kAddress] = "6969 Booty Ave"
        record[DDGLocation.kDescription] = "This is a test description. Ins't it awesome. Not sure how long to make this to test three lines"
        record[DDGLocation.kWebsiteURL] = "https//apple.com"
        record[DDGLocation.kLocation] = CLLocation(latitude: 37.331516, longitude: -121.891054)
        record[DDGLocation.kPhoneNumber] = ["111-111-1111"]
        
        return record
    }
    
    static var chipotle: CKRecord {
            let record                          = CKRecord(recordType: RecordType.location,
                                                           recordID: CKRecord.ID(recordName: "BD731330-6FAF-A3DE-2592-677F9A62BBCA"))
            record[DDGLocation.kName]           = "Chipotle"
            record[DDGLocation.kAddress]        = "1 S Market St Ste 40"
            record[DDGLocation.kDescription]    = "Our local San Jose One South Market Chipotle Mexican Grill is cultivating a better world by serving responsibly sourced, classically-cooked, real food."
            record[DDGLocation.kWebsiteURL]     = "https://locations.chipotle.com/ca/san-jose/1-s-market-st"
            record[DDGLocation.kLocation]       = CLLocation(latitude: 37.334967, longitude: -121.892566)
            record[DDGLocation.kPhoneNumber]    = "408-938-0919"
            
            return record
        }
    
    
    static var profile: CKRecord {
        
        let record = CKRecord(recordType: RecordType.profile)
        record[DDGProfile.kFirstName] = "Trixie "
        record[DDGProfile.kLastName] = "Mattel"
        record[DDGProfile.kCompanyName] = "Makeup brand"
        record[DDGProfile.kBio] = "This is Trixie hahaha :)"
        
        return record
    }
}

