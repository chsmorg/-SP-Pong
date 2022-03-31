//
//  GameCircle.swift
//  (SP)Pong+
//
//  Created by chase morgan on 3/31/22.
//

import SwiftUI

struct GameCircle: View {
    let radius: CGFloat = 70
    var body: some View {
        Circle()
            .stroke(.secondary, style: StrokeStyle(lineWidth: 2, lineCap: .butt, lineJoin: .miter, miterLimit: 0, dash: [5], dashPhase: 0))
            .frame(width: radius * 2, height: radius * 2)
        
    }
}


