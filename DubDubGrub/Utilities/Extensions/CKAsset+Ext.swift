//
//  CKAsset+Ext.swift
//  DubDubGrub
//
//  Created by Ricardo Garza on 1/25/24.
//

import CloudKit
import UIKit

extension CKAsset {
    func convertToUIImage(in dimension: ImageDimension) -> UIImage {
        guard let fileUrl = self.fileURL else { return dimension.Placeholder }
        
        do {
            let data = try Data(contentsOf: fileUrl)
            return UIImage(data: data) ?? dimension.Placeholder

        } catch {
            return dimension.Placeholder
        }
    }
}
