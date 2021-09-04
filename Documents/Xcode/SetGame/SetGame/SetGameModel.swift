//
//  SetGameModel.swift
//  SetGame
//
//  Created by Paweł Świątek on 24/08/2021.
//

import Foundation

struct SetGameModel {
    private let cards: [Card]
    var cardsToDisplay: [Card] = []
    let startingNumberOfCard = 12
    private var indexesOfSelectedCards: [Int]? {
        get { cardsToDisplay.indices.filter { cardsToDisplay[$0].isSelected }}
        set { cardsToDisplay.indices.forEach { index in
            newValue?.forEach { cardsToDisplay[index].isSelected = (index == $0) } }
        }
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
        return cards
    }

    mutating func prepareCardsForGame() {
        cardsToDisplay = []
        cards.getRandom(elements: startingNumberOfCard).forEach {
            let id = $0.id
            cardsToDisplay.append(cards[id])
        }
        cardsToDisplay.indices.forEach { cardsToDisplay[$0].isDisplayed = true }
    }

    mutating func addCards(at indexes: [Int]? = nil) {
        let displayedIds = cardsToDisplay.map { $0.id }
        var cardsToBeDisplayed: [Card] = []
        var insertIndexes = indexes
        cards.forEach {
            let id = $0.id
            if !displayedIds.contains(id) {
                cardsToBeDisplayed.append(cards[id])
            }
        }
        
        var i = 0
        Array(cardsToBeDisplayed.shuffled().prefix(3)).forEach {
            let id = $0.id
            guard insertIndexes != nil else {
                cardsToDisplay.append(cards[id])
                return
            }
            let newIndex = insertIndexes!.first! + i
            cardsToDisplay.insert(cards[id], at: newIndex)
            insertIndexes!.removeFirst()
            i += 1

        }
        cardsToDisplay.indices.forEach { cardsToDisplay[$0].isDisplayed = true }

    }

    func canAddMoreCards() -> Bool {
        cardsToDisplay.count != cards.count
    }

    mutating func choose(_ card: Card, showMatchAlert: (Bool) -> ()) {
        if let chosenIndex = cardsToDisplay.firstIndex(where: { $0.id ==  card.id }) {
            if cardsToDisplay[chosenIndex].isSelected {
                cardsToDisplay[chosenIndex].isSelected  = false //deselect card, if it was already selected. Changes UI
            } else {
                cardsToDisplay[chosenIndex].isSelected = true //selects cards
            }
        }

        if let indexes = indexesOfSelectedCards, indexes.count == 3 { //check if 3 cards are selected
            indexes.forEach { cardsToDisplay[$0].isSelected = false } //deselect all cards. Let's find another match!
            var pickedCards: [Card] = []
            indexes.forEach { pickedCards.append(cardsToDisplay[$0]) }
            if checkIfMatchOccured(for: pickedCards) {
                indexes.forEach { cardsToDisplay[$0].isMatchedUp = true }
                if checkIfNeedToAddMoreCards() && canAddMoreCards() { // automatically add 3 cards, if there is less than 12 displayed
                    addCards(at: indexes)
                }
                showMatchAlert(true)
            } else {
                showMatchAlert(false)
            }
        }
    }

    private func checkIfNeedToAddMoreCards() -> Bool {
        cardsToDisplay.filter({ $0.isMatchedUp == false }).count < startingNumberOfCard //check if there are currently less than 12 cards to display (excluding matched cards - hidden one)
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

        var isDisplayed: Bool = false
        var isSelected: Bool = false
        var isMatchedUp: Bool = false
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
