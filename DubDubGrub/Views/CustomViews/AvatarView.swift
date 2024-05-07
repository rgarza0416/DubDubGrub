//
//  AvatarView.swift
//  DubDubGrub
//
//  Created by Ricardo Garza on 1/23/24.
//

import SwiftUI

struct AvatarView: View {
    
    var image: UIImage
    var size: CGFloat
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .clipShape(Circle())
    }
}

#Preview {
    AvatarView(image: PlaceholderImage.avatar, size: 90)
}
