//
//  Player.swift
//  (SP)Pong+
//
//  Created by chase morgan on 3/28/22.
//

import Foundation

class ConnectedPlayer{
    
    var name: String
    var wins: Int = 0
    var streak: Int = 0
    
    //var socket
    var host: Bool = false
    var connected = false
    var player: Int = 1
    var isBot: Bool = false
    var difficulty: Int = 1
    init(name: String){
        self.name = name
    }
    func setBot(){
        self.isBot.toggle()
    }
    
    

}

