//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Paweł Świątek on 29/07/2021.
//

import SwiftUI

// View Model
class SetGameViewModel: ObservableObject {
    typealias Card = SetGameModel.Card

    private static func createSetGame() -> SetGameModel {
        let model = SetGameModel()
        return model
    }

    @Published private var model = createSetGame()


    var cards: [Card] {
        model.cards
    }

    var displayedCards: [Card] {
        model.cards.filter { $0.isDisplayed }
    }
    var deckCards: [Card] {
        cards.filter { !$0.isDisplayed }
    }

    var cardsToDisplay: [Card] {
        cards.filter { !$0.isMatchedUp && $0.isDisplayed }
    }

    var maxItemCount: Int {
        model.startingNumberOfCard
    }

    // MARK: - Intent(s)

    func choose(_ card: Card) {
        model.choose(card)
    }

    func markCardAsDisplayed(_ card: Card) {
        model.markAsDisplayed(card)
    }

    func addCards() {
        if displayedCards.count >= maxItemCount {
            if model.canAddMoreCards() {
                model.addThreeCards()
            }
        } else {
                model.addNewCards()
        }
    }
    
    func newGame() {
        model = SetGameViewModel.createSetGame()
    }
}
