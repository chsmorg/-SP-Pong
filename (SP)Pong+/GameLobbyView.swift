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
               // BotOptions(states: states)
                
                
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
        bot.player = 2
        self.states.addPlayer(player: bot)
        self.states.playerList[1].setBot()
    }
}

struct Player: View {
    @State var player: ConnectedPlayer
    @State var color = Color(.green)
    @State var ballColor = Color(.green)
    @State var dif = "Easy"
    @State var ready = false
    var body: some View{
        HStack{
            VStack{
                Text(player.name.capitalized).padding().font(.system(size: 15, design: .rounded)).foregroundColor(self.ready ? .green: .white)
                Circle().fill(.radialGradient(Gradient(colors: [self.player.player == 1 ? .green : .red, .white]), center: .center, startRadius: 2, endRadius: 25))
                    .frame(width: 30, height: 30)
            }
            
            Spacer()
            VStack{
                ZStack{
                    Text("Player").padding(.vertical).font(.system(size: 12)).foregroundColor(.green).opacity(player.isBot ? 0 : 1)
                    Text("CPU").padding(.vertical).font(.system(size: 12)).foregroundColor(.red).opacity(player.isBot ? 1 : 0)
                }
                ZStack{
                    Button(action: {
                        self.player.difficulty += 1
                        if(self.player.difficulty > 3){
                            self.player.difficulty = 1
                        }
                        switch self.player.difficulty{
                        case 1:
                            color = Color(.green)
                            dif = "Easy"
                        case 2:
                            color = Color(.yellow)
                            dif = "Medium"
                        default:
                            color = Color(.red)
                            dif = "Hard"
                        }
                        
                    
                    },label: {
                        Text(dif).padding()
                            .foregroundColor(color)
                            .cornerRadius(15)
                            .font(.system(size: 15))
                           
                    }).opacity(self.player.isBot ? 1 : 0)
                    
                    Button(action: {
                        self.ready.toggle()
                    
                    },label: {
                        Text("Ready").padding()
                            .foregroundColor(self.ready ? .green: .red)
                            .cornerRadius(15)
                            .font(.system(size: 15))
                           
                    }).opacity(self.player.isBot ? 0 : 1)
                }
               
                
                
                
            }
            Spacer()
            VStack{
                Text("Wins: \(self.player.wins)").padding().foregroundColor(.white)
                Text("Streak: \(self.player.streak)").padding().foregroundColor(.white)
            }
            
                .font(.system(size: 15, design: .rounded)).foregroundColor(.black)
        }.padding().background(RoundedRectangle(cornerRadius: 20).fill(.quaternary).frame(width: UIScreen.main.bounds.width-50, height: UIScreen.main.bounds.height/9))
            .onAppear(){
                if(self.player.isBot){
                    self.ready = true
                }
                }
            }
    
}


struct GameOptions: View{
    @StateObject var states: States
    @State var player: ConnectedPlayer
    @State var rounds: Double = 5
    @State var ballSpeed: Double = 15
    var body: some View{
        VStack{
            Text("Game Settings:").font(.system(size: 20))
            Text("Rounds: \(Int(states.rounds))").font(.system(size: 20, design: .rounded))
            if(player.host){
                Slider(value: $rounds, in: 1...10).accentColor(.cyan).padding().onChange(of: rounds){
                    num in
                    states.rounds = Int(rounds)
                }
            }
            Text("Ball Speed: \(Int(states.ballSpeed))").font(.system(size: 20, design: .rounded))
            if(player.host){
                Slider(value: $ballSpeed, in: 10...35).accentColor(.cyan).padding().onChange(of: ballSpeed){
                    num in
                    states.ballSpeed = Int(ballSpeed)
                }
            }
            
        }.onAppear(){
            ballSpeed = Double(states.ballSpeed)
            rounds = Double(states.rounds)
        }
            
    }
    
}

struct BotOptions: View{
    @State var difficulty: Double = 1
    @State var states: States
    var body: some View{
        VStack{
            Divider()
            Text("Cpu Settings:").font(.system(size: 20))
            Slider(value: $difficulty, in: 1...4).accentColor(.green).padding().onChange(of: difficulty){
                num in
                states.difficulty = Int(difficulty)
            }
            Text("Difficulty:").font(.system(size: 20))
            switch Int(states.difficulty){
            case 1:
                Text("Easy").font(.system(size: 20))
            case 2:
                Text("Medium").font(.system(size: 20))
            default:
                Text("Hard").font(.system(size: 20))
            }
        }.onAppear(){
            difficulty = Double(states.difficulty)
        
    }
}
}




