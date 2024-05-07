//
//  DDGButton.swift
//  DubDubGrub
//
//  Created by Ricardo Garza on 1/23/24.
//

import SwiftUI

struct DDGButton: View {
    
    var title: String
    var color: Color = .brandPrimary
    
    var body: some View {
        Text(title)
            .bold()
            .frame(width: 280, height: 44)
            .background(color.gradient)
            .foregroundColor(.white)
            .cornerRadius(8)
    }
}

#Preview("light view") {
    DDGButton(title: "Create Profile")
}


#Preview ("dark view"){
    DDGButton(title: "Create Profile")
        .preferredColorScheme(.dark)
}
