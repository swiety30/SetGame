//
//  ContentView.swift
//  SetGame
//
//  Created by Paweł Świątek on 24/08/2021.
//

import SwiftUI

struct Data: Identifiable {
    let id: Int
    var name: String
    var age: Int
}

struct SetGameView: View {
    @ObservedObject var game: SetGameViewModel
    @State private var shouldShowNoMoreCardsAlert = false
    @State private var shouldShowMatchAlert = false
    @State private var shouldShowNotMatchAlert = false

    var body: some View {
        VStack {
            HStack {
                Button("New Game") {
                    game.newGame()
                }
                Spacer()
                Button("Add Cards") {
                    game.addCards { shouldShowNoMoreCardsAlert in
                        self.shouldShowNoMoreCardsAlert = shouldShowNoMoreCardsAlert
                    }
                }.alert(isPresented: $shouldShowNoMoreCardsAlert, content: {
                    noMoreCardsAlert()
                })
            }
            .padding()
            .font(.title)

            AspectVGrid(items: game.cards, maxItemCount: game.maxItemCount, aspectRatio: 2/3) { card in
                let cardView = CardView(item: card).onTapGesture {
                    game.choose(card) { shouldShowAlert in
                        if shouldShowAlert {
                            shouldShowMatchAlert = true
                        } else {
                            shouldShowNotMatchAlert = true
                        }
                    }
                }
                if !card.isMatchedUp {
                    cardView
                }
            }
            AlertPlaceholder()
                .alert(isPresented: $shouldShowMatchAlert, content: {
                    matchAlert()
                })
            AlertPlaceholder()
                .alert(isPresented: $shouldShowNotMatchAlert, content: {
                notMatchAlert()
            })
            //Cannot attach 2 alerts to one view. So I've created empty Views (which not take place on screen).
            .padding(.vertical, 4)
            .padding(.horizontal, 10)
        }
    }

    private func notMatchAlert() -> Alert {
        Alert(title: Text("It's not a match"),
              message: Text("Try again, please find a correct Set this time!"),
              dismissButton: .cancel(Text("OK")))
    }

    private func matchAlert() -> Alert {
        Alert(title: Text("It's a match"),
              message: Text("Such a sharp eye! Go on!"),
              dismissButton: .cancel(Text("OK")))
    }

    private func noMoreCardsAlert() -> Alert {
        Alert(title: Text("No more Cards!"),
              message: Text("Please try using current cards."),
              dismissButton: .cancel(Text("OK")))
    }
    // Alerts should  be replaced with some fancy animations
}

struct AlertPlaceholder: View {
    var body: some View {
        Rectangle()
            .frame(width: 0, height: 0, alignment: .center)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SetGameView(game: SetGameViewModel())
    }
}
