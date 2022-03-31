//
//  Vision.swift
//  (SP)Pong+
//
//  Created by chase morgan on 3/30/22.
//
import SwiftUI

struct Vision: Shape {
    let botP: CGPoint
    let point: CGPoint
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: botP)
        path.addLine(to: point)
        return path
    }
}
