//
//  TextAreaView.swift
//  (SP)Pong+
//
//  Created by chase morgan on 3/31/22.
//

import SwiftUI

struct TextAreaView: View {
    let text: String
    var body: some View {
        Text(text).padding(15).foregroundColor(.cyan).frame(width: UIScreen.main.bounds.width-90, height: UIScreen.main.bounds.height/9.5).font(.system(size: 15, weight: .medium , design: .rounded))
           // .background(RoundedRectangle(cornerRadius: 20)
            //    .fill(.quaternary)
            //    .frame(width: UIScreen.main.bounds.width-50, height: UIScreen.main.bounds.height/9)
            //    .padding(4))
            
    }
}


