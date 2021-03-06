//
//  ContentView.swift
//  GuessingFlag
//
//  Created by iChaya2.0 on 4/15/21.
//

import SwiftUI


struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var correctScore = 0
    @State private var wrongScore = 0
    @State private var message = ""
    @State private var isCorrect = false
    @State private var word = ""
    @State private var animationAmount = 0.0
    @State private var scaleAmount = 1
    @State private var tappedButIncorrect = false
    @State private var tappedIndex = 0
    var date : String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.timeStyle = .long
        return formatter.string(from: Date())
    }
    
    func flagTapped(_ index: Int) {
        if index == correctAnswer {
            scoreTitle = "Correct"
            correctScore += 1
            message = "Correct Guesses: \(correctScore)"
            isCorrect = true
            tappedButIncorrect = false
            //isAnimating = true
            
        } else {
            scoreTitle = "Wrong. That's \(countries[index]) flag"
            wrongScore += 1
            message = "Wrong Guesses: \(wrongScore)"
            isCorrect = false
            tappedButIncorrect = true
        }
        showingScore = true
    }
    
    func reset() {
//        if isCorrect {
//            countries.remove(at: correctAnswer)
//        }
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        isCorrect = false
        tappedButIncorrect = false
    }
    

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
                
                ForEach(0..<3) { tag in
                    Button(action: {
                        self.flagTapped(tag)
                        tappedIndex = tag
                            withAnimation(){
                                animationAmount += 360.0
                                scaleAmount = 1
                            }

                    }){
                        
                        Image(self.countries[tag])
                            .renderingMode(.original)
                            .clipShape(Ellipse())
                            .overlay(Ellipse().stroke(Color.black, lineWidth: 1))
                            .shadow(color: .black, radius: 3)
                    }
                    
                    .rotation3DEffect(.degrees(tag == correctAnswer && isCorrect ? animationAmount : 0), axis: (x: 0, y: 1, z: 0))
                    .opacity(tag != correctAnswer && isCorrect ? 0.25 : 1.0)
                    .scaleEffect(tag == tappedIndex && tappedButIncorrect && !isCorrect ? 1.3 : 1)
                    .alert(isPresented:$showingScore){
                        Alert(title: Text(scoreTitle),
                              message: Text(message),
                              dismissButton: .default(Text("Continue")){
                                reset()
                              })
                    }
                    .accessibility(label: Text(self.labels[self.countries[correctAnswer], default: "Unknown flag"]))
                }
                
                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
