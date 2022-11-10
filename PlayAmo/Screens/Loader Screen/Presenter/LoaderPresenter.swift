//
//  LoaderPresenter.swift
//  PlayAmo
//
//  Created by Anastasia Koldunova on 06.11.2022.
//

import Foundation


protocol LoaderView:AnyObject {
    
}

protocol LoaderPresenterProtocol: AnyObject {
    init(view: LoaderView, router: RouterProtocol)
    func dismissVC()
}

class LoaderPresenter: LoaderPresenterProtocol {
    weak var view: LoaderView?
    private var router: RouterProtocol
    
    required init(view: LoaderView, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func dismissVC() {
        self.router.dissmissVC()
    }
}
