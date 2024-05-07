//
//  HapticManager.swift
//  DubDubGrub
//
//  Created by Ricardo Garza on 2/15/24.
//

import UIKit

struct HapticManager {
    
   static func playSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

}
