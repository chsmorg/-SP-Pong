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
    
    
    init(player: ConnectedPlayer){
        self.player = player
    }
    
    func reset(){
        self.player1Score = 0
        self.player2Score = 0
        
    }
    func addPlayer(player: ConnectedPlayer){
        self.playerList.append(player)
    }
    func removePlayer(player: Int){
        self.playerList.remove(at: player-1)
    }
    
}
