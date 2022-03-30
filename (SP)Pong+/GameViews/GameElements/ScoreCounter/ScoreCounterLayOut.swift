//
//  ScoreCounterLayOut.swift
//  (SP)Pong+
//
//  Created by chase morgan on 3/29/22.
//

import SwiftUI

struct ScoreCounterLayOut: View {
    @ObservedObject var player: ConnectedPlayer
    @State var rounds: Int
    var body: some View {
        HStack{
            if rounds <= 5 {
                VStack(spacing: 3){
                    ForEach(1...rounds, id: \.self){num in
                        ScoreCounterDot(ballNum: num, player: player, color : .green)
                    }
                }.padding()
            }
            else {
                VStack(spacing: 3){
                    ForEach(1...5, id: \.self){num in
                        ScoreCounterDot(ballNum: num, player: player, color : .green)
                    }
                }.padding(.leading)
                VStack(spacing: 3){
                    ForEach(6...rounds, id: \.self){num in
                        ScoreCounterDot(ballNum: num, player: player, color : .green)
                    }
                }
            }
        }
    }
}


