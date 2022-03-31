//
//  HelpPageView.swift
//  (SP)Pong+
//
//  Created by chase morgan on 3/31/22.
//

import SwiftUI

struct HelpPageView: View {
    @State var b1 = ConnectedPlayer(name: "Cpu")
    @State var b2 = ConnectedPlayer(name: "Cpu")
    @State var b3 = ConnectedPlayer(name: "Cpu")
    @State var p1 = ConnectedPlayer(name: "Player")
    @State var states = States(player: ConnectedPlayer(name: "Player"))
    let timer =  Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack{
            VStack{
                ScrollView(.vertical, showsIndicators: true){
                    VStack{
                        TextAreaView(text: "To start, simply enter a username between 3-8 characters and press start.")
                        Divider()
                        TextAreaView(text: "You will then be taken into the lobby with player cards that look like this:")
                        Player(player: ConnectedPlayer(name: "player")).disabled(true)
                        
                        TextAreaView(text: "Each card has a few hidden details that you will need to know to navigate the game.")
                        Divider()
                    }
                    VStack{
                        TextAreaView(text: "By tapping 'Ready' on the card, you set your ready status" )
                        Player(player: ConnectedPlayer(name: "player"))
                        TextAreaView(text: "You will notice that the player name turns green as an indicator of your status" )
                        Divider()
                        
                        TextAreaView(text: "Bot or Cpu cards are very similar to player cards")
                        Player(player: b1).disabled(true)
                        TextAreaView(text: "Bots will always have their ready status active and be set to Easy by default.")
                        Divider()
                    }
                    VStack{
                        TextAreaView(text: "To change a bots difficulty, simply tap on the difficulty('Easy') to cycle through")
                        Player(player: b2)
                        Divider()
                        TextAreaView(text: "Player cards also have the ablity to be changed into bots by tapping on the player name")
                        TextAreaView(text: "Below is an example of the game lobby, try playing around with it to familiarize yourself with the controls:")
                        Player(player: p1)
                        Player(player: b3)
                        Divider()
                        
                    }
                    VStack{
                        TextAreaView(text: "Your game lobby will also include a couple game settings to set the balls max speed and rounds:")
                        GameOptions(states: self.states, player: p1).disabled(true)
                        Divider()
                        TextAreaView(text: "In game, the score will be tracked at the top of your screen with indicators that change based off your score:")
                        ScoreCounterLayOut(player: p1, rounds: states.rounds)
                        Divider()
                        TextAreaView(text: "The only objective is to knock the black ball into the oposing goal before they get it in yours")
                        TextAreaView(text: "good luck and more information can be found on my github here: github.com/chsmorg/-SP-Pong")
                        Text("Version 1.0.1").font(.system(size:8, weight: .regular, design: .rounded))
                            .foregroundColor(Color(UIColor.lightGray))
                    }
                }
                    
                
            }
            
        }.background(.radialGradient(Gradient(colors: [.indigo, .blue, .purple]), center: .center, startRadius: 50, endRadius: 500)).onAppear(){
            self.b1.setBot()
            self.b1.player = 2
            self.b2.setBot()
            self.b2.player = 2
            self.b3.player = 2
            self.b3.setBot()
            self.p1.host = true
            self.states.addPlayer(player: b3)
            self.states.playerList[0].score = 3
            self.states.playerList[1].score = 6
            self.states.rounds = 10
            
        }
        
    }
}


