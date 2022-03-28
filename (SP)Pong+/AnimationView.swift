//
//  AnimationView.swift
//  (SP)Pong+
//
//  Created by chase morgan on 3/28/22.
//

import SwiftUI
let b = UIScreen.main.bounds
let c1Start = CGPoint(x: b.width/3.25 , y: b.height/3.33 - b.height/7)
let  c2Start = CGPoint(x: b.width/3.25 , y: b.height/3.33 + b.height/7)
let  ballStart = CGPoint(x: b.width/3.25 , y: b.height/3.3)

struct AnimationView: View {
   @State var c1 = Circle()
   @State var c2 = Circle()
   @State var ball = Circle()
    @State var thetaC1 = 0.0
   @State var thetaC2 = 0.0
   @State var c1p = c1Start
   @State var c2p = c2Start
   var r: Double = 55
    var step = 2 * 3.14 / 10
   let timer =  Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()

    
    var body: some View {
        ZStack{
            
            Text("PONG+").foregroundColor(.cyan).font(.system(size: 100, weight: .bold, design: .rounded)).italic().opacity(0.9)
            
            c1.fill(.radialGradient(Gradient(colors: [.red, .white]), center: .center, startRadius: 5, endRadius: 20))
                .frame(width: 25, height: 25)
                .position(c1p)
                .onReceive(self.timer){ _ in
                    withAnimation{
                        c1p = move(theta: thetaC1, point: c1p, d: 1)
                    }
                    thetaC1 += step
                    
                }
            c2.fill(.radialGradient(Gradient(colors: [.green, .white]), center: .center, startRadius: 5, endRadius: 20))
                .frame(width: 25, height: 25)
                .position(c2p)
                .onReceive(self.timer){ _ in
                    withAnimation{
                        c2p = move(theta: thetaC2, point: c2p, d: -1)
                    }
                    thetaC2 += step
                    
                }
//            ball.fill(.radialGradient(Gradient(colors: [.black, .gray]), center: .center, startRadius: 5, endRadius: 20))
//                .frame(width: 25, height: 25)
//                .position(ballStart)
//                
            
            
            
            
        }
    }
    
    func move(theta: Double, point: CGPoint, d: Double)-> CGPoint{
        let x = point.x  + r*cos(theta) * d
        let y = point.y  + r*sin(theta) * d
        
        return CGPoint(x: x, y: y)
    }
}


