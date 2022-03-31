//
//  GameOptionsView.swift
//  (SP)Pong+
//
//  Created by chase morgan on 3/29/22.
//

import SwiftUI


struct GameOptions: View{
    @ObservedObject var states: States
    @State var player: ConnectedPlayer
    @State var rounds: Double = 5
    @State var ballSpeed: Double = 10
    var body: some View{
        VStack{
            Divider()
            Text("Game Settings:").font(.system(size: 20))
            Text("Rounds: \(Int(states.rounds))").font(.system(size: 20, design: .rounded))
            if(player.host){
                Slider(value: $rounds, in: 1...10).accentColor(.cyan).padding().onChange(of: rounds){
                    num in
                    states.rounds = Int(rounds)
                }
            }
            Text("Ball Speed: \(Int(states.ballSpeed))").font(.system(size: 20, design: .rounded))
            if(player.host){
                Slider(value: $ballSpeed, in: 10...25).accentColor(.cyan).padding().onChange(of: ballSpeed){
                    num in
                    states.ballSpeed = Int(ballSpeed)
                }
            }
            
        }.onAppear(){
            ballSpeed = Double(states.ballSpeed)
            rounds = Double(states.rounds)
        }
            
    }
    
}
