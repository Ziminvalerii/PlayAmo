//
//  StartGameViewController.swift
//  PlayAmo
//
//  Created by Anastasia Koldunova on 27.10.2022.
//

import UIKit
import Lottie

class StartGameViewController: BaseViewController<StartGamePresenter>, StartGameView {
    
    

    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var bonusButton: UIButton!
    @IBOutlet weak var custimSegmentedControl: CustomSegmentedControl! {
        didSet {
            custimSegmentedControl.textFont = UIFont(name: "Impact", size: 17)!
            custimSegmentedControl.selectorTextColor = .white
            custimSegmentedControl.selectorViewColor = .white
            custimSegmentedControl.textColor = .white
            custimSegmentedControl.setButtonTitles(buttonTitles: ["JOIN", "CREATE"])
            custimSegmentedControl.delegate = self
        }
    }
    @IBOutlet weak var stakeLabel: UILabel! {
        didSet {
            
        }
    }
    @IBOutlet weak var stakeSlider: UISlider! {
        didSet {
            stakeSlider.setThumbImage(UIImage(named: "thumbImage"), for: .normal)
        }
    }
    @IBOutlet weak var stakeView: UIView! {
        didSet {
            stakeView.alpha = custimSegmentedControl.selectedIndex == 0 ? 0 : 1
            
        }
    }
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var shopButton: UIButton!
    
    var isConnectionEnabled: Bool = false {
        didSet {
            if isConnectionEnabled {
                startGameButton.doGlowAnimation(withColor: .white, withEffect: .normal)
                presenter.connectionMannager.startAdvertisingPeer(parentVC: self)
            } else {
                startGameButton.removeGlowAnimation()
                presenter.connectionMannager.stopAvertisingPeer()
            }
        }
    }
    
    var stake: Int? {
        didSet {
            if let stake = stake {
                Defaults.stake = stake
                startGameButton.alpha = (stake > Defaults.coinsCount!) ? 0.5 : 1
                
            }
        }
    }
    var stackViewCenterX: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        stackViewCenterX = view.constraints.first(where: {$0.identifier == "stackViewCenterX"})
        updateLabel(with: stakeSlider.value)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        stackViewCenterX?.constant = -view.bounds.size.width/2 - 100
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut) {
            self.stackViewCenterX?.constant = 0
            self.view.layoutIfNeeded()
        }
        
        let isBonusEnabled = Defaults.dailyBonusDate == nil || (Date() - (Defaults.dailyBonusDate ?? Date())) > 24*60*60
        if isBonusEnabled {
            bonusButton.doGlowAnimation(withColor: .white, withEffect: .normal)
        } else {
            bonusButton.removeGlowAnimation()
        }
            bonusButton.isEnabled = isBonusEnabled
            bonusButton.alpha = isBonusEnabled ? 1 : 0.75
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "You don`t have enough coins", message: "You dont have enough coins to start this game. Please, connect to game with smaller stake", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Got it", style: UIAlertAction.Style.cancel)
        cancel.setValue(UIColor.red, forKey: "titleTextColor")
        alertController.addAction(cancel)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func updateLabel(with value: Float) {
        let index = value.rounded(toPlaces: 1)
            let stake = presenter.stakeInt[index]
        if stake != nil {
            self.stake =  (custimSegmentedControl.selectedIndex == 0) ? nil : stake
            stakeLabel.text = "Your stake: \(stake ?? 0)"
        }
    }
    
    func getCurIndex() -> Int {
        return custimSegmentedControl.selectedIndex
    }
    
//    @objc func pingPongButtonPressed() {
//        AudioManager.shared.vibrate()
//
//        pingPongButton.play(fromFrame: 15, toFrame: 60, loopMode: .repeatBackwards(1)) { success in
//            if success {
//                self.presenter.goToGameVC()
//            }
//        }
////        pingPongButton.play { succes in
////            if succes {
////
////            }
////        }
//    }
    
    @IBAction func bonusButtonPressed(_ sender: Any) {
        presenter.goToBonusVC()
    }
    @IBAction func startButtonPressed(_ sender: Any) {
        AudioManager.shared.vibrate()
        if custimSegmentedControl.selectedIndex == 1 {
            guard let stake = stake else { showAlert(); return}
            if stake <= Defaults.coinsCount! {
                presenter.connectionMannager.presentMCBrowser(from: self)
            } else {
                showAlert()
            }
        } else {
            isConnectionEnabled = !isConnectionEnabled
//            startGameButton.doGlowAnimation(withColor: .white,withEffect: .normal)
//            presenter.connectionMannager.startAdvertisingPeer(parentVC: self)
        }
//        self.presenter.goToGameVC()
    }
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        updateLabel(with: sender.value)
    }
    @IBAction func settingsButtonPressed(_ sender: Any) {
        presenter.goToSettingsVC()
    }
    @IBAction func shopButtonPressed(_ sender: Any) {
        presenter.goToShopVC()
    }
    @IBAction func infoButtonPressed(_ sender: Any) {
        presenter.goToInfoVC()
    }
    @IBAction func trainingButton(_ sender: Any) {
        presenter.goToGameVC(isTraining: true, isCreatedGame: custimSegmentedControl.selectedIndex == 1)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension StartGameViewController: CustomSegmentedControlDelegate {
    func change(to index: Int) {
        if index == 0 {
            startGameButton.alpha = 1
            
        } else {
            isConnectionEnabled = false 
            updateLabel(with: stakeSlider.value)
        }
        UIView.animate(withDuration: 0.75, delay: 0, options: .curveEaseOut) {
            self.stakeView.alpha = index == 0 ? 0 : 1
        }
        
    }
    
    
}

extension Float {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}

