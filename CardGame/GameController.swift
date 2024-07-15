
import UIKit

class GameController: UIViewController {
    
    @IBOutlet weak var west_side_card_IMG: UIImageView!
    @IBOutlet weak var east_side_card_IMG: UIImageView!
    
    @IBOutlet weak var p1_name_LBL: UILabel!
    @IBOutlet weak var p1_score_LBL: UILabel!
    
    @IBOutlet weak var p2_name_LBL: UILabel!
    @IBOutlet weak var p2_score_LBL: UILabel!
    
    @IBOutlet weak var count_LBL: UILabel!
    
    var timer: StepTimer?
    var game: Game?
    
    let roundTime: Int = 5
    
    func configure(side: LocationSide, name: String) {
        self.timer = StepTimer(callback: self)
        let player = Player(name: name, side: side == .east ? .east : .west)
        let pc = Player(name: "PC", side: side == .east ? .west : .east)
        self.game = Game(
            westSidePlayer: player.side == .west ? player : pc,
            eastSidePlayer: player.side == .east ? player : pc,
            numberOfRounds: 10
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if game?.westSidePlayer.side == .east {
            p2_name_LBL.text = game?.westSidePlayer.name
            p1_name_LBL.text = game?.eastSidePlayer.name
        } else {
            p1_name_LBL.text = game?.westSidePlayer.name
            p2_name_LBL.text = game?.eastSidePlayer.name
        }
        
        updateUIWithScore()
    }
    
    func startRound() {
        let currentRound = game?.currentRound ?? 0
        let numberOfRounds = game?.numberOfRounds ?? 0
        
        if currentRound < numberOfRounds {
            game?.currentRound = currentRound + 1
            timer?.startTimer(seconds: roundTime)
            
            let p1Card = game?.westSidePlayer.deck.drawCard()
            west_side_card_IMG.image = UIImage(named: p1Card?.imageName ?? "")
            
            let p2Card = game?.eastSidePlayer.deck.drawCard()
            east_side_card_IMG.image = UIImage(named: p2Card?.imageName ?? "")
            
            if let p1Strength = p1Card?.strength,
               let p2Strength = p2Card?.strength {
                game?.calculateRoundResult(p1Strength: p1Strength, p2Strength: p2Strength)
                updateUIWithScore()
            }
        } else {
            showScoreScreen()
        }
    }
    
    func updateUIWithScore() {
        self.p1_score_LBL.text = "\(game?.westSidePlayer.score ?? 0)"
        self.p2_score_LBL.text = "\(game?.eastSidePlayer.score ?? 0)"
    }
    
    func flipCards() {
        west_side_card_IMG.image = UIImage(resource: .cardBackBlue)
        east_side_card_IMG.image = UIImage(resource: .cardBackRed)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startRound()
    }
    
    func showScoreScreen() {
        let winner = game?.getWinner()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let scoreController = storyboard.instantiateViewController(withIdentifier: "ScoreController") as? ScoreController {
            scoreController.configure(winner: winner)
            self.navigationController?.pushViewController(scoreController, animated: true)
        }
    }
}

extension GameController: CallBack_TimerChange {
    func timerChanged(seconds: Int) {
        if seconds == 2 {
            flipCards()
            self.count_LBL.text = String(seconds)
        } else if seconds == 0 {
            startRound()
            self.count_LBL.text = String(roundTime)
        } else {
            self.count_LBL.text = String(seconds)
        }
    }
}
