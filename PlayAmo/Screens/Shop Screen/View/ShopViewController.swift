//
//  ShopViewController.swift
//  PlayAmo
//
//  Created by Anastasia Koldunova on 30.10.2022.
//

import UIKit

class ShopViewController: BaseViewController<ShopPresenterProtocol>, ShopView {

    @IBOutlet weak var coinsCountLabel: UILabel! {
        didSet {
            updateCoins()
        }
    }
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = presenter
            collectionView.dataSource = presenter
            let layout = UPCarouselFlowLayout()
            layout.itemSize = CGSize(width: 180, height: 180)
            layout.scrollDirection = .horizontal
            collectionView.collectionViewLayout = layout
        }
    }
    var errorLabelCenterY: NSLayoutConstraint?
    let overlay = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
    var buyView: BuyView?
    var model: Product?
    override func viewDidLoad() {
        super.viewDidLoad()

        errorLabelCenterY = self.view.constraints.first(where: {$0.identifier == "errorLabelCenterY"})!
        errorLabelCenterY!.constant = view.bounds.height/2 + 24
        // Do any additional setup after loading the view.
    }
    
    func updateCoins() {
        coinsCountLabel.text = Defaults.coinsCount?.description
    }
    
    func animateErrorLabel() {
        view.bringSubviewToFront(errorLabel)
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseOut) {
            self.errorLabelCenterY?.constant = 0
            self.errorLabel.alpha = 0
            self.view.layoutIfNeeded()
        } completion: { success in
            self.errorLabelCenterY?.constant = self.view.bounds.size.height/2 + 24
            self.errorLabel.alpha = 1
        }
    }
    
    func animateIn(_ view: UIView, overlay: UIView) {
        view.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        view.alpha = 0
        overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0)
        UIView.animate(withDuration: 0.4) {
            view.alpha = 1
            view.transform = CGAffineTransform.identity
            overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
        }
    }
    
    func animateOut(_ view : UIView, overlay: UIView) {
        UIView.animate(withDuration: 0.4) {
            view.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            view.alpha = 0
            overlay.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0)
        } completion: { (_) in
            view.removeFromSuperview()
            overlay.removeFromSuperview()
        }
    }
    
    func showBuyView(item: Product) {
        buyView = BuyView(frame: CGRect(x: 0, y: 0, width: 200, height: 150), character: item)
        view.addSubview(overlay)
        buyView!.center = overlay.center
        self.view.addSubview(buyView!)
        buyView!.delegate = self
        animateIn(buyView!, overlay: overlay)
    }
    
    func configureBuyButton(model: Product) {
        self.model = model
        if let model = model as? Ball {
            if ShopManager.boughtBallIndex?.contains(model.rawValue) ?? false {
                if model.rawValue == ShopManager.selectedBallIndex {
                    buyButton.setTitle("Activated", for: .normal)
                    buyButton.alpha = 0.6
                    buyButton.isEnabled = false
                } else {
                    buyButton.setTitle("Active", for: .normal)
                    buyButton.alpha = 0.6
                    buyButton.isEnabled = true
                }
            } else {
                buyButton.setTitle("BUY", for: .normal)
                buyButton.alpha = 1
                buyButton.isEnabled = true
            }
        } else if let model = model as? Table {
            if ShopManager.boughtTableIndex?.contains(model.rawValue) ?? false {
                if model.rawValue == ShopManager.selectedTableIndex {
                    buyButton.setTitle("Activated", for: .normal)
                    buyButton.alpha = 0.6
                    buyButton.isEnabled = false
                } else {
                    buyButton.setTitle("Active", for: .normal)
                    buyButton.alpha = 0.6
                    buyButton.isEnabled = true
                }
            } else {
                buyButton.setTitle("BUY", for: .normal)
                buyButton.alpha = 1
                buyButton.isEnabled = true
            }
            
        } else if let model = model as? Cup {
            if ShopManager.boughtCupIndex?.contains(model.rawValue) ?? false {
                if model.rawValue == ShopManager.selectedCupIndex {
                    buyButton.setTitle("Activated", for: .normal)
                    buyButton.alpha = 0.6
                    buyButton.isEnabled = false
                } else {
                    buyButton.setTitle("Active", for: .normal)
                    buyButton.alpha = 0.6
                    buyButton.isEnabled = true
                }
            } else {
                buyButton.setTitle("BUY", for: .normal)
                buyButton.alpha = 1
                buyButton.isEnabled = true
            }
        }
//        if let model = model as? Ball{
//            mo
//        } e
    }
    
    func getCurrentCollectionView() -> UICollectionView {
        return collectionView
    }
    
    
    @IBAction func buyButtonPressed(_ sender: Any) {
        if let product = model {
            presenter.buyButton(model: product)
        }
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
extension ShopViewController: BuyViewDelegate {
    func confirmButtonPressed(item: Product) {
        presenter.buyProduct(model: item) { success in
            if success {
                self.updateCoins()
                self.collectionView.reloadData()
                self.animateOut(self.buyView!, overlay: self.overlay)
                self.configureBuyButton(model: item)
            } else {
                self.animateErrorLabel()
                self.buyView?.shake()
            }
        }
//        presenter.buyItem(character: item) { success in
//            if success {
//                updateCointCount()
//                collectionViewReloadData()
//                animateOut(buyView!, overlay: overlay)
//            } else {
//                buyView!.shake()
//            }
//        }
        
    }
    
    func cancelButtonPressed(item: Product) {
        animateOut(buyView!, overlay: overlay)
    }
    
     
}
