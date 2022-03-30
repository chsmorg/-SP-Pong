//
//  GameLobbyView.swift
//  (SP)Pong+
//
//  Created by chase morgan on 3/28/22.
//

import SwiftUI

private let bounds = UIScreen.main.bounds

struct GameLobbyView: View {
    @ObservedObject var states: States
    @State var timerText = 5
    @State var timer = 200
    @State var connected = 1
    @State var gameReady = false
    @State var gameStart = false
    var body: some View {
        NavigationView{
            ZStack{
                
                NavigationLink(destination: GameView(states: states), isActive: $gameStart) {
                        EmptyView()
                }
                
                VStack{
                    ScrollView([], showsIndicators: false){
                        ForEach(0...states.playerList.count-1, id: \.self) { index in
                            Player(player: states.playerList[index])
                        }
                    }
                    Divider()
                    GameOptions(states: states, player: states.player).padding()
                    

                }
                Text(String(timerText))
                    .opacity(self.gameReady ? 1 : 0)
                    .font(Font.system(size: 70, design: .rounded).bold())
                    .padding()
                    .position(x: bounds.width/2, y: bounds.height/2.5)
                    .foregroundColor(.green)
                    .onReceive(self.states.timer){ _ in
                        if(self.states.playerList[0].ready && self.states.playerList[1].ready){ gameReady = true}
                        else {gameReady = false; timer = 200}
                        
                        if(gameReady){
                            timer -= 1
                            timerText = Int(timer/40)+1
                            if(timer <= 0){ timer = 200; gameStart = true; states.reset()}
                        }
                        
                     }
            }.background(.radialGradient(Gradient(colors: [.indigo, .blue, .purple]), center: .center, startRadius: 50, endRadius: 500))
                
        }.navigationBarHidden(true)
            .navigationBarTitle("")
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







