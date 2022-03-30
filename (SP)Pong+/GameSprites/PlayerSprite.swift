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
    @ObservedObject var physics: Physics
    @State var colTimer = false
    
    
    @State var side:CGFloat = 0
    
    var simpleDrag: some Gesture {
            DragGesture()
                .onChanged { value in
                        
                    if(!states.roundEnd){
                    //   if(value.location.y > side){
                            self.player.lastPosition = self.player.position
                            self.player.position = value.location
                        //}
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
                physics.update()
            }
        
    }
    func calcPlayerVelocity() -> simd_float2{
        let a = simd_double2(x: (self.player.lastPosition.x), y: (self.player.lastPosition.y))
        let b = simd_double2(x: (self.player.position.x), y: (self.player.position.y))
        let d = simd_distance(a, b)
        let s = d/0.05
        let v = simd_float2(x: Float(s/d*(player.position.x - player.lastPosition.x)),
                            y: Float(s/d*(player.position.y - player.lastPosition.y)))
        if(!v.x.isNaN && !v.y.isNaN){
            return v
        }
        return self.player.velocity

    }
//    func checkCollision(ballPosition: CGPoint) -> Bool{
//        var collision: Bool
//            if (abs(Float(self.player.position.x - ballPosition.x)) < 60 && (abs(Float(self.player.position.y - ballPosition.y)) <
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
        let dx = (self.player.position.x + 30) - (ballPosition.x + 30);
        let dy = (self.player.position.y + 30) - (ballPosition.y + 30);
        let distance = sqrt(dx*dx + dy*dy)
        if(distance<60){ return true }
        self.colTimer = false
        return false
        
    }
    
    
//    func resolveCollision(){
//        var delta = simd_float2(x: Float(self.player.position.x - self.states.ballPosition.x), y: Float(self.player.position.y - self.states.ballPosition.y));
//        var d = simd_length(delta)
//        var mtd: simd_float2
//        if(d != 0){
//            mtd = delta*((60-d)/d)
//        }
//        else{
//            d = 59.0
//            delta = simd_float2(60.0, 0.0);
//            mtd = delta*((60-d)/d);
//        }
//
//        let v = self.states.ballVelocity-self.player.velocity
//        let vn = simd_dot(v,simd_normalize(mtd))
//        let i = -(1.0+self.states.res) * vn/0.4
//
//        let impulse = mtd * i
//        var newV = self.states.ballVelocity + (impulse*0.2)
//        if(newV.x > Float(self.states.ballSpeed)){
//            newV.x = Float(self.states.ballSpeed)
//        }
//        if(newV.y > Float(self.states.ballSpeed)){
//            newV.y = Float(self.states.ballSpeed)
//        }
//        if(newV.x < Float(self.states.ballSpeed) * -1){
//            newV.x = Float(self.states.ballSpeed) * -1
//        }
//        if(newV.y < Float(self.states.ballSpeed) * -1){
//            newV.y = Float(self.states.ballSpeed) * -1
//
//        }
//        states.ballVelocity = newV
//    }
    
//    func resolveCollision(){
//        let m1: Float = 30
//        let m2: Float = 25
//            let xVelocityDiff = self.player.velocity.x - self.states.ballVelocity.x
//            let yVelocityDiff = self.player.velocity.y - self.states.ballVelocity.y
//
//            let xDist = self.player.position.x - self.states.ballPosition.x
//            let yDist = self.player.position.y - self.states.ballPosition.y
//
//            if(Double(xVelocityDiff) * xDist + Double(yVelocityDiff) * yDist) >= 0 {
//
//                let angle = -atan2(self.player.position.y - self.states.ballPosition.y, self.player.position.x - self.states.ballPosition.x)
//
//                let u1 = self.player.velocity * Float(angle)
//                let u2 = self.states.ballVelocity * Float(angle)
//
//           // let v1 = simd_float2(x: u1.x * (m1 - m2) / (m1 + m2) + u2.x * 2 * m2 / (m1 + m2), y: u1.y)
//
//                let vX = u2.x * (m1 - m2) / (m1 + m2) + u1.x * 2 * m2 / (m1 + m2)
//                let vY = u2.y
//
//                let v = simd_float2(x: vX, y: vY)
//
//                let newV = v * Float(-angle)
//
//                states.ballVelocity = newV
//
//
//        }
//    }
    
    func resolveCollision(){
        let v1 = self.player.velocity
        let v2 = self.states.ballVelocity
        let p1 = self.player.position
        let p2 = self.states.ballPosition
        let m1: Float  = 30
        let m2: Float = 25
        
        
        let normal = simd_float2(x: Float(p2.x - p1.x), y: Float(p2.y - p1.y))
        let d =  simd_length(normal)
        let un = simd_normalize(normal)
        let ut = simd_float2(x: -un.y, y: un.x)
        if(d != 0){
           let mtd = normal*((60-d)/d)
            withAnimation(){
                states.ballPosition.x += Double(mtd.x)
                states.ballPosition.y += Double(mtd.y)
            }
        }
        //player
        let v1n = simd_dot(un, v1)
        //ball
        var v2n = simd_dot(un, v2)
        let v2t = simd_dot(ut, v2)
        v2n = (v2n*(m2-m1)+2*m2*v1n)/(m1+m2)
        
        let newVn = v2n * un
        let newVt = v2t * ut
        
       // var newV1 = newV1n + newV1t
        var newV = (newVn + newVt)*0.2
        
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

