//
//  InGameOptions.swift
//  (SP)Pong+
//
//  Created by chase morgan on 3/31/22.
//

import SwiftUI
private let bounds = UIScreen.main.bounds


struct InGameOptions: View {
    @ObservedObject var states: States
    @State var expand = false
    let ballStart = CGPoint(x: bounds.width/2, y: bounds.height/2)
    let pauseIcon = "pause.fill"
    let playIcon = "play.fill"
    let restartIcon = Image(systemName: "arrow.counterclockwise")
    let exitIcon = Image(systemName: "xmark")
    var body: some View {
        
        VStack{
            if(!expand){
            Button(action: {
                    states.gamePaused = true
                    self.expand = true
                
             },label: {
                Image(systemName: pauseIcon).foregroundColor(.cyan).font(.system(size: 25, weight: .regular))
                
             }).padding(.bottom, 40)
            }
            
            HStack{
                if(expand){
                    Button(action: {
                            states.gamePaused = false
                            self.expand = false
                        
                     },label: {
                        Image(systemName: playIcon).foregroundColor(.cyan).font(.system(size: 35, weight: .regular))
                        
                     }).padding()
                    
                    Button(action: {
                        if(states.gamePaused == true){
                            states.restartGame()
                            states.setBallPosition(point: ballStart)
                            self.expand = false
                        }
                        
                    },label: {
                        restartIcon.foregroundColor(.cyan).font(.system(size: 35, weight: .regular))
                    }).padding()
                    Button(action: {
                        if(states.gamePaused == true){
                            states.exitGame()
                        }
                        
                    },label: {
                        exitIcon.foregroundColor(.cyan).font(.system(size: 35, weight: .regular))
                    }).padding()
                }
                
                
            }
            
        }
        
    }
}



