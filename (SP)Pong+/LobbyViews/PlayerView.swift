//
//  PlayerView.swift
//  (SP)Pong+
//
//  Created by chase morgan on 3/29/22.
//

import SwiftUI

struct Player: View {
    @ObservedObject var player: ConnectedPlayer
    @State var color = Color(.green)
    @State var ballColor = Color(.green)
    @State var dif = "Easy"
    var body: some View{
        HStack{
            VStack{
                Button(action: {
                    if(self.player.player == 1){
                        if self.player.isBot == false {player.setBot()}
                        else{player.setPlayer()}
                    }
                }, label:{
                    Text(player.name.capitalized).padding().font(.system(size: 15, design: .rounded)).foregroundColor(self.player.ready ? .green: .white)
                })
                
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
                        self.player.setDif()
                        switch self.player.difficulty{
                        case 3:
                            color = Color(.red)
                            dif = "Easy"
                        case 2:
                            color = Color(.yellow)
                            dif = "Medium"
                        default:
                            color = Color(.green)
                            dif = "Hard"
                        }
                        
                    
                    },label: {
                        Text(dif).padding()
                            .foregroundColor(color)
                            .cornerRadius(15)
                            .font(.system(size: 15))
                           
                    }).opacity(self.player.isBot ? 1 : 0)
                    
                    Button(action: {
                        if(self.player.ready==false) {player.setReady()}
                        else{ player.unReady()}
                    
                    },label: {
                        Text("Ready").padding()
                            .foregroundColor(self.player.ready ? .green: .red)
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
                    }
    
}

