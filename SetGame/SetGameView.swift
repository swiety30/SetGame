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
    @ObservedObject var setGameViewModel: SetGameViewModel
    @State private var shouldShowNoMoreCardsAlert = false
    @State private var shouldShowMatchAlert = false
    @State private var shouldShowNotMatchAlert = false
    @Namespace private var dealingNamespace

    func dealAnimation(for card: SetGameViewModel.Card.ID, cardsCount: Int) -> Animation {
        var delay = 0.0
        if let index = setGameViewModel.cards.firstIndex(where: { $0.id == card }) {
            delay = Double(index) * (2.0 / Double(setGameViewModel.cards.count))
        }
        return Animation.easeInOut(duration: 0.5).delay(delay)
    }

    func zIndex(of card: SetGameModel.Card) -> Double {
        -Double(setGameViewModel.cards.firstIndex(where: {$0.id == card.id}) ?? 0)
    }

    var newGame: some View {
        Button("New Game") {
            withAnimation() {
                setGameViewModel.newGame()
            }
        }
    }

    var deck: some View {
        ZStack {
            ForEach(setGameViewModel.deckCards) { card in
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 60, height: 90)
                    .foregroundColor(.yellow)
                    .opacity(0.5)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        addCards { shouldShowNoMoreCardsAlert in
                            self.shouldShowNoMoreCardsAlert = shouldShowNoMoreCardsAlert
                        } _: { cards in
                            if let cardsToBeDisplayed = cards {
                                for card in cardsToBeDisplayed {
                                    withAnimation(dealAnimation(for: card.id, cardsCount: cardsToBeDisplayed.count)) {
                                        setGameViewModel.markCardAsDisplayed(card)
                                    }
                                }
                            }
                        }
                    }
            }
        }
        .alert(isPresented: $shouldShowNoMoreCardsAlert, content: {
            noMoreCardsAlert()
        })
    }

    var cardsView: some View {
        AspectVGrid(items: setGameViewModel.cardsToDisplay, maxItemCount: setGameViewModel.maxItemCount, aspectRatio: 2/3) { card in
            let cardView = CardView(item: card)
                .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                .zIndex(zIndex(of: card))
                .modifier(Shake(animatableData: shouldShowNotMatchAlert ? 1 : 0))
                .onTapGesture {
                    withAnimation {
                        setGameViewModel.choose(card) { shouldShowAlert in
                            if shouldShowAlert {
                                shouldShowMatchAlert = true
                            } else {
                                shouldShowNotMatchAlert = true
                            }
                        } cardsToBeDisplayed: { cards in
                            if let cardsToBeDisplayed = cards {
                                for card in cardsToBeDisplayed {
                                    withAnimation(dealAnimation(for: card.id, cardsCount: cardsToBeDisplayed.count)) {
                                        setGameViewModel.markCardAsDisplayed(card)
                                    }
                                }
                            }
                        }
                    }
                }
            if !card.isMatchedUp {
                cardView
            }
        }
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            VStack {
                HStack {
                    newGame
                    Spacer()
                    deck
                }
                .padding()
                .font(.title)

                cardsView

//                AlertPlaceholder()
//                    .alert(isPresented: $shouldShowMatchAlert, content: {
//                        matchAlert()
//                    })
//                AlertPlaceholder()
//                    .alert(isPresented: $shouldShowNotMatchAlert, content: {
//                        notMatchAlert()
//                    })
                //Cannot attach 2 alerts to one view. So I've created empty Views (which not take place on screen).
            }
        }

    }

    private func addCards(_ showAlert: (Bool) -> (), _ cardsToBeDisplayed: ([SetGameModel.Card]?) -> ()) {
        setGameViewModel.addCards(shouldShowAlert: showAlert, cardsToBeDisplayed: cardsToBeDisplayed)
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
        SetGameView(setGameViewModel: SetGameViewModel())
    }
}
