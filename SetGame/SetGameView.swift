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

    func dealAnimation(for card: SetGameViewModel.Card.ID) -> Animation {
        var delay = 0.0
        print("[PW] card: \(card)")
        if let index = setGameViewModel.cards.firstIndex(where: { $0.id == card }) {
            delay = Double(index) * (2.0 / Double(setGameViewModel.cards.count))
            print("[PW] index \(index)")
        }
        print("[PW] delay: \(delay)")
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
                    .zIndex(zIndex(of: card))
            }
            .onTapGesture {
                setGameViewModel.addCards()
            }
        }
    }
    var cardsView: some View {
        AspectVGrid(items: setGameViewModel.cardsToDisplay, maxItemCount: setGameViewModel.maxItemCount, aspectRatio: 3/4) { card in
            
            let cardView = CardView(item: card)
                .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                .padding(4)
                .zIndex(zIndex(of: card))
//                .transition(AnyTransition.asymmetric(insertion: .move(edge: .leading), removal: .identity))
                .animation(dealAnimation(for: card.id))
                .onTapGesture {
                    withAnimation {
                        setGameViewModel.choose(card)
                    }
                }
                
            if !card.isMatchedUp {
                cardView
            }
        }
    }

    var body: some View {
        VStack {
            HStack {
                newGame
                Spacer()
                deck
            }
            .padding()
            .font(.title)
            cardsView
                .padding(.horizontal)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SetGameView(setGameViewModel: SetGameViewModel())
    }
}
