//
//  ContentView.swift
//  HangMan
//
//  Created by Haseeb Javed on 05/12/2021.
//

import SwiftUI

class ContentViewModel : ObservableObject  {
    
    @Published var currentWord : String = ""
    
    @Published var currentWordArray : [String] = [] //Current word in the form of characters array to compare with a character
    
    @Published var resultantArray : [String] = [] //Updating the current as user choose new character
    
    @Published var resultImage = "waiting" //image to be display on top (waiting, won, lose)
    
    @Published var topPrompt = "" // Timer prompt for new game
    
    @Published var turnsLeftPrompt = "" //prompt for displaying number of turns left
    
    @Published var topPromptImage = "" //Game image
    
    @Published var appTimer = Timer()
    
    @Published var timerValue = 5 //5 seconds timer for starting new game
    
    @Published var turnsLeft = 12 //Total numbers of turns per game
    
    @Published var shouldDisableKeyBoard = false  // disable keyboard when starting new game
    
    @Published var player1Correct = 0
    
    @Published var player2Correct = 0
    
}



struct MainGameScreen: View {
    
    var player1Username: String = ""
    var player2Username: String = ""

    @ObservedObject var contentViewModelObj = ContentViewModel() //Observeable model object for changes to take place in view when value changed
    
    //Characters to be shown on our custom keyboard:
    var charactersArray = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    
    
    var body: some View {
        
        ZStack{
            //Background multicolor game image:
            Image("hangmanBG")
            
            VStack{ //Whole UI:
                
                Spacer()
                
                Label(contentViewModelObj.turnsLeftPrompt, systemImage: "")
                Spacer().frame(height: 25)
                Image(contentViewModelObj.resultImage).padding() //image to be display on top (waiting, won, lose)
                Spacer().frame(height: 20)
                HStack{
                    ForEach(contentViewModelObj.resultantArray, id: \.self) { text in
                        Text("\(text)")
                    }
                }
                Spacer().frame(height: 20)
                Label(contentViewModelObj.topPrompt, systemImage: "")
                VStack{ //4 HStacks for 4 lines of keyboards
                    HStack{
                        ForEach(0..<7) { number in
                            
                            Button(action: {
                                checkWord(clickedChar: charactersArray[number])
                            }) {
                                HStack {
                                    Spacer()
                                    Text("\(charactersArray[number])")
                                    Spacer()
                                }
                            }.frame(width: 45, height: 45, alignment: .center)
                                .foregroundColor(Color.white)
                                .background(Color.black)
                                .contentShape(Rectangle())
                        }
                    }
                    
                    HStack{
                        ForEach(7..<13) { number in
                            Button(action: {
                                checkWord(clickedChar: charactersArray[number])
                            }) {
                                HStack {
                                    Spacer()
                                    Text("\(charactersArray[number])")
                                    Spacer()
                                }
                            }.frame(width: 45, height: 45, alignment: .center)
                                .foregroundColor(Color.white)
                                .background(Color.black)
                                .contentShape(Rectangle())
                        }
                    }
                    
                    HStack{
                        ForEach(13..<20) { number in
                            Button(action: {
                                checkWord(clickedChar: charactersArray[number])
                            }) {
                                HStack {
                                    Spacer()
                                    Text("\(charactersArray[number])")
                                    Spacer()
                                }
                            }.frame(width: 45, height: 45, alignment: .center)
                                .foregroundColor(Color.white)
                                .background(Color.black)
                                .contentShape(Rectangle())
                        }
                    }
                    
                    HStack{
                        ForEach(20..<26) { number in
                            Button(action: {
                                checkWord(clickedChar: charactersArray[number])
                            }) {
                                HStack {
                                    Spacer()
                                    Text("\(charactersArray[number])")
                                    Spacer()
                                }
                            }.frame(width: 45, height: 45, alignment: .center)
                                .foregroundColor(Color.white)
                                .background(Color.black)
                                .contentShape(Rectangle())
                        }
                    }
                    
                    
                }.disabled(contentViewModelObj.shouldDisableKeyBoard)
                Spacer()
                
            }
            
        }.onAppear {
            self.onAppearCalled()
        }
        
    }
    
    //checking game result after every button click from keyboard:
    func checkWord(clickedChar : String) {
        print(clickedChar)
        
        
        let indexesArray : [Int] = contentViewModelObj.currentWordArray.enumerated().filter({ $0.element == clickedChar }).map({ $0.offset })
        
        
        contentViewModelObj.turnsLeft = contentViewModelObj.turnsLeft - 1;
        if contentViewModelObj.turnsLeft % 2 == 0 {
            contentViewModelObj.player2Correct = contentViewModelObj.player2Correct + indexesArray.count
            contentViewModelObj.turnsLeftPrompt = "Player 1 Turn:    Total Turns Left: \(contentViewModelObj.turnsLeft)"
        }else{
            contentViewModelObj.player1Correct = contentViewModelObj.player1Correct + indexesArray.count
            contentViewModelObj.turnsLeftPrompt = "Player 2 Turn:    Total Turns Left: \(contentViewModelObj.turnsLeft)"
        }
        
        
        
        for index in indexesArray {
            contentViewModelObj.resultantArray[index] = clickedChar
        }
        
        let win = winningOrNot()
        
        if win{
            let defaults = UserDefaults.standard
            
            //Getting Existing data of players:
            var myPlayersNamesArray = defaults.stringArray(forKey: "myPlayersNamesArray") ?? [String]()
            var myPlayersGameWonArray = defaults.stringArray(forKey: "myPlayersGameWonArray") ?? [String]()
            
            
            if contentViewModelObj.player1Correct == contentViewModelObj.player2Correct {
                print("Game Draw")
            }else if contentViewModelObj.player1Correct > contentViewModelObj.player2Correct {
                print("Player 1 Win")
                //adding 1 more to player1 wins:
                var thisPlayerScore = 0
                var index = myPlayersNamesArray.firstIndex(of: player1Username) ?? -1
                if index == -1 {
                    index = 0
                    thisPlayerScore = 0
                    let newScore = thisPlayerScore + 1
                    myPlayersNamesArray.append(player1Username)
                    myPlayersGameWonArray.append("\(newScore)")
                }else{
                    thisPlayerScore = Int(myPlayersGameWonArray[index] ) ?? 0
                    myPlayersNamesArray[index] = player1Username
                    let newScore = thisPlayerScore + 1
                    myPlayersGameWonArray[index] = "\(newScore)"
                }
                
               
            }else{
                print("Player 2 Win")
                //adding 1 more to player1 wins:
                var thisPlayerScore = 0
                var index = myPlayersNamesArray.firstIndex(of: player2Username) ?? -1
                if index == -1 {
                    index = 0
                    thisPlayerScore = 0
                    let newScore = thisPlayerScore + 1
                    myPlayersNamesArray.append(player2Username)
                    myPlayersGameWonArray.append("\(newScore)")
                }else{
                    thisPlayerScore = Int(myPlayersGameWonArray[index] ) ?? 0
                    myPlayersNamesArray[index] = player2Username
                    let newScore = thisPlayerScore + 1
                    myPlayersGameWonArray[index] = "\(newScore)"
                }
                
                
                
            }
            
            defaults.set(myPlayersNamesArray, forKey: "myPlayersNamesArray")
            defaults.set(myPlayersGameWonArray, forKey: "myPlayersGameWonArray")

            
            
            contentViewModelObj.resultImage = "correct"
            contentViewModelObj.shouldDisableKeyBoard = true
            contentViewModelObj.appTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
                startingNextGame(timer: timer)
            })
            
        }else{
            if (contentViewModelObj.turnsLeft <= 0){
                contentViewModelObj.shouldDisableKeyBoard = true
                contentViewModelObj.resultImage = "wrong"
                contentViewModelObj.turnsLeftPrompt = "No more turn : word was \(contentViewModelObj.currentWord)"
                contentViewModelObj.appTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { timer in
                    startingNextGame(timer: timer)
                })
            }else{
                contentViewModelObj.resultImage = "waiting"
            }
        }
        
    }
    
    func startingNextGame(timer : Timer){
        //Start of a new game:
        contentViewModelObj.timerValue = contentViewModelObj.timerValue - 1
        contentViewModelObj.topPrompt = "Next round starts in \(contentViewModelObj.timerValue) seconds"
        contentViewModelObj.topPromptImage = "gamecontroller.fill"
        if contentViewModelObj.timerValue == 0 {
            contentViewModelObj.appTimer.invalidate()
            timer.invalidate()
            contentViewModelObj.shouldDisableKeyBoard = false
            contentViewModelObj.turnsLeft = 12
            self.resetEveryThing()
        }
    }
    
    
    
    func wordList() -> [String]? { //getting words from the file "wordList" placed in the Resources folder:
        guard let url = Bundle.main.url(forResource: "wordList", withExtension: "txt") else {
            return nil
        }
        let content = try! String(contentsOf: url)
        return content.components(separatedBy: "\n")
    }
    
    
    func updateWord() -> String {
        //uodate current word at start of every game
        guard let words = wordList() else { return "" }
        
        let randomIndex = Int(arc4random_uniform(UInt32((words.count))))
        
        let word = (words[randomIndex])
        
        return word
        
    }
    
    
    func winningOrNot() -> Bool {
        //Checking is game end as wining or not
        for item in contentViewModelObj.resultantArray {
            if item == "__" {
                return false
            }
        }
        
        return true
    }
    
    func resetEveryThing (){ //Reset UI and variables for starting new game
        contentViewModelObj.timerValue = 5
        contentViewModelObj.topPrompt = ""
        contentViewModelObj.resultantArray = []
        contentViewModelObj.currentWordArray = []
        contentViewModelObj.resultImage = "waiting"
        contentViewModelObj.turnsLeftPrompt = ""
        contentViewModelObj.player1Correct = 0
        contentViewModelObj.player2Correct = 0
        self.onAppearCalled()
    }
    
    
    func onAppearCalled() { // when main UI appears:
        let randString = self.updateWord()
        contentViewModelObj.currentWord = randString
        contentViewModelObj.resultantArray.removeAll()
        contentViewModelObj.currentWordArray = randString.map({ String($0) })
        for _ in contentViewModelObj.currentWordArray {
            contentViewModelObj.resultantArray.append("__")
        }
        contentViewModelObj.turnsLeftPrompt = "Player 1 Turn : Total Turns Left: \(contentViewModelObj.turnsLeft)"
        print(contentViewModelObj.currentWordArray)
        print(contentViewModelObj.resultantArray)
    }
    
}



struct MainGameScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainGameScreen()
    }
    
}

