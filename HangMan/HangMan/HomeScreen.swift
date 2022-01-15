//
//  HomeScreen.swift
//  HangMan
//
//  Created by Haseeb Javed on 15/01/2022.
//

import SwiftUI

struct HomeView: View {
    
    //Two players name variables:
    @State var player1Username: String = ""
    @State var player2Username: String = ""

    
    var body: some View {
        
        NavigationView {
            VStack {
                
                //On clicking scores button it'll take to score screen:
                NavigationLink(destination:ScoresTableView()) {
                    Text("Scores")
                }.navigationBarHidden(true)
                    .frame(width: 90, height: 45, alignment: .center)
                    .foregroundColor(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(10)
                    .contentShape(Rectangle())
                    .padding(EdgeInsets(top: 16, leading: UIScreen.main.bounds.size.width - 110 , bottom: 16, trailing: 20))
                
                Spacer()
                Text("Enter both players name to start the game")
                TextField("Enter Player 1 Name...", text: $player1Username, onEditingChanged: { (changed) in
                    print("player 1 onEditingChanged - \(changed)")
                }) {
                    print("player 1 onCommit")
                }.padding()
                .background(RoundedRectangle(cornerRadius: 5).fill(Color.white))
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: 1)
                )
                .foregroundColor(.black)
                .disableAutocorrection(true)
                
                
                TextField("Enter Player 2 Name...", text: $player2Username, onEditingChanged: { (changed) in
                    print("player 2 onEditingChanged - \(changed)")
                }) {
                    print("player 2 onCommit")
                }.padding()
                .background(RoundedRectangle(cornerRadius: 5).fill(Color.white))
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: 1)
                )
                .foregroundColor(.black)
                .disableAutocorrection(true)
                
                //Play Button will show when both names are choosen:
                if player1Username.replacingOccurrences(of: " ", with: "") != "" && player2Username.replacingOccurrences(of: " ", with: "") != ""   {
                NavigationLink(destination: MainGameScreen(player1Username: player1Username, player2Username: player2Username)) {
                    Text("Play")
                }.navigationBarHidden(true)
             
                }
                
                Spacer()
            }
            
        }
        
    }
    
}

