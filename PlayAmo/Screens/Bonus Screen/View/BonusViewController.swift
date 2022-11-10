//
//  BonusViewController.swift
//  PlayAmo
//
//  Created by Anastasia Koldunova on 08.11.2022.
//

import UIKit

class BonusViewController: BaseViewController<BonusPresenterProtocol>, BonusView {

    @IBOutlet weak var coinLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        Defaults.dailyBonusDate = Date()
        Defaults.coinsCount! += 50
        // Do any additional setup after loading the view.
    }
    
    @IBAction func crossButtonPressed(_ sender: Any) {
        presenter.dismissVC()
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
