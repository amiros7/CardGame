
import UIKit
import CoreLocation

enum LocationSide {
    case west
    case east
}

class LobbyController: UIViewController {
    
    @IBOutlet weak var start_BTN: UIButton!
    @IBOutlet weak var insert_name_BTN: UIButton!
    @IBOutlet weak var name_TEXTFIELD: UITextField!
    @IBOutlet weak var name_LBL: UILabel!
    @IBOutlet weak var east_VIEW: UIStackView!
    @IBOutlet weak var west_VIEW: UIStackView!
    
    let nameUserDefaultsKey: String = "nameUserDefaultsKey"
    
    var locationManager: CLLocationManager!
    let middleLongitude: CLLocationDegrees = 34.817549168324334
    
    var selectedSide: LocationSide?
    var userName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        insert_name_BTN.setAttributedTitle(NSAttributedString(string: "Insert Name", attributes: [.underlineStyle : NSUnderlineStyle.single]), for: .normal)
        name_TEXTFIELD.delegate = self
        
        if let name = getUserName() {
            setName(name: name)
        } else {
            name_LBL.isHidden = true
        }
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startUpdatingLocation()
    }
    
    func setName(name: String) {
        self.userName = name
        saveUserName(name: name)
        insert_name_BTN.isHidden = true
        name_LBL.isHidden = false
        name_LBL.text = "Hi \(name)"
        name_TEXTFIELD.isHidden = true
        
        updateSelectedSideByLocation()
    }

    @IBAction func onStartButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let gameController = storyboard.instantiateViewController(withIdentifier: "GameController") as? GameController,
           let selectedSide, let userName {
            gameController.configure(side: selectedSide, name: userName)
            self.navigationController?.pushViewController(gameController, animated: true)
        }
    }
    
    @IBAction func onInsertNameBTNClicked(_ sender: Any) {
        name_TEXTFIELD.isHidden = false
        name_TEXTFIELD.becomeFirstResponder()
    }
    
    func saveUserName(name: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(name, forKey: nameUserDefaultsKey)
        userDefaults.synchronize()
    }
    
    func getUserName() -> String? {
        UserDefaults.standard.string(forKey: nameUserDefaultsKey)
    }
    
    func updateSelectedSideByLocation() {
        if let selectedSide {
            switch selectedSide {
            case .west:
                west_VIEW.isHidden = false

            case .east:
                east_VIEW.isHidden = false
            }
            
            updateStartButtonState()
        }
    }
    
    func updateStartButtonState() {
        if selectedSide != nil && userName != nil {
            start_BTN.isHidden = false
        }
    }
}

extension LobbyController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let name = textField.text, !name.isEmpty {
            setName(name: name)
            textField.resignFirstResponder()
        }
        
        return true
    }
}

extension LobbyController: CLLocationManagerDelegate {
    
    func startUpdatingLocation() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.startUpdatingLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            if location.coordinate.longitude <= middleLongitude {
                selectedSide = .west
            } else {
                selectedSide = .east
            }
            
            updateSelectedSideByLocation()
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
