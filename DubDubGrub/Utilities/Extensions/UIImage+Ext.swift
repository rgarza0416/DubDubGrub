//
//  UIImage+Ext.swift
//  DubDubGrub
//
//  Created by Ricardo Garza on 2/6/24.
//

import CloudKit
import UIKit

extension UIImage {
    
    func convertToCKAsset() -> CKAsset? {
        
        // Get our apps base document directory url
        guard let urlPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        // Append some unique identifier for our profile image
        let fileURL = urlPath.appendingPathComponent("selectedAvatarImage")
        
        
        // Write the image data to the location the address points too
        guard let imageData = jpegData(compressionQuality: 0.25) else { return nil }
        
        
        // Create our CKAsset with that fileURL
        do {
            try imageData.write(to: fileURL)
            return CKAsset(fileURL: fileURL)
        } catch {
            return nil
        }
    }
}
