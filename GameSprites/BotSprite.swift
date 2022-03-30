//
//  BotSprite.swift
//  (SP)Pong+
//
//  Created by chase morgan on 3/29/22.
//

import SwiftUI

struct BotSprite: View {
    @ObservedObject var states: States
    @ObservedObject var bot: ConnectedPlayer
    @State var colTimer = false
    @State var side:CGFloat = 0
    
    var body: some View {
        Circle().fill(.radialGradient(Gradient(colors: [self.bot.player == 1 ? .green : . red, .white]), center: .center, startRadius: 5, endRadius: 50))
            .frame(width: 60, height: 60)
            .position(bot.position)
    }
}

