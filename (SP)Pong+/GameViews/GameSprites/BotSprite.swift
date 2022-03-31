//
//  BotSprite.swift
//  (SP)Pong+
//
//  Created by chase morgan on 3/29/22.
//

import SwiftUI
import AVFoundation
private let bounds = UIScreen.main.bounds



struct BotSprite: View {
    @ObservedObject var states: States
    @ObservedObject var bot: ConnectedPlayer
    @ObservedObject var physics: Physics
    @State var botTimer =  Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @State var colTimer = false
    @State var side: CGFloat = 0
    @State var pane: Double = 1
    @State var vision: CGPoint = CGPoint(x: 0, y: 0)
    @State var direction =  simd_float2(x: 0, y: 1)
    @State var goalSide: Double = 0
    
    var body: some View {
        if(states.debug){
            Vision(botP: self.bot.position, point: self.vision)
                .stroke(.black)
                .frame(height: 1)
                .foregroundColor(.secondary)
                .position(x: bounds.width/2)
        }
        
        
        Circle().fill(.radialGradient(Gradient(colors: [self.bot.player == 1 ? .green : . red, .white]), center: .center, startRadius: 5, endRadius: 50))
            .frame(width: 60, height: 60)
            .position(bot.position)
            .onAppear(){
               setSide()
                switch self.bot.difficulty{
                case 1:
                    botTimer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
                case 2:
                    botTimer = Timer.publish(every: 0.25, on: .main, in: .common).autoconnect()
                default:
                    botTimer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
                }
            }.onReceive(self.states.timer){ _ in
                if(!states.gamePaused){
                    if(!self.states.roundEnd && !states.gameEnd){
                        self.bot.lastPosition = self.bot.position
                        withAnimation(){
                            self.bot.position = botMove(bot: bot, states: states, bounds: bounds, goalSide: goalSide)
                        }
                        physics.update()
                    }
                    else{bot.position = self.bot.startingPosition}
                    if(self.states.debug){self.vision = visionPoint()}
                    self.direction = physics.findDirection(point1: self.bot.position , point2: self.states.ballPosition )
                }
            }
    }
    //set up function
    func setSide(){
        if self.bot.player == 1 {self.side = bounds.height; pane = -1}
        self.goalSide = side + 120*pane
    }
   //debug function
    func visionPoint()-> CGPoint{
        
        var bv = simd_float2(x: Float(self.bot.position.x), y: Float(self.bot.position.y))
        bv = bv+60*direction
        var point = CGPoint(x: Double(bv.x), y: Double(bv.y))
        
        if(point.x.isNaN || point.y.isNaN){
            point.x = 0
            point.y = 0
        }
        return point
        
    }
}

