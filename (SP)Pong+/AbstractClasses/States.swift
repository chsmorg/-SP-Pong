//
//  States.swift
//  (SP)Pong+
//
//  Created by chase morgan on 3/28/22.
//

import Foundation
import SwiftUI
import AVFoundation

class States: ObservableObject {
    @Published var inGame: Bool = false
    @Published var player: ConnectedPlayer
    @Published var playerList: [ConnectedPlayer] = []
    @Published var debug: Bool = false
    
    @Published var ballSpeed: Int = 10
    @Published var rounds: Int = 5
    @Published var res: Float = 0.985
    
    @Published var connected: Int = 0
    @Published var gameEnd = false
    @Published var roundEnd = false
    //game timer
    let timer =  Timer.publish(every: 0.025, on: .main, in: .common).autoconnect()
    //ball physics 
    @Published var ballPosition = CGPoint(x: 0, y: 0)
    @Published var ballVelocity =  simd_float2(x: 0, y: 0)
    @Published var ballDirection = simd_float2(x: 0, y: 0)
    
    init(player: ConnectedPlayer){
        self.player = player
        self.addPlayer(player: player)
    }
    func reset(){
        self.gameEnd = false
        self.roundEnd = false
    }
    func addPlayer(player: ConnectedPlayer){
        self.playerList.append(player)
    }
    func removePlayer(player: Int){
        self.playerList.remove(at: player-1)
    }
    func newRound(){
        self.roundEnd = false
    }
    
    
    func resetReady(){
        for p in self.playerList{
            if(p.isBot && p.player == 1){p.setBot()}
            else if !p.isBot {p.setReady()}
        }
    }
    func endRound(scored: Int){
        self.roundEnd = true
        self.ballVelocity = simd_float2(x: 0, y: 0)
        for p in self.playerList{
            if(p.player == scored){
                p.scored()
            }
            p.reset()
        }
    }
    func endGame(winner: Int){
        self.gameEnd = true
        self.resetReady()
        for p in self.playerList{
            if(p.player == winner){
                p.gameWon(win: true)
            }
            else{
                p.gameWon(win: false)
            }
        }
    }
    
}
