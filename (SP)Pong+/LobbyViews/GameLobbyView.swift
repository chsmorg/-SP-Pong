//
//  GameLobbyView.swift
//  (SP)Pong+
//
//  Created by chase morgan on 3/28/22.
//

import SwiftUI


struct GameLobbyView: View {
    @ObservedObject var states: States
    @State var connected = 1
    var body: some View {
        NavigationView{
            VStack{
                ScrollView([], showsIndicators: false){
                    ForEach(0...states.playerList.count-1, id: \.self) { index in
                        Player(player: states.playerList[index])
                    }
                }
                Divider()
                GameOptions(states: states, player: states.player).padding()

                
                
            }.background(.radialGradient(Gradient(colors: [.indigo, .blue, .purple]), center: .center, startRadius: 50, endRadius: 500))
                
        }.navigationTitle("Game Lobby:")
            .navigationViewStyle(.automatic)
            .navigationBarBackButtonHidden(true)
            .foregroundColor(.cyan).opacity(0.9)
            .onAppear{
                self.setUpLobby()
                self.addBot()
        }
    }
    
    func setUpLobby(){
        if(self.connected==1){
            self.states.player.host = true
            self.states.player.player = 1
            
        }
    }
    func addBot(){
        let bot = ConnectedPlayer(name: "CPU")
        bot.setPlayer(pNum: 2)
        self.states.addPlayer(player: bot)
        self.states.playerList[1].setBot()
    }
}







