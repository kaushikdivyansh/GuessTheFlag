//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Divyansh Kaushik on 6/30/23.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var flagSelected = 0
    @State private var numberOfQuestionAsked = 1
    @State private var showResetAlert = false
    
    func flagTapped(_ number: Int) {
        scoreTitle = number == correctAnswer ? "Correct" : "Wrong"
        if (number == correctAnswer) {
            score = score + 1
            numberOfQuestionAsked == 8 ? showResetAlert = true : askQuestion()
        } else {
            if numberOfQuestionAsked == 8 { showResetAlert = true } else {  showingScore = true }
            flagSelected = number
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        numberOfQuestionAsked += 1
    }
    
    func resetGame() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        numberOfQuestionAsked = 1
        score = 0
    }
    
    
    var body: some View {
        ZStack {
            RadialGradient(
                stops:[
                    .init(
                        color: Color(red: 0.1, green: 0.2, blue: 0.45),
                        location: 0.3
                    ),
                    .init(
                        color: Color(red: 0.76, green: 0.15, blue: 0.26),
                        location: 0.3
                    )],
                center: .top,
                startRadius: 200,
                endRadius: 500
            )
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Guess The Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    
                    ForEach(0..<3) {number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .shadow(radius: 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                Text("Score: \(score)/\(numberOfQuestionAsked)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
            
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue") { askQuestion() }
        } message: {
            Text("Wrong! That's the flag of \(countries[flagSelected]). Your score is \(score).")
        }
        .alert("Game Over!", isPresented: $showResetAlert) {
            Button("Restart Game") { resetGame() }
        } message: {
            Text("Final Score: \(score)/\(numberOfQuestionAsked)")
        }
        
    }
}

#Preview {
    ContentView()
}
