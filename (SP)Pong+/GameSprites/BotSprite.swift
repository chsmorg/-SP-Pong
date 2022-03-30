//
//  BotSprite.swift
//  (SP)Pong+
//
//  Created by chase morgan on 3/29/22.
//

import SwiftUI
import AVFoundation
private let bounds = UIScreen.main.bounds

struct Vision: Shape {
    let botP: CGPoint
    let point: CGPoint
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: botP)
        path.addLine(to: point)
        return path
    }
}

struct BotSprite: View {
    @ObservedObject var states: States
    @ObservedObject var bot: ConnectedPlayer
    @ObservedObject var physics: Physics
    @State var botTimer =  Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @State var colTimer = false
    @State var side: CGFloat = 0
    @State var pane: Double = 0
    @State var vision: CGPoint = CGPoint(x: 0, y: 0)
    @State var lineVisable = false
    
    var body: some View {
        if(lineVisable){
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
                if(self.bot.player == 1){
                    self.side = bounds.height/2+30
                    self.pane = 1.0
                }
                else{
                    self.side = bounds.height/2-30
                    self.pane = -1.0
                    
                }
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
                self.vision = visionPoint()
                
            }
    }
    func visionPoint()-> CGPoint{
        
        let direction = physics.findDirection(ball: self.states.ballPosition, bot: self.bot.position)
        var bv = simd_float2(x: Float(self.bot.position.x), y: Float(self.bot.position.y))
        bv = bv+60*direction
        var point = CGPoint(x: Double(bv.x), y: Double(bv.y))
        if(point.x.isNaN || point.y.isNaN){
            point.x = 0
            point.y = 0
        }
        return point
        
    }
    func path(point: CGPoint) -> CGPoint{
        let direction = physics.findDirection(ball: point, bot: self.bot.position)
        let bot2d = simd_float2(x: Float(self.bot.position.x), y: Float(self.bot.position.y))
        let point2d = simd_float2(x: Float(point.x), y: Float(point.y))
        let distance = simd_distance(bot2d,point2d)
        let path2d = bot2d + distance/4 * direction
        let path = CGPoint(x: Double(path2d.x), y: Double(path2d.y))
        if path.x.isNaN || path.y.isNaN{ return CGPoint(x: 0, y: 0) }
        return path
        
        
    }
    
    func botMove(){
        self.bot.lastPosition = self.bot.position

        withAnimation{
    
            if self.states.ballPosition.y > bounds.height/2{
              idleBot()
            }
            else if (self.states.ballPosition.y - self.bot.position.y) < 0 {
               // self.bot.position = intercept()
            }
            else if (self.states.ballPosition.x - self.bot.position.x < 90 && self.states.ballPosition.y - self.bot.position.y < 90){
              //  self.bot.position = attack()
            }
            else{ //self.bot.position = move()
                
            }
        }
    }
    
    func idleBot(){
        let ranD = Double.random(in: 0...1)
        let bp = self.states.ballPosition
        let p = self.bot.position
        //let d = physics.findDistance()
        
        
        var botMove = CGPoint(x: p.x, y: bp.y + bounds.height/2 * -1)
        if(ranD < 0.2){
            botMove.x =  Double.random(in: p.x-100...p.x+100)
            botMove.y = Double.random(in: p.y-100...p.y+100)
            
            if(botMove.x < 0 || botMove.x > bounds.width){botMove.x = self.bot.position.x}
            if(self.bot.player == 1){
                if(botMove.y < side){ botMove.y = side}
            }
            
            else{if(botMove.y > side){ botMove.y = side}}
            self.bot.position = path(point:botMove)
            
        }
        else if (ranD > 0.7){ self.bot.position = path(point:botMove)}
        
        
        
    }
    
    func intercept() -> CGPoint {
        let dif = Double(self.bot.difficulty)
        let ranD = Double.random(in: 0...1)
        var botMove = self.bot.position
        if(ranD > 0.80/dif){
            botMove.x  = self.states.ballPosition.x
            botMove.y = self.states.ballPosition.y - 100
        }
        return botMove
        
    }
    func attack() -> CGPoint {
        let ranD = Double.random(in: 0...1)
        var botMove = self.bot.position
        if(ranD > 0.80){
            botMove.x  = self.states.ballPosition.x
            botMove.y  = self.states.ballPosition.y - self.states.ballPosition.y/20
        }
    
        return botMove
    }
    func move() -> CGPoint{
        let ranD = Double.random(in: 0...1)
        var botMove = CGPoint(x: 0, y: 0)
        if(ranD > 0.85 ){
            botMove.x = self.bot.position.x + self.states.ballPosition.x/4
            botMove.y = self.bot.position.y + self.states.ballPosition.y/4
            if(botMove.x > bounds.width-30){
                botMove.x = bounds.width-30
            }
        }
        else{
            botMove.x =  Double.random(in: self.bot.position.x-10...self.bot.position.x+10)
            botMove.y = Double.random(in: self.bot.position.y-5...self.bot.position.y+5)
            if(botMove.x < 0 || botMove.x > bounds.width){
                botMove.x = self.bot.position.x
            }
            if(self.bot.player == 1){
                if(botMove.y < side){ botMove.y = side}
            }
            else{if(botMove.y > side){ botMove.y = side}}
        }
        
        return botMove
    }

}

