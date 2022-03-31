//
//  StartPageView.swift
//  (SP)Pong+
//
//  Created by chase morgan on 3/28/22.
//

import SwiftUI


struct StartPageView: View {
    @State var name = ""
    @State var states = States(player: ConnectedPlayer(name: ""))
    @State var validName = false
    @State var start = false
    @State var lobby = false
    @State var help = false
    var body: some View {
        NavigationView{
            VStack{
                ZStack{
                    AnimationView().position(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/10)
                }
                
                TextField("Name:", text: $name).padding().background(.quaternary).cornerRadius(15).autocapitalization(.none)
                    .keyboardType(.default)
                    .disableAutocorrection(true)
                    .foregroundColor(.white)
                    .onSubmit {
                        if(!name.isEmpty && name.count >= 3 && name.count <= 8){
                            validName = true
                        }
                        else{
                            validName = false
                        }
                    }
                Spacer()
                
                
                HStack{
                    Button(action: {
                        if(validName){
                            let player = ConnectedPlayer(name: name)
                            self.states = States(player: player)
                            self.lobby = true
                           
                        }
                    },label: {
                        Text("Start").padding()
                            .foregroundColor(.black)
                            .background(RoundedRectangle(cornerRadius: 15).frame(width: UIScreen.main.bounds.width/3).foregroundColor(validName ? .green: .red))
                            .cornerRadius(15)
                           
                    }).padding()
                    Spacer()
                    
                    
                    Button(action: {
                            self.help = true
                        
                    },label: {
                        Text("How To Play").padding()
                            .foregroundColor(.black)
                            .background(RoundedRectangle(cornerRadius: 15).frame(width: UIScreen.main.bounds.width/3).foregroundColor(.green))
                            .cornerRadius(15)
                           
                    }).padding()
                    
                }
                
                NavigationLink(destination: GameLobbyView(states: states), isActive: $lobby) {
                        EmptyView()
                }
                NavigationLink(destination: HelpPageView(), isActive: $help) {
                        EmptyView()
                }
                Spacer()
            
            }.background(.radialGradient(Gradient(colors: [.indigo, .blue, .purple]), center: .center, startRadius: 50, endRadius: 500))
        }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .onAppear(){
                if self.states.debug {self.lobby = true}
            }
            
    }
}

struct StartPageView_Previews: PreviewProvider {
    static var previews: some View {
        StartPageView()
    }
}
