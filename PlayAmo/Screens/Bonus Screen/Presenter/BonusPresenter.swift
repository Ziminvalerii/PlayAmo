//
//  BonusPresenter.swift
//  PlayAmo
//
//  Created by Anastasia Koldunova on 08.11.2022.
//

import UIKit


protocol BonusView:AnyObject {
    
}

protocol BonusPresenterProtocol: AnyObject {
    init(view: BonusView, router: RouterProtocol)
    func dismissVC()
}

class BonusPresenter: BonusPresenterProtocol {
    weak var view: BonusView?
    private var router: RouterProtocol
    
    required init(view: BonusView, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func dismissVC() {
        self.router.dissmissVC()
    }
}
