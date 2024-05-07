//
//  LogoView.swift
//  DubDubGrub
//
//  Created by Ricardo Garza on 1/25/24.
//

import SwiftUI

struct LogoView: View {
    
    var frameWidth: CGFloat
    
    var body: some View {
        Image(decorative: "ddg-map-logo")
            .resizable()
            .scaledToFit()
            .frame(width: frameWidth)
            
    }
}

#Preview {
    LogoView(frameWidth: 250)
}
