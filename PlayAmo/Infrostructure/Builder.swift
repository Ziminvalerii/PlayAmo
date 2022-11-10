//
//  Builder.swift
//  PlayAmo
//
//  Created by Anastasia Koldunova on 26.10.2022.
//

import UIKit


protocol BuilderProtocol {
    func resolveStartGameViewController(router: RouterProtocol) -> UIViewController
    func resolveGameViewController(router: RouterProtocol, connectionMannager: ConnectionManager, isTraining: Bool,isCreatedGame: Bool) -> UIViewController
    func resolveSettingsViewController(router: RouterProtocol) -> UIViewController
    func resolveShopViewController(router: RouterProtocol) -> UIViewController
    func resolveInfoViewController(router: RouterProtocol) -> UIViewController
    func ressolveBonusViewController(router: RouterProtocol) -> UIViewController
    func createPrivacyPolicViewController(url : URL) -> PrivacyPolicyViewController
//    func resolveLoaderViewController(router: RouterProtocol) -> UIViewController
}

class Builder: BuilderProtocol {
    func resolveStartGameViewController(router: RouterProtocol) -> UIViewController {
        let vc = StartGameViewController.instantiateMyViewController()
        vc.presenter = StartGamePresenter(view: vc, router: router, connectionMannager: ConnectionManager())
        return vc
    }
    
    func resolveGameViewController(router: RouterProtocol, connectionMannager: ConnectionManager, isTraining: Bool,isCreatedGame: Bool) -> UIViewController {
        let vc = GameViewController.instantiateMyViewController()
        vc.presenter = GamePresenter(view: vc, router: router, connectionMannager: connectionMannager, isTraining: isTraining, isCreatedGame: isCreatedGame)
        return vc
    }
    
    func resolveSettingsViewController(router: RouterProtocol) -> UIViewController {
        let vc = SettingsViewController.instantiateMyViewController()
        vc.presenter = SettingsPresenter(view: vc, router: router)
        return vc
    }
    
    func resolveShopViewController(router: RouterProtocol) -> UIViewController {
        let vc = ShopViewController.instantiateMyViewController()
        vc.presenter = ShopPresenter(view: vc, router: router)
        return vc
    }
    
    func resolveInfoViewController(router: RouterProtocol) -> UIViewController {
        let vc = InfoViewController.instantiateMyViewController()
        vc.presenter = InfoPresenter(view: vc, router: router)
        return vc
    }
    
    func ressolveBonusViewController(router: RouterProtocol) -> UIViewController {
        let vc = BonusViewController.instantiateMyViewController()
        vc.presenter = BonusPresenter(view: vc, router: router)
        return vc
    }
    
    func createPrivacyPolicViewController(url : URL) -> PrivacyPolicyViewController {
        let vc = PrivacyPolicyViewController(url: url)
        return vc
    }
    
//    func resolveLoaderViewController(router: RouterProtocol) -> UIViewController {
//        let vc = LoaderViewController.instantiateMyViewController()
//        vc.presenter = LoaderPresenter(view: vc, router: router)
//        return vc
//    }
}
