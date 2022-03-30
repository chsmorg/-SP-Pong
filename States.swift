//
//  States.swift
//  (SP)Pong+
//
//  Created by chase morgan on 3/28/22.
//

import Foundation

class States: ObservableObject {
    @Published var player1Score: Int = 0
    @Published var player2Score: Int = 0
    @Published var inGame: Bool = false
    @Published var player: ConnectedPlayer
    @Published var playerList: [ConnectedPlayer] = []
    @Published var ballSpeed: Int = 10
    @Published var rounds: Int = 5
    @Published var connected: Int = 0
    @Published var gameEnd = false
    @Published var roundEnd = false
    
    
    init(player: ConnectedPlayer){
        self.player = player
    }
    
    func reset(){
        self.player1Score = 0
        self.player2Score = 0
        self.gameEnd = true
        
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
