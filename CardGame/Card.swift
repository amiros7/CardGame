
import Foundation

enum Suit: CaseIterable {
    case heart
    case diamond
    case spade
    case club
}

class Card {
    var strength: Int
    var suit: Suit
    var imageName: String
    
    init(strength: Int, suit: Suit) {
        self.strength = strength
        self.suit = suit
        self.imageName = "\(suit)_\(strength)"
    }
}
