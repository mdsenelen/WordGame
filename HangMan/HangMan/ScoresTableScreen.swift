//
//  ScoresTableView.swift
//  HangMan
//
//  Created by Haseeb Javed on 15/01/2022.
//

import SwiftUI

class ScoresViewModel : ObservableObject  {
    
    //All players array:
    @Published var players: [Player] = []
    
}


struct ScoresTableView: View {
    
    @ObservedObject var scoresViewModelObj = ScoresViewModel() //Observeable model object for changes to take place in view when value changed
    
    var body: some View {
        //List all the pllayers with respective scores:
        List(0..<scoresViewModelObj.players.count) { item in
            VStack(alignment: .leading) {
                Text(scoresViewModelObj.players[item].name)
                Text("Games Won : \(scoresViewModelObj.players[item].gameWon)")
                    .font(.subheadline)
            }
        }.onAppear {
            self.onAppearCalled()
        }

    }
    
    func onAppearCalled() { // when main UI appears:
        
        //Getting saved games data from NSUserDefaults.
        let defaults = UserDefaults.standard
        let myPlayersNamesArray = defaults.stringArray(forKey: "myPlayersNamesArray") ?? [String]()
        let myPlayersGameWonArray = defaults.stringArray(forKey: "myPlayersGameWonArray") ?? [String]()
        
        //Cleaning up the user array to insert new data:
        scoresViewModelObj.players.removeAll()
        
        
        for i in 0..<myPlayersNamesArray.count {
            let playerName = myPlayersNamesArray[i]
            let playerGameWon = myPlayersGameWonArray[i]
            
            let player = Player(name: playerName, gameWon: playerGameWon)
            scoresViewModelObj.players.append(player)
            
        }
        
        
        
    }
    
}


struct Player {
    
    let name : String
    let gameWon: String
}

