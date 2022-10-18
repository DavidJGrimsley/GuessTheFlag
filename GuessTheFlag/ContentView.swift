//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by DJ on 9/6/22.
//

import SwiftUI

struct FlagImage: View {
    var imageName: String
    var body: some View {
        Image(imageName)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(color: .teal, radius: 5)
    }
}

struct CornerRotateModifier: ViewModifier {
    let amount: Double\
    let anchor: UnitPOINt
    
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    let gameOver = "Game Over"
    @State private var score = 0
    @State private var rounds = 0
    @State private var showingGameOver = false
    
    @State private var tappedFlag = false
    
    //Image(countries[number])
        
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria","Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.2, green: 0.5, blue: 0.7), location: 0.3),
                .init(color: Color(red: 0.7, green: 0.1, blue: 0.2), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            VStack {
                Spacer()
                
                Text("Guess The Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                VStack(spacing: 20) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundColor(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundColor(.black)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                          FlagImage(imageName: countries[number])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
                Text("Your score is \(score), on round \(rounds) out of 8")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
            }
            }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is: \(score)")
            
        }
        .alert(gameOver, isPresented: $showingGameOver) {
            Button("Play again", action: gameIsOver)
        } message: {
            Text("Your Final Score is : \(score)")
        }
        
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer && rounds <= 8  {
            score += 1
     
            scoreTitle = "Correct, Great job!"
        } else if rounds >= 8 {
            showingGameOver = true
        } else {
            scoreTitle = "Wrong, that was \(countries[number]), try again."
        }
        rounds += 1
        showingScore = true
        }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func gameIsOver() {
        rounds = 0
        score = 0
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
