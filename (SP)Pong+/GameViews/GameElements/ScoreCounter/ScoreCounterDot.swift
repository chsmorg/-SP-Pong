//
//  ScoreCounterDot.swift
//  (SP)Pong+
//
//  Created by chase morgan on 3/29/22.
//

import SwiftUI

struct ScoreCounterDot: View{
    @State var ballNum: Int
    @ObservedObject var player: ConnectedPlayer
    @State var color: Color
    var body: some View{
        Circle().fill(self.ballNum <= player.score ? color : .white).frame(width: 15, height: 15)
    }
    
}


