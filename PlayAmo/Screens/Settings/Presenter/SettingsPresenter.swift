//
//  SettingsPresenter.swift
//  PlayAmo
//
//  Created by Anastasia Koldunova on 27.10.2022.
//

import UIKit


protocol SettingsView:AnyObject {
    
}

protocol SettingsPresenterProtocol: UITableViewDelegate, UITableViewDataSource {
    init(view: SettingsView, router: RouterProtocol)
    func dismissVC()
}

class SettingsPresenter: NSObject, SettingsPresenterProtocol {
    weak var view: SettingsView?
    private var router: RouterProtocol
    
    required init(view: SettingsView, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        UIScreen.main.brightness = CGFloat(sender.value)
    }
    
    @objc func switchValueChanged(_ sender:UISwitch) {
        switch sender.tag {
        case 0 :
            AudioManager.shared.isSilent = !sender.isOn
        case 1:
            print("isSoundOn")
        case 2:
            AudioManager.shared.IsVibrationOn = sender.isOn
        default:
            break
        }
   
    }
    
    @objc func privacyButtonPressed() {
        router.presentPrivacyVC()
    }
    
    func dismissVC() {
        router.dissmissVC()
    }
}

extension SettingsPresenter: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "slider_cell", for: indexPath) as! SliderTableViewCell
            cell.selectionStyle = .none
            cell.cellSlider.value = Float(UIScreen.main.brightness)
            cell.cellSlider.setThumbImage(UIImage(named: "thumbImage")!, for: .normal)
            cell.cellSlider.addTarget(self, action: #selector(sliderValueChanged(_ :)), for: .valueChanged)
//            cell.titleLabel = "br"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "switch_cell", for: indexPath) as! SwitchTableViewCell
            cell.switchCell.tag = indexPath.row
            cell.switchCell.addTarget(self, action: #selector(switchValueChanged(_ :)), for: .valueChanged)
            switch indexPath.row {
            case 0 :
                cell.titleLabel.text = "Music"
                cell.switchCell.isOn = !AudioManager.shared.isSilent
            case 1 :
                cell.titleLabel.text = "Sound"
            case 2 :
                cell.titleLabel.text = "Vibrate"
//                cell.sliderSeperator.isHidden = true
                cell.switchCell.isOn = AudioManager.shared.IsVibrationOn
            case 3:
                //button_cell
                let cell = tableView.dequeueReusableCell(withIdentifier: "button_cell", for: indexPath) as! ButtonTableViewCell
                cell.selectionStyle = .none
                cell.buttonCell.addTarget(self, action: #selector(privacyButtonPressed), for: .touchUpInside)
                return cell
            default: break;
            }
            return cell
        }
        
    }
    
     
}
