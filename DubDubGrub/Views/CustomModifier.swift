//
//  CustomModifier.swift
//  DubDubGrub
//
//  Created by Ricardo Garza on 1/23/24.
//

import SwiftUI

struct ProfileNameText: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 32, weight: .bold))
            .lineLimit(1)
            .minimumScaleFactor(/*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
            .disableAutocorrection(true)

    }
}
