
import UIKit

class ScoreController: UIViewController {
    @IBOutlet weak var winner_LBL: UILabel!
    @IBOutlet weak var score_LBL: UILabel!
    
    var winner: Player?
    
    func configure(winner: Player?) {
        self.winner = winner
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let winner {
            winner_LBL.text = "Winner: \(winner.name)"
            score_LBL.text = "Score: \(winner.score)"
        } else {
            winner_LBL.text = "House Wins!"
            score_LBL.isHidden = true
        }
    }

    @IBAction func onBackPressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
