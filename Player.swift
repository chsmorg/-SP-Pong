//
//  Player.swift
//  (SP)Pong+
//
//  Created by chase morgan on 3/28/22.
//

import Foundation

class ConnectedPlayer: ObservableObject{
    
    var name: String
    @Published var wins: Int = 0
    @Published var streak: Int = 0
    @Published var host: Bool = false
    @Published var connected = false
    @Published var player: Int = 1
    @Published var isBot: Bool = false
    @Published var difficulty: Int = 1
    @Published var ready: Bool = false
    
    init(name: String){
        self.name = name
    }
    func setBot(){
        self.isBot.toggle()
        self.ready = true
    }
    func setReady(){
        self.ready.toggle()
    }
    func setPlayer(pNum: Int){
        self.player = pNum
    }
    func setDif(){
        self.difficulty+=1
        if(self.difficulty > 3){
            self.difficulty = 1
        }
    }
    func gameWon(win:Bool){
        if win{
            self.wins+=1
            self.streak+=1
        }
        else{
            self.streak = 0
        }
    }
    

}

