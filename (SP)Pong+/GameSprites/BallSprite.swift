//
//  BallSprite.swift
//  (SP)Pong+
//
//  Created by chase morgan on 3/29/22.
//

import SwiftUI
import AVFoundation


private let bounds = UIScreen.main.bounds


struct BallSprite: View {
    @ObservedObject var states: States
    
    let player1GoalPosition = CGPoint(x: bounds.width/2, y: bounds.height-70)
    let player2GoalPosition = CGPoint(x: bounds.width/2, y: 70)
    let ballStart = CGPoint(x: bounds.width/2, y: bounds.height/2)
    
    var body: some View {
        Circle().fill(.radialGradient(Gradient(colors: [.black, .gray]), center: .center, startRadius: 5, endRadius: 50))
            .frame(width: 60, height: 60)
            .position(self.states.ballPosition).onAppear(){
                states.ballPosition = ballStart
            }.onReceive(self.states.timer){ _ in
                moveBall()
            }
    }
    func moveBall(){
            withAnimation{
                redGoalCollision()
                greenGoalCollision()
                if(!states.roundEnd){
                    wallCollisionCheck()
                    states.ballPosition.x += Double(states.ballVelocity.x)
                    states.ballPosition.y += Double(states.ballVelocity.y)
                    states.ballVelocity = states.ballVelocity * states.res
                }
        }
    }
    
    func wallCollisionCheck(){
        var incident: simd_float2
        var normal: simd_float2
        let bx = self.states.ballPosition.x
        let by = self.states.ballPosition.y
        if(bx < 30){
            incident = self.states.ballVelocity
            normal = simd_float2(x: 1, y: 0)
            states.ballVelocity = simd_reflect(incident, normal)
        }
        if(bx > bounds.width-30){
            incident = self.states.ballVelocity
            normal = simd_float2(x: -1, y: 0)
            states.ballVelocity = simd_reflect(incident, normal)
        }
        if(by < 30){
            incident = self.states.ballVelocity
            normal = simd_float2(x: 0, y: 1)
            states.ballVelocity = simd_reflect(incident, normal)
        }
        if(by > bounds.height-60){
            incident = self.states.ballVelocity
            normal = simd_float2(x: 0, y: -1)
            states.ballVelocity = simd_reflect(incident, normal)
        }
    }
    
    func redGoalCollision(){
        if (abs(Float(player2GoalPosition.x - self.states.ballPosition.x)) < 120 && (abs(Float(player2GoalPosition.y - self.states.ballPosition.y)) <
          20)){
           
            states.ballPosition = CGPoint(x: bounds.width/2, y: bounds.height/2.5)
            states.endRound(scored: 1)
            
    
            if(states.playerList[0].score == states.rounds){
                states.endGame(winner: 1)
            }
        }
    }
    
    func greenGoalCollision(){
        if (abs(Float(player1GoalPosition.x - self.states.ballPosition.x)) < 120 && (abs(Float(player1GoalPosition.y - self.states.ballPosition.y)) <
          20)){
           
            states.ballPosition = CGPoint(x: bounds.width/2, y: bounds.height/1.5)
            states.endRound(scored: 2)
    
            if(states.playerList[1].score == states.rounds){
                states.endGame(winner: 2)
            }
        }
    }
}


