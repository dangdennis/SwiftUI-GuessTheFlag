//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Dennis Dang on 10/13/19.
//  Copyright © 2019 Dennis Dang. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var angle: Double = 0
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var playerScore = 0
    @State private var selectedNumber = 0
    @State private var correct = false
    @State private var dim = 0.25
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
            VStack {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                }
                
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        self.flagTapped(number)
                        self.angle = 360
                    }) {
                        FlagImage(country: self.countries[number])
                            .opacity(number != self.selectedNumber && self.correct ? self.dim : 1)
                            .rotation3DEffect(number == self.selectedNumber && self.correct ? .degrees(self.angle) : .degrees(0), axis: (x: 0, y: 1, z: 0))
                            .animation(.default)
                    }
                }
                
                Text("\(self.playerScore)")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundColor(.white)
                
                Spacer()
            }
        }.alert(isPresented: $showingScore) {
            if scoreTitle == "Wrong" {
                return Alert(title: Text("Wrong!"), message: Text("That's the flag of \(self.countries[self.selectedNumber])"), dismissButton: .destructive(Text("Continue")) {
                    self.askQuestion()
                    self.resetRound()
                })
            }
            
            return Alert(title: Text(scoreTitle), message: Text("Your score is \(self.playerScore)"), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
                self.resetRound()
            })
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            playerScore += 1
            correct = true
        } else {
            scoreTitle = "Wrong"
        }
        
        selectedNumber = number
        showingScore = true
        dim = 0.25
    }
    
    func askQuestion() {
        self.countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func resetRound() {
        correct = false
        angle = 0
        selectedNumber = 4
        dim = 1
    }
}

struct FlagImage: View {
    var country: String
    
    var body: some View {
        Image(country)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
