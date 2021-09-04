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
        var model = SetGameModel()
        model.prepareCardsForGame()
        return model
    }

    @Published private var model = createSetGame()

    var cards: [Card] {
        model.cardsToDisplay.filter { !$0.isMatchedUp }
    }

    var maxItemCount: Int {
        model.startingNumberOfCard
    }


    // MARK: - Intent(s)

    func choose(_ card: Card, showMatchAlert: (Bool) -> ()) {
        model.choose(card, showMatchAlert: showMatchAlert)
    }

    func addCards(complition: (_ shouldShowNoMoreCardsAlert: Bool) -> ()) {
        if model.canAddMoreCards() {
            model.addCards()
            complition(false)
        } else {
            complition(true)
        }
    }
    
    func newGame() {
        model = SetGameViewModel.createSetGame()
    }
}
