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
                if(!states.roundEnd && !states.gameEnd){botMove(); physics.update()}
                else{bot.position = self.bot.startingPosition}
                if(self.states.debug){self.vision = visionPoint()}
                self.direction = physics.findDirection(point1: self.bot.position , point2: self.states.ballPosition )
                
                
            }
    }
    
    //bot controls
    func botMove(){
        self.bot.lastPosition = self.bot.position
            if !inSide(p: self.states.ballPosition){
              idleBot()
            }
            else if physics.findDistance(point1: self.bot.position, point2: self.states.ballPosition) < 90 {
                attack()
            }
            else{ moveToBall()}
    }
    
    func idleBot(){
        withAnimation(){
            self.bot.position = path(point: CGPoint(x: self.states.ballPosition.x, y: side + 120*pane ), time: 20)
        }
    }
    func moveToBall(){
        withAnimation(){
            self.bot.position = path(point: predictBallPath(), time: 15)
        }
    }
    func attack() {
        var p = self.states.ballPosition
        p.x += Double.random(in: -55...55)
        withAnimation(){
            
            self.bot.position = path(point: p, time: 7)
        }
    }
    func predictBallPath()-> CGPoint{
        
        var p = simd_float2(x: Float(self.states.ballPosition.x), y: Float(self.states.ballPosition.y))
        let v = self.states.ballVelocity
        p = p+v * (30-Float(self.states.ballSpeed))
        let predictedPoint = CGPoint(x: Double(p.x), y: Double(p.y))
        return predictedPoint
  
    }
    //set up functions
    func setSide(){
        if self.bot.player == 1 {self.side = bounds.height; pane = -1}
    }
    func inSide(p: CGPoint) -> Bool {
        if self.bot.player == 1{
            return p.y > bounds.height/2-1
        }
        else{
            return p.y < bounds.height/2
        }
    }
    
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
    //move function
    func path(point: CGPoint, time: Int) -> CGPoint{
        let direction = physics.findDirection(point1: self.bot.position, point2: point)
        let bot2d = simd_float2(x: Float(self.bot.position.x), y: Float(self.bot.position.y))
        let point2d = simd_float2(x: Float(point.x), y: Float(point.y))
        let distance = simd_distance(bot2d,point2d)
        let path2d = bot2d + distance/Float(time) * direction
        let path = CGPoint(x: Double(path2d.x), y: Double(path2d.y))
        if path.x.isNaN || path.y.isNaN{ return CGPoint(x: 0, y: 0) }
        return path
        
        
    }
    

}

