
import Foundation

class Deck {
    var cards: [Card]
    
    init() {
        self.cards = []
        createDeck()
        shuffle()
    }
    
    private func createDeck() {
        for suit in Suit.allCases {
            for index in 0..<13 {
                let strength = index + 2
                let card = Card(strength: strength, suit: suit)
                cards.append(card)
            }
        }
    }
    
    private func shuffle() {
        cards.shuffle()
    }
    
    func drawCard() -> Card? {
        if cards.isEmpty {
            return nil
        } else {
            return cards.removeLast()
        }
    }
}

