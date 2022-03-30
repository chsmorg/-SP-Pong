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
    @State var botTimer =  Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @State var colTimer = false
    @State var side: CGFloat = 0
    @State var pane: Double = 0
    
    var body: some View {
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
            }.onReceive(self.botTimer){ _ in
                if(!states.roundEnd && !states.gameEnd){
                    botMove()
                }
                else{
                    bot.position = self.bot.startingPosition
                }
                
            }
    }
    func botMove(){
        self.bot.lastPosition = self.bot.position

        withAnimation{
            
//            if(self.bot.player == 1){
//                if(self.bot.position.y < side){
//                    if self.states.ballPosition.y > bounds.height/2{
//                        self.bot.position = idleBot()
//                    }
//                }
//            }
//            else{if(self.bot.position.y > side){
//                if self.states.ballPosition.y > bounds.height/2{
//                    self.bot.position = idleBot()
//                   }
//               }
//            }
    
            if self.states.ballPosition.y > bounds.height/2{
                self.bot.position = idleBot()
            }
            else if (self.states.ballPosition.y - self.bot.position.y) < 0 {
                self.bot.position = intercept()
            }
            else if (self.states.ballPosition.x - self.bot.position.x < 90 && self.states.ballPosition.y - self.bot.position.y < 90){
                self.bot.position = attack()
            }
            else{
                self.bot.position = move()
            }
        }
        
        self.bot.velocity = calcBotVelocity()
        if(checkCollision(ballPosition: self.states.ballPosition) && !self.colTimer){
            self.colTimer = true
            withAnimation(){
                self.bot.position.y -= 60
                self.resolveCollision()
            }
            
            
            
        }
        
    }
    
    func idleBot() -> CGPoint{
        let ranD = Double.random(in: 0...1)
        
        var botMove = CGPoint(x: self.states.ballPosition.x, y: self.states.ballPosition.y - bounds.height/3)
        if(ranD < 0.60 ){
            botMove.x =  Double.random(in: self.bot.position.x-50...self.bot.position.x+50)
            botMove.y = Double.random(in: self.bot.position.y-50...self.bot.position.y+50)
            
            if(botMove.x < 0 || botMove.x > bounds.width){botMove.x = self.bot.position.x}
            if(self.bot.player == 1){
                if(botMove.y < side){ botMove.y = side}
            }
            else{if(botMove.y > side){ botMove.y = side}}
            
        }
        
        return botMove
    }
    
    func intercept() -> CGPoint {
        let ranD = Double.random(in: 0...1)
        var botMove = self.bot.position
        if(ranD > 0.40){
            botMove.x  = self.states.ballPosition.x
            botMove.y = self.states.ballPosition.y - 90
        }
        return botMove
        
    }
    func attack() -> CGPoint {
        let ranD = Double.random(in: 0...1)
        var botMove = self.bot.position
        if(ranD > 0.50){
            botMove.x  = self.states.ballPosition.x
            botMove.y  = self.states.ballPosition.y-30
        }
    
        return botMove
    }
    func move() -> CGPoint{
        let ranD = Double.random(in: 0...1)
        var botMove = CGPoint(x: 0, y: 0)
        if(ranD > 0.60 ){
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
    func calcBotVelocity() -> simd_float2{
        let a = simd_double2(x: (self.bot.lastPosition.x), y: (self.bot.lastPosition.y))
        let b = simd_double2(x: (self.bot.position.x), y: (self.bot.position.y))
        let d = simd_distance(a, b)
        let s = d/0.05
        let v = simd_float2(x: Float(s/d*(bot.position.x - bot.lastPosition.x)),
                                     y: Float(s/d*(bot.position.y - bot.lastPosition.y)))
        if(!v.x.isNaN && !v.y.isNaN){
            return v
        }
        return self.bot.velocity
    }
//    func checkCollision(ballPosition: CGPoint) -> Bool{
//        var collision: Bool
//            if (abs(Float(self.bot.position.x - ballPosition.x)) < 60 && (abs(Float(self.bot.position.y - ballPosition.y)) <
//              60)){
//                collision = true
//             } else {
//                 collision = false
//                 self.colTimer = false
//
//             }
//        return collision
//    }
    func checkCollision(ballPosition: CGPoint) -> Bool{
        let dx = (self.bot.position.x + 30) - (ballPosition.x + 30);
        let dy = (self.bot.position.y + 30) - (ballPosition.y + 30);
        let distance = sqrt(dx*dx + dy*dy)
        
        if(distance < 60){ return true }
        self.colTimer = false
        return false
        
    }
    
    func resolveCollision(){
        var delta = simd_float2(x: Float(self.bot.position.x - self.states.ballPosition.x), y: Float(self.bot.position.y - self.states.ballPosition.y));
        var d = simd_length(delta)
        var mtd: simd_float2
        if(d != 0){
            mtd = delta*((60-d)/d)
        }
        else{
            d = 59.0
            delta = simd_float2(60.0, 0.0);
            mtd = delta*((60-d)/d);
        }
    
        let v = self.states.ballVelocity-self.bot.velocity
        let vn = simd_dot(v,simd_normalize(mtd))
        let i = -(1.0+self.states.res) * vn/0.4
        
        let impulse = mtd * i
        var newV = self.states.ballVelocity + (impulse*0.2)
        if(newV.x > Float(self.states.ballSpeed)){
            newV.x = Float(self.states.ballSpeed)
        }
        if(newV.y > Float(self.states.ballSpeed)){
            newV.y = Float(self.states.ballSpeed)
        }
        if(newV.x < Float(self.states.ballSpeed) * -1){
            newV.x = Float(self.states.ballSpeed) * -1
        }
        if(newV.y < Float(self.states.ballSpeed) * -1){
            newV.y = Float(self.states.ballSpeed) * -1
    
        }
        states.ballVelocity = newV
    }
}

