
import Foundation

class Game {
    var westSidePlayer: Player
    var eastSidePlayer: Player
    var numberOfRounds: Int
    var currentRound: Int
    
    init(westSidePlayer: Player, eastSidePlayer: Player, numberOfRounds: Int) {
        self.westSidePlayer = westSidePlayer
        self.eastSidePlayer = eastSidePlayer
        self.numberOfRounds = numberOfRounds
        self.currentRound = 0
    }
    
    func calculateRoundResult(p1Strength: Int, p2Strength: Int) {
        if p1Strength > p2Strength {
            westSidePlayer.score += 1
        } else if p2Strength > p1Strength {
            eastSidePlayer.score += 1
        }
    }
    
    func getWinner() -> Player? {
        guard westSidePlayer.score != eastSidePlayer.score else { return nil }
        return westSidePlayer.score > eastSidePlayer.score ? westSidePlayer : eastSidePlayer
    }
}
