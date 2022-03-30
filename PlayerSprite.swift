//
//  PlayerSprite.swift
//  (SP)Pong+
//
//  Created by chase morgan on 3/29/22.
//

import SwiftUI
import AVFoundation

struct PlayerSprite: View {
    let bounds = UIScreen.main.bounds
    @ObservedObject var states: States
    @ObservedObject var player: ConnectedPlayer
    @State var colTimer = false
    
    @State var side:CGFloat = 0
    
    var simpleDrag: some Gesture {
            DragGesture()
                .onChanged { value in
                        
                    if(!states.roundEnd){
                        if(value.location.y > side){
                            self.player.playerLastPosition = self.player.position
                            self.player.position = value.location
                        }
                    }
                }
            }
    
    
    
    var body: some View {
        Circle().fill(.radialGradient(Gradient(colors: [self.player.player == 1 ? .green : .red, .white]), center: .center, startRadius: 5, endRadius: 50))
            .frame(width: 60, height: 60)
            .position(player.position)
            .gesture(
                simpleDrag
            ).onAppear(){
                if(self.player.player == 1){
                    side = bounds.height/2+30
                }
                else{
                    side = bounds.height/2-30
                }
            }.onReceive(self.states.timer){ _ in
                if(!states.roundEnd && !states.gameEnd){
                    player.velocity = calcPlayerVelocity()
                    if (checkCollision(ballPosition: self.states.ballPosition) && !colTimer){
                        resolveCollision()
                        self.colTimer = true
                    }
                }
                else{
                    player.position = self.player.startingPosition
                }
            }
        
    }
    func calcPlayerVelocity() -> simd_float2{
        let a = simd_double2(x: (self.player.playerLastPosition.x), y: (self.player.playerLastPosition.y))
        let b = simd_double2(x: (self.player.position.x), y: (self.player.position.y))
        let d = simd_distance(a, b)
        let s = d/0.05
        return simd_float2(x: Float(s/d*(player.position.x - player.playerLastPosition.x)),
                                     y: Float(s/d*(player.position.y - player.playerLastPosition.y)))

    }
    func checkCollision(ballPosition: CGPoint) -> Bool{
        var collision: Bool
            if (abs(Float(self.player.position.x - ballPosition.x)) < 60 && (abs(Float(self.player.position.y - ballPosition.y)) <
              60)){
                collision = true
             } else {
                 collision = false
                 self.colTimer = false
                 
             }
        return collision
    }
    
    func resolveCollision(){
        var delta = simd_float2(x: Float(self.player.position.x - self.states.ballPosition.x), y: Float(self.player.position.y - self.states.ballPosition.y));
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
    
        let v = self.states.ballVelocity-self.player.velocity
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

