//
//  SwitchTableViewCell.swift
//  PlayAmo
//
//  Created by Anastasia Koldunova on 27.10.2022.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {

    @IBOutlet weak var sliderSeperator: UIView!
    @IBOutlet weak var switchCell: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
