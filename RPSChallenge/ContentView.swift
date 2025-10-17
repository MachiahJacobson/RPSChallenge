//
//  ContentView.swift
//  RPSChallenge
//
//  Created by Jacobson, Machiah - Student on 10/15/25.
//

import SwiftUI
import AudioToolbox

struct ContentView: View {
    enum Move: Int, CaseIterable {
        case rock = 1
        case paper
        case scissors
        
        var name: String {
            switch self {
            case .rock: return "Rock"
            case .paper: return "Paper"
            case .scissors: return "Scissors"
            }
        }
        
        var imageName: String {
            return name
        }
    }
    
    @State private var userSelection: Move = .rock
    @State private var computerSelection: Move = .rock
    @State private var hasUserSelected = false
    @State private var CPUScore = 0
    @State private var userScore = 0
    @State private var resultText = ""
    @State private var isPlaying = false
    @State private var countdown = 3
    @State private var showCountdown = false
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Rock, Paper, Scissors")
                .font(.system(size: 67, weight: .bold))
            
            if showCountdown {
                Text("\(countdown)")
                    .font(.system(size: 72, weight: .bold))
                    .transition(.scale)
            }
            
            HStack {
                ForEach(Move.allCases, id: \.self) { move in
                    Image(move.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 170)
                        .border(userSelection == move ? Color.green : Color.black, width: 3)
                        .onTapGesture {
                            if !isPlaying {
                                userSelection = move
                                hasUserSelected = true
                            }
                        }
                }
            }
            
            Button("Play") {
                if hasUserSelected && !isPlaying {
                    startCountdown()
                }
            }
            .disabled(!hasUserSelected || isPlaying)
            .buttonStyle(.borderedProminent)
            .font(.largeTitle)
            
            HStack {
                ForEach(Move.allCases, id: \.self) { move in
                    Image(move.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 170)
                        .border(computerSelection == move ? Color.red : Color.black, width: 3)
                }
            }
            
            Text(resultText)
                .font(.title2)
                .padding(.top)
            
            HStack(spacing: 60) {
                VStack {
                    Text("You")
                    Text("\(userScore)")
                }
                .font(.largeTitle)
                
                VStack {
                    Text("CPU")
                    Text("\(CPUScore)")
                }
                .font(.largeTitle)
            }
        }
        .padding()
    }
    
    func startCountdown() {
        isPlaying = true
        showCountdown = true
        countdown = 3
        resultText = ""
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if countdown > 1 {
                countdown -= 1
            } else {
                timer.invalidate()
                showCountdown = false
                playRound()
            }
        }
    }
    
    func playRound() {
        let cpuMove = Move.allCases.randomElement()!
        computerSelection = cpuMove
        
        switch (userSelection, cpuMove) {
        case let (u, c) where u == c:
            resultText = "It's a Draw!"
        case (.rock, .scissors), (.paper, .rock), (.scissors, .paper):
            resultText = "You Win!"
            userScore += 1
            playWinSound()
        default:
            resultText = "CPU Wins!"
            CPUScore += 1
        }
        
        isPlaying = false
        hasUserSelected = false
    }
    
    func playWinSound() {
        let soundID: SystemSoundID = 1022
        AudioServicesPlaySystemSound(soundID)
    }
}

#Preview {
    ContentView()
}
