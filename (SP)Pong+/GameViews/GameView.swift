//
//  GameView.swift
//  (SP)Pong+
//
//  Created by chase morgan on 3/29/22.
//

import SwiftUI
import AVFoundation

//static game state positions
private let bounds = UIScreen.main.bounds
private let player1Start = CGPoint(x: bounds.width/2, y: bounds.height - 200)
private let player2Start = CGPoint(x: bounds.width/2, y: 200)
private var ballStart = CGPoint(x: bounds.width/2, y: bounds.height/2)
private let player1GoalPosition = CGPoint(x: bounds.width/2, y: bounds.height-70)
private let player2GoalPosition = CGPoint(x: bounds.width/2, y: 70)




struct GameView: View {
    @ObservedObject var states: States
    @State var timerText  = 3
    @State var roundTimer = 120
    @Environment(\.presentationMode) var presentationMode
    
   
    var body: some View{
        ZStack{
            
            ScoreCounter(states: self.states)
            Goal(color: .green, postion: player1GoalPosition)
            Goal(color: .red, postion: player2GoalPosition)
            Line().stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                 .frame(height: 1)
                 .foregroundColor(.secondary)
                 .position(x: bounds.width/2, y: bounds.height/2)
            
            if(states.playerList[0].isBot){
                BotSprite(states: states, bot: states.playerList[0])
            }
            else{
                PlayerSprite(states: states, player: states.playerList[0], physics: Physics(states: states, player: states.playerList[0]))
            }
            
           // BotSprite(states: states, bot: states.playerList[1])
            BallSprite(states: states, physics: Physics(states: states))
            
            Text(String(timerText)).opacity(self.states.roundEnd ? 1 : 0).font(Font.system(size: 40).monospacedDigit()).padding().position(x: bounds.width/2, y: bounds.height/2).foregroundColor(.white)
            
            
    
        }.navigationBarBackButtonHidden(true)
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .onAppear(){
            states.playerList[0].setStartingPositioning(point: player1Start)
            states.playerList[1].setStartingPositioning(point: player2Start)
                states.roundEnd = true
        }.background(.radialGradient(Gradient(colors: [.indigo, .blue, .purple]), center: .center, startRadius: 50, endRadius: 500)).onReceive(self.states.timer){ _ in
            if(self.states.roundEnd){
                if(self.states.gameEnd){self.presentationMode.wrappedValue.dismiss()}
                self.roundTimer -= 1
                timerText = Int(self.roundTimer/40)+1
                if(self.roundTimer <= 0){
                    states.newRound()
                    
                }
            }
            else{self.roundTimer = 120}
        }
    }
}


