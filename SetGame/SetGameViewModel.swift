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

    func choose(_ card: Card, showMatchAlert: (Bool) -> (), cardsToBeDisplayed: ([Card]?) -> ()) {
        let cards = model.choose(card, showMatchAlert: showMatchAlert)
        cardsToBeDisplayed(cards)
    }

    func markCardAsDisplayed(_ card: Card) {
        model.markAsDisplayed(card)
    }

    func addCards(shouldShowAlert: (_ shouldShowNoMoreCardsAlert: Bool) -> (), cardsToBeDisplayed: ([Card]?) -> ()) {
        if displayedCards.count >= maxItemCount {
            if model.canAddMoreCards() {
                let cards = model.addThreeCards()
                shouldShowAlert(false)
                cardsToBeDisplayed(cards)
            } else {
                shouldShowAlert(true)
            }
        } else {
            let cards = model.addNewCards()
            cardsToBeDisplayed(cards)
        }
    }
    
    func newGame() {
        model = SetGameViewModel.createSetGame()
    }
}
