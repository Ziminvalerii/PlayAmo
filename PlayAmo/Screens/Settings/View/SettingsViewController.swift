//
//  SettingsViewController.swift
//  PlayAmo
//
//  Created by Anastasia Koldunova on 27.10.2022.
//

import UIKit

class SettingsViewController: BaseViewController<SettingsPresenterProtocol>, SettingsView {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = presenter
            tableView.delegate = presenter
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func crossButton(_ sender: Any) {
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
