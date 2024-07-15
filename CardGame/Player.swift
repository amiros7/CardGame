
import Foundation

class Player {
    var name: String
    var score: Int
    var side: LocationSide
    var deck: Deck
    
    init(name: String, side: LocationSide) {
        self.name = name
        self.side = side
        self.score = 0
        self.deck = Deck()
    }
}
