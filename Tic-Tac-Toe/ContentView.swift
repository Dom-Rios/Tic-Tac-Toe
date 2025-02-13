
//
//  ContentView.swift
//  Tic-Tac-Toe
//
//  Created by Dominic Rios on 12/3/24.
//

import OpenAI
import SwiftUI

/*
class ChatController: ObservableObject
{
    @Published var t: [String] = ["hello"]
    func getMessage(content: String) -> String
    {
        //var sof = "N/A"
        let openAI = OpenAI(apiToken: "")
        
        let completion = openAI.completions(query: CompletionsQuery(model: .gpt4, prompt: "What is 42?"))
 
        let query = CompletionsQuery(model: .textDavinci_003, prompt: "What is 42?", temperature: 0, maxTokens: 100, topP: 1, frequencyPenalty: 0, presencePenalty: 0, stop: ["\\n"])
        
        openAI.completions(query: query) { result in
            switch result {
            case .success(let success):
                sof = "Success"
                guard let choice = success.choices.first else {
                    sof = "fatal error"
                    return
                }
                let message = choice.text
                self.t.append(message)
                //return "Success"
                // make an array and append the message. also maybe try to cast the message to a string. also maybe change the return type
                //return "done"
            case .failure(let failure):
                sof = "error"
                print(failure)
            }
        }
        return sof
        return "hi"
    }
}*/

enum SquareInfo {
    case none
    case circle
    case x
}

class Square : ObservableObject
{
    @Published var SquareInfo : SquareInfo
    
    init(Info : SquareInfo)
    {
        self.SquareInfo = Info
    }
    
    func clicked(currentPlayer: Int) -> Int{
        if self.SquareInfo == .none
        {
            if currentPlayer == 1
            {
                self.SquareInfo = .x
                return 1
            }
            else
            {
                self.SquareInfo = .circle
                return 1
            }
        }
        return 0
        
    }
}


class GameState: ObservableObject
{
    @Published var squares = [Square]()
    @Published var player = 1
    @Published var turn = 1
    @Published var stopInputs = false
    
    init()
    {
        for _ in 0...8
        {
            squares.append(Square(Info: .none))
        }
        //squares[0].SquareInfo = .circle
    }
    
    func playerChange()
    {
        if self.player == 1
        {
            self.player = 0
            self.turn+=1
        }
        else
        {
            self.player = 1
            self.turn+=1
        }
    }
    
    func checkWin() -> Int
    {
       if checkThree(one: 0, two: 1, three: 2, a: squares) != 0
       {
           return checkThree(one: 0, two: 1, three: 2, a: squares)
       }
       if checkThree(one: 3, two: 4, three: 5, a: squares) != 0
       {
           return checkThree(one: 3, two: 4, three: 5, a: squares)
       }
       if checkThree(one: 6, two: 7, three: 8, a: squares) != 0
        {
           return checkThree(one: 6, two: 7, three: 8, a: squares)
       }
       if checkThree(one: 0, two: 3, three: 6, a: squares) != 0
        {
           return checkThree(one: 0, two: 3, three: 6, a: squares)
       }
       if checkThree(one: 1, two: 4, three: 7, a: squares) != 0
        {
           return checkThree(one: 1, two: 4, three: 7, a: squares)
       }
       if checkThree(one: 2, two: 5, three: 8, a: squares) != 0
        {
           return checkThree(one: 2, two: 5, three: 8, a: squares)
       }
       if checkThree(one: 0, two: 4, three: 8, a: squares) != 0
        {
           return checkThree(one: 0, two: 4, three: 8, a: squares)
       }
       if checkThree(one: 2, two: 4, three: 6, a: squares) != 0
        {
           return checkThree(one: 2, two: 4, three: 6, a: squares)
       }
       return 0

        
    }
    
    func makeArray() -> [String]
    {
        var a = [String]()
        for i in self.squares
        {
            if i.SquareInfo == .circle
            {
                a.append("O")
            }
            else if i.SquareInfo == .x
            {
                a.append("X")
            }
            else
            {
                a.append("Empty")
            }
        }
        return a
    }
    
    func quitInputs()
    {
        self.stopInputs = true
    }
    
    func reset()
    {
        for i in squares
        {
            i.SquareInfo = .none
        }
        self.player = 1
        self.turn = 1
        self.stopInputs = false
    }
}

struct OptionSquares: View {
    @ObservedObject var dataSource : Square
    @ObservedObject var game : GameState
    
    var body: some View {
        Button(action: {
            if dataSource.clicked(currentPlayer: game.player) == 1
            {
                game.playerChange()
                if game.turn == 10 || game.checkWin() != 0
                {
                    game.quitInputs()
                }
                
            }
        }) {
            Rectangle()
                .fill(.cyan)
                .frame(width: 100, height: 100)
                .cornerRadius(10).overlay{
                    Text(self.dataSource.SquareInfo == .circle ? "O" : self.dataSource.SquareInfo == .x ? "X" : " ").frame(width: 100).foregroundStyle(self.dataSource.SquareInfo == .circle ? .red : self.dataSource.SquareInfo == .x ? .black : .black).font(.system(size: 40))
            }
        }.buttonStyle(PlainButtonStyle()).disabled(game.stopInputs)
    }
}

func checkThree(one: Int, two: Int, three: Int, a: [Square]) -> Int
{
   if(a[one].SquareInfo == .x && a[two].SquareInfo == .x && a[three].SquareInfo == .x)
   {
       return 1
   }
   if(a[one].SquareInfo == .circle && a[two].SquareInfo == .circle && a[three].SquareInfo == .circle)
   {
       return 2
   }
      return 0
}
       
struct ContentView: View {
    @StateObject var game = GameState()
    //@StateObject var chat = ChatController()
    var body: some View {
        VStack {
            //Text(chat.getMessage(content: "What is 42?"))
            Text("Tic-Tac-Toe").font(.system(size: 40))
            ForEach(0..<3, content: {
                row in
                HStack{
                    ForEach(0..<3, content: {
                        column in
                        let index = (row*3)+column
                        OptionSquares(dataSource: game.squares[index], game: game)
                    })
                }
            })
            
            if game.turn <= 9 && game.checkWin() == 0
            {
                if game.player == 1
                {
                    Text("X's turn to play").font(.system(size: 20))
                }
                else
                {
                    Text("O's turn to play").font(.system(size: 20))
                }
                Text("Turn \(game.turn)").font(.system(size: 15))
            }
            if game.turn == 10 && game.checkWin() == 0
            {
                Text("Its a Draw!").font(.system(size: 40))
            }
            if game.checkWin()==1
            {
                Text("X Wins!").font(.system(size: 40))
            }
            if game.checkWin()==2
            {
                Text("O Wins!").font(.system(size: 40))

            }
            
            Button(action: {
                game.reset()
            }) {
                Rectangle()
                    .fill(.red)
                    .frame(width: 150, height: 80)
                    .cornerRadius(10).overlay{
                        Text("Restart").font(.system(size: 30))
                    }
            }.buttonStyle(PlainButtonStyle())
        }.padding()
    }
}

#Preview {
    ContentView()
}
