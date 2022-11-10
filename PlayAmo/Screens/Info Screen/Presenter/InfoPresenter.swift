//
//  InfoPresenter.swift
//  PlayAmo
//
//  Created by Anastasia Koldunova on 01.11.2022.
//

import Foundation


protocol InfoView:AnyObject {
    
}

protocol InfoPresenterProtocol: AnyObject {
    init(view: InfoView, router: RouterProtocol)
    func dismissVC()
}

class InfoPresenter: InfoPresenterProtocol {
    weak var view: InfoView?
    private var router: RouterProtocol
    
    required init(view: InfoView, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func dismissVC() {
        self.router.dissmissVC()
    }
}
