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
private let resetV = simd_float2(x: 0, y: 0)




struct GameView: View {
    @ObservedObject var states: States
   
    var body: some View{
        ZStack{
            ScoreCounter(states: self.states)
            Goal(color: .green, postion: player1GoalPosition)
            Goal(color: .red, postion: player2GoalPosition)
            
            
        }
    }
}


