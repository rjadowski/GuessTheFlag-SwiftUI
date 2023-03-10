//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Robbie Jadowski on 13/02/2023.
//

import SwiftUI

struct ContentView: View {
    // Declare all state variables used in the view
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var questionNumber = 1
    @State private var usedCountries = [String]()
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...3)
    @State private var uniqueCountry = ""
    
    var body: some View {
        ZStack {
            // Create a radial gradient background
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                // Display the flag options
                VStack(spacing: 15) {
                    VStack{
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.primary)
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                            .foregroundStyle(.primary)
                    }
                    
                    // Display the flag buttons
                    ForEach(0..<4) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .fixedSize()
                                .shadow(radius: 5)
                                .cornerRadius(20)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                // Display the score
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        // Display an alert after the user taps a flag button
        .alert(scoreTitle, isPresented: $showingScore) {
            if questionNumber < 8 {
                Button("Continue", action: askQuestion)
            } else {
                Button("Restart", action: restartGame)
            }
        } message: {
            if questionNumber < 8 {
                Text("Your score is \(score)")
            } else {
                Text("Final score: \(score)")
            }
        }
    }

    // Method that is called when a flag button is tapped
    func flagTapped(_ number: Int) {
        // Add correct answer to array of used countries
        usedCountries.append("\(countries[correctAnswer])")
        if number == correctAnswer {
            score += 1
            scoreTitle = "Correct"
        } else {
            scoreTitle = "Wrong! That???s the flag of \(countries[number])."
        }
        showingScore = true
    }

    // Method that is called to update the question and shuffle the flag options
    func askQuestion() {
        if questionNumber == 8 {
            showingScore = true
            scoreTitle = "Final score: \(score)"
            return
        }
        
        // Shuffle the countries and generate a unique answer for the next question by checking
        // that the new answer hasn't been used before
        repeat {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...3)
            uniqueCountry = countries[correctAnswer]
        } while usedCountries.contains(uniqueCountry)

        //  Update the question number
        questionNumber += 1
    }



    // Method that is called to restart the game
    func restartGame() {
        questionNumber = 0
        score = 0
        usedCountries = []
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
