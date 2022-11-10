//
//  ShopCollectionViewCell.swift
//  PlayAmo
//
//  Created by Anastasia Koldunova on 30.10.2022.
//

import UIKit

class ShopCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var coinStackView: UIStackView!
    
    var model: Product?
    
    func configure(model: Product) {
        self.model = model
        cellImageView.image = model.image
        coinLabel.text = model.price.description
//        if let model = model as? Ball {
//            cellImageView.image = model.image
//            coinLabel.text = model.price.description
//        } else if let model = model as? Cup {
//            cellImageView.image = model.image
//            coinLabel.text = model.price.description
//        } else if let model = model as? Table {
//            cellImageView.image = model.image
//            coinLabel.text = model.price.description
//        }
    }
}
