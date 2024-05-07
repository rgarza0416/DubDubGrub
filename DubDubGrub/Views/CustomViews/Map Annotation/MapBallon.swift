//
//  MapBallon.swift
//  DubDubGrub
//
//  Created by Ricardo Garza on 2/12/24.
//

import SwiftUI

struct MapBallon: Shape {
    
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.minY), control: CGPoint(x: rect.minX, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.maxY), control: CGPoint(x: rect.maxX, y: rect.minY))
       
        return path
    }
    
    
}

#Preview {
    MapBallon()
        .frame(width: 300  , height: 240)
        .foregroundColor(.brandPrimary)
}
