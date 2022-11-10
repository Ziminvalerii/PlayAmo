//
//  StartGamePresenter.swift
//  PlayAmo
//
//  Created by Anastasia Koldunova on 26.10.2022.
//

import UIKit


protocol StartGameView:AnyObject {
    func getCurIndex() -> Int
}

protocol StartGamePresenterProtocol: AnyObject {
    init(view: StartGameView, router: RouterProtocol, connectionMannager: ConnectionManager)
    var connectionMannager: ConnectionManager {get}
    func goToGameVC(isTraining: Bool, isCreatedGame: Bool)
    func goToSettingsVC()
    func goToShopVC()
    func goToInfoVC()
    func goToBonusVC()
    
}

class StartGamePresenter: StartGamePresenterProtocol {
    weak var view: StartGameView?
    private var router: RouterProtocol
    var connectionMannager: ConnectionManager
    
    let stakeInt: [Float: Int] = [1 : 100, 1.5: 250, 2: 500, 2.5: 750, 3: 1000, 3.5: 1500, 4: 2000, 4.5: 3000, 5: 5000, 5.5: 7500, 6: 10000 ]
    required init(view: StartGameView, router: RouterProtocol, connectionMannager: ConnectionManager) {
        self.view = view
        self.router = router
        self.connectionMannager = connectionMannager
        self.connectionMannager.connectionDelegate = self
    }
    
    func goToInfoVC() {
        router.presentInfoVC()
    }
    
    func goToShopVC() {
        router.presentShopVC()
    }
    
    func goToGameVC(isTraining: Bool, isCreatedGame: Bool) {
        router.presentGameVC(connectionMannager: connectionMannager, isTraining: isTraining, isCreatedGame: isCreatedGame)
    }
    
    func goToSettingsVC() {
        router.presentSettingsVC()
    }
    
    func goToBonusVC() {
        router.presentBonusVC()
    }
}

extension StartGamePresenter: ConnectionProtocol {
    func connected() {
        goToGameVC(isTraining: false, isCreatedGame: view?.getCurIndex() == 1)
    }
    
    
}
