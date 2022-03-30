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
    @Published var player1Score: Int = 0
    @Published var player2Score: Int = 0
    @Published var inGame: Bool = false
    @Published var player: ConnectedPlayer
    @Published var playerList: [ConnectedPlayer] = []
    
    @Published var ballSpeed: Int = 10
    @Published var rounds: Int = 5
    @Published var res: Float = 0.98
    
    @Published var connected: Int = 0
    @Published var gameEnd = false
    @Published var roundEnd = false
    //game timer
    let timer =  Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    //ball physics 
    @Published var ballPosition = CGPoint(x: 0, y: 0)
    @Published var ballVelocity =  simd_float2(x: 0, y: 0)
    
    init(player: ConnectedPlayer){
        self.player = player
    }
    
    func reset(){
        self.player1Score = 0
        self.player2Score = 0
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
    
    func endRound(scored: Int){
        self.roundEnd = true
        self.ballVelocity = simd_float2(x: 0, y: 0)
        for p in self.playerList{
            if(p.player == scored){
                p.scored()
            }
        }
    }
    func endGame(winner: Int){
        self.gameEnd = true
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
