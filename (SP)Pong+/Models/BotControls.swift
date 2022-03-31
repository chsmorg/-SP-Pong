//
//  BotControls.swift
//  (SP)Pong+
//
//  Created by chase morgan on 3/31/22.
//

import Foundation
import AVFoundation

let physics = Physics()


func botMove(bot: ConnectedPlayer, states: States, bounds: CGRect, goalSide: Double) -> CGPoint{
    
    if !inSide(player: bot.player, p: states.ballPosition, bounds: bounds){
        return idleBot(bot: bot, states: states, goalSide: goalSide)
        }
    else if physics.findDistance(point1: bot.position, point2: states.ballPosition) < 90 {
       return attack(bot: bot, states: states)
        }
    else{ return moveToBall(bot: bot, states: states)}
}

func path(position: CGPoint, point: CGPoint, time: Int, dif: Int) -> CGPoint{
    let direction = physics.findDirection(point1: position, point2: point)
    let bot2d = simd_float2(x: Float(position.x), y: Float(position.y))
    let point2d = simd_float2(x: Float(point.x), y: Float(point.y))
    let distance = simd_distance(bot2d,point2d)
    let path2d = bot2d + distance/Float(time*dif) * direction
    let path = CGPoint(x: Double(path2d.x), y: Double(path2d.y))
    if path.x.isNaN || path.y.isNaN{ return CGPoint(x: 0, y: 0) }
    return path
    
    
}
func inSide(player: Int, p: CGPoint, bounds: CGRect) -> Bool {
    if player == 1{
        return p.y > bounds.height/2-1
    }
    else{
        return p.y < bounds.height/2
    }
}

func idleBot(bot: ConnectedPlayer, states: States, goalSide: Double)-> CGPoint{
    return path(position: bot.position, point: CGPoint(x: states.ballPosition.x, y: goalSide), time: 20, dif: bot.difficulty)
    
}
func moveToBall(bot: ConnectedPlayer, states: States) -> CGPoint{
    return path(position: bot.position, point: predictBallPath(states: states), time: 15, dif: bot.difficulty)
    
}
func attack(bot: ConnectedPlayer, states: States) -> CGPoint {
    var p = states.ballPosition
    p.x += Double.random(in: -55...55)
    return path(position: bot.position, point: p, time: 7, dif: bot.difficulty)
}
func predictBallPath(states: States)-> CGPoint{
    
    var p = simd_float2(x: Float(states.ballPosition.x), y: Float(states.ballPosition.y))
    let v = states.ballVelocity
    p = p+v * (30-Float(states.ballSpeed))
    let predictedPoint = CGPoint(x: Double(p.x), y: Double(p.y))
    return predictedPoint

}
