//
//  ScoreCounter.swift
//  (SP)Pong+
//
//  Created by chase morgan on 3/29/22.
//

import SwiftUI

struct ScoreCounter: View{
    @ObservedObject var states: States
    var body: some View{
        HStack{
            ScoreCounterLayOut(player: states.playerList[0], rounds: states.rounds)
            Spacer()
            ScoreCounterLayOut(player: states.playerList[1], rounds: states.rounds)
            
            
           }.position(x: UIScreen.main.bounds.width/2, y: 70)
        }
}


