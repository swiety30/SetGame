//
//  SetGameModel.swift
//  SetGame
//
//  Created by Paweł Świątek on 24/08/2021.
//

import Foundation

struct SetGameModel {
    private(set) var cards: [Card]
    let startingNumberOfCard = 12
    private var idsOfSelectedCards: [Int]? {
        get { cards.filter{ $0.isSelected }.map { $0.id } }
    }
    
    init() {
        self.cards = SetGameModel.createCards()
    }

    private static func createCards() -> [Card] {
        var id = 0
        var cards: [Card] = []
        for number in Number.allCases {
            for shape in Shape.allCases {
                for filin in Filin.allCases {
                    for color in CardColor.allCases {
                        cards.append(Card(id: id,
                                          atribiutes: CardAtribiutes(shape: shape,
                                                                             number: number,
                                                                             filling: filin,
                                                                             color: color),
                                          isDisplayed: false))
                        id += 1
                    }
                }
            }
        }
        return cards.shuffled()
    }

    func cardsToBeAdded(_ cardsCount: Int) -> [Card] {
        Array(cards.filter { $0.isDisplayed == false }.prefix(cardsCount))
    }

    mutating func addThreeCards() {
        for card in cardsToBeAdded(3) {
            markAsDisplayed(card)
        }
    }

    mutating func addNewCards() {
        for card in cardsToBeAdded(startingNumberOfCard) {
            markAsDisplayed(card)
        }
    }

    mutating func markAsDisplayed(_ card: Card) {
        if let cardIndex = getIndexOfCard(with: card.id) {
            cards[cardIndex].isDisplayed = true
        }
    }

    func canAddMoreCards() -> Bool {
        cards.filter { $0.isDisplayed }.count != cards.count
    }

    private func getIndexOfCard(with id: Int) -> Array<Card>.Index? {
        cards.firstIndex(where: { $0.id == id })
    }

    mutating func choose(_ card: Card) {
        if let chosenIndex = getIndexOfCard(with: card.id) { //cards.firstIndex(where: { $0.id == card.id }) {
            if cards[chosenIndex].isSelected {
                cards[chosenIndex].isSelected = false // deselect card, if it was already selected. Changes UI
            } else {
                cards[chosenIndex].isSelected = true // selects cards
            }
        }

        if let selectedIds = idsOfSelectedCards, selectedIds.count == 3 { //check if 3 cards are selected
            var pickedCards: [Card] = []
            selectedIds.forEach {
                if let index = getIndexOfCard(with: $0) {
                    cards[index].isSelected = false
                    pickedCards.append(cards[index])
                }
            }

            if checkIfMatchOccured(for: pickedCards) {
                selectedIds.forEach {
                    if let index = getIndexOfCard(with: $0) {
                        cards[index].isMatchedUp = true
                    }
                }
                if checkIfNeedToAddMoreCards() && canAddMoreCards() { // automatically add 3 cards, if there is less than 12 displayed
                    addThreeCards()
                }
//                showMatchAlert(true)
            } else {
//                showMatchAlert(false)
            }
        }
    }

    private func checkIfNeedToAddMoreCards() -> Bool {
        cards.filter({ $0.isMatchedUp == false && $0.isDisplayed }).count < startingNumberOfCard //check if there are currently less than 12 cards to display (excluding matched cards - hidden one)
    }

    private func checkIfMatchOccured(for pickedCards: [Card]) -> Bool {
        if pickedCards.count != 3 {
            return false
        }
        let card1 = pickedCards[0]
        let card2 = pickedCards[1]
        let card3 = pickedCards[2]

        let firstCompare = compareCards(card1, with: card2)
        let secondCompare = compareCards(card1, with: card3)
        let thirdCompare = compareCards(card2, with: card3)

        return firstCompare == secondCompare && firstCompare == thirdCompare && secondCompare == thirdCompare
    }

    private func compareCards(_ card1: Card, with card2: Card) -> (shape: Bool, number: Bool, filing: Bool, color: Bool) {
        let isShapeSame = card1.atribiutes.shape == card2.atribiutes.shape
        let isNumberSame = card1.atribiutes.number == card2.atribiutes.number
        let isFilingSame = card1.atribiutes.filling == card2.atribiutes.filling
        let isColorSame = card1.atribiutes.color == card2.atribiutes.color

        return (isShapeSame, isNumberSame, isFilingSame, isColorSame)
    }

}

extension SetGameModel {
    struct Card: Identifiable {
        let id: Int
        let atribiutes: CardAtribiutes

        var isDisplayed = false
        var isSelected = false
        var isMatchedUp = false
    }

    struct CardAtribiutes {
        let shape: Shape
        let number: Number
        let filling: Filin
        let color: CardColor
    }

    enum Number: Int, CaseIterable {
        case one = 1
        case two = 2
        case three = 3
    }

    enum Shape: CaseIterable {
        case circle
        case rectangle
        case diamond
    }

    enum Filin: CaseIterable {
        case empty
        case solid
        case opacity
    }

    enum CardColor: CaseIterable {
        case red
        case green
        case blue
    }
}
