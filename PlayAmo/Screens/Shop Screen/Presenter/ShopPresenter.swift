//
//  ShopPresenter.swift
//  PlayAmo
//
//  Created by Anastasia Koldunova on 30.10.2022.
//

import UIKit


protocol ShopView:AnyObject {
    func getCurrentCollectionView() -> UICollectionView
    func configureBuyButton(model: Product)
    func showBuyView(item: Product)
}

protocol ShopPresenterProtocol: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    init(view: ShopView, router: RouterProtocol)
    func buyProduct(model:Product, complition: @escaping (Bool) -> Void)
    func buyButton(model: Product)
    func dismissVC()
    
}

class ShopPresenter: NSObject, ShopPresenterProtocol {
    weak var view: ShopView?
    private var router: RouterProtocol
    let productArray = ShopManager.products
    
    required init(view: ShopView, router: RouterProtocol) {
        self.view = view
        self.router = router
        
//        Defaults.coinsCount = 500
        
        if ShopManager.boughtCupIndex == nil || ShopManager.boughtCupIndex?.count == 0 || ShopManager.boughtCupIndex?.isEmpty ?? true {
            ShopManager.boughtCupIndex = [0]
        }
        
        if ShopManager.boughtTableIndex == nil || ShopManager.boughtTableIndex?.count == 0 || ShopManager.boughtTableIndex?.isEmpty ?? true {
            ShopManager.boughtTableIndex = [0]
        }
        
        if ShopManager.boughtBallIndex == nil || ShopManager.boughtBallIndex?.count == 0 || ShopManager.boughtBallIndex?.isEmpty ?? true {
            ShopManager.boughtBallIndex = [0]
        }
    }
    
    
    private func currentCell(scrollView: UIScrollView, collectionView: UICollectionView) -> UICollectionViewCell? {
            guard var closestCell = collectionView.visibleCells.first else { return nil }
            for cell in collectionView.visibleCells as [UICollectionViewCell] {
                let closestCellDelta = abs(closestCell.center.x - collectionView.bounds.size.width/2.0 - collectionView.contentOffset.x)
                let cellDelta = abs(cell.center.x - collectionView.bounds.size.width/2.0 - collectionView.contentOffset.x)
                if (cellDelta < closestCellDelta) {
                    closestCell = cell
                }
            }
            return closestCell
        }

    func buyProduct(model:Product, complition: (Bool) -> Void) {
        if let model = model as? Ball {
            if Defaults.coinsCount != nil && Defaults.coinsCount ?? 0 >= model.price {
                ShopManager.boughtBallIndex?.append(model.rawValue)
                Defaults.coinsCount! -= model.price
                complition(true)
            } else {
                complition(false)
            }
        } else if let model = model as? Cup {
            if Defaults.coinsCount != nil && Defaults.coinsCount ?? 0 >= model.price {
                ShopManager.boughtCupIndex?.append(model.rawValue)
                Defaults.coinsCount! -= model.price
                complition(true)
            } else {
                complition(false)
            }
        } else if let model = model as? Table {
            if Defaults.coinsCount != nil && Defaults.coinsCount ?? 0 >= model.price {
                ShopManager.boughtTableIndex?.append(model.rawValue)
                Defaults.coinsCount! -= model.price
                complition(true)
            } else {
                complition(false)
            }
        }
    }
    
    func buyButton(model: Product) {
        if let model = model as? Ball {
            if ShopManager.boughtBallIndex?.contains(model.rawValue) ?? false {
                 ShopManager.selectedBallIndex = model.rawValue
            } else {
                view?.showBuyView(item: model)
                
            }
        } else if let model = model as? Cup {
            if ShopManager.boughtCupIndex?.contains(model.rawValue) ?? false {
                 ShopManager.selectedCupIndex = model.rawValue
            } else {
                view?.showBuyView(item: model)
                
            }
            
        } else if let model = model as? Table {
            if ShopManager.boughtTableIndex?.contains(model.rawValue) ?? false {
                 ShopManager.selectedTableIndex = model.rawValue
            } else {
                view?.showBuyView(item: model)
                
            }
        }
    }
    
    func dismissVC() {
        router.dissmissVC()
    }
}

extension ShopPresenter : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "shop_cell", for: indexPath) as! ShopCollectionViewCell
        cell.layer.cornerRadius = 10
        let data = productArray[indexPath.row]
        if indexPath.row == 0 {
            view?.configureBuyButton(model: data)
        }
        if let data = data as? Ball {
            if ShopManager.boughtBallIndex?.contains(data.rawValue) ?? false {
                cell.coinStackView.isHidden = true
            } else {
                cell.coinStackView.isHidden = false
            }
            
        } else if let data = data as? Table {
            if ShopManager.boughtTableIndex?.contains(data.rawValue) ?? false {
                cell.coinStackView.isHidden = true
            } else {
                cell.coinStackView.isHidden = false
            }
//            cell.configure(image: data.image, price: data.price)
        } else if let data = data as? Cup {
            if ShopManager.boughtCupIndex?.contains(data.rawValue) ?? false {
                cell.coinStackView.isHidden = true
            } else {
                cell.coinStackView.isHidden = false
            }
//            cell.configure(image: data.image, price: data.price)
        }
        cell.configure(model: data)
//        switch indexPath.section {
//        case 0:
//            let array = (productArray["tables"] as! [Table])
////            let array = (productArray["balls"] as! [Ball])
//            let data = array[indexPath.row]
//            cell.configure(image: data.image, price: 100)
//        case 1:
//            let array = (productArray["balls"] as! [Ball])
////            let array = (productArray["tables"] as! [Table])
//            let data = array[indexPath.row]
//            cell.configure(image: data.image, price: 100)
//        case 2:
//            let array = (productArray["cups"] as! [Cup])
//            let data = array[indexPath.row]
////            cell.configure(image: data.image, price: 100)
//        default:
//            break;
//        }
       
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let view = view else {return}
        if let cell = currentCell(scrollView: scrollView, collectionView: view.getCurrentCollectionView()), let currentCell = cell as? ShopCollectionViewCell {
            if let model = currentCell.model {
                view.configureBuyButton(model:model)
            }
                    //view.currentModel = currentCell.model
//                    view.configureShopButton(currentModel: currentCell.model)
                }

    }
    
}
