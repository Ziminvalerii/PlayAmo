//
//  Router.swift
//  PlayAmo
//
//  Created by Anastasia Koldunova on 26.10.2022.
//

import UIKit


protocol RouterProtocol {
    //MARK: - Properties
    var navigationController: UINavigationController {get set}
    var builder: BuilderProtocol {get set}
    
    func presentGameVC(connectionMannager: ConnectionManager, isTraining: Bool, isCreatedGame: Bool)
    func presentSettingsVC()
    func presentShopVC()
    func presentInfoVC()
    func presentBonusVC()
    func presentPrivacyVC()
    func dissmissVC()
}

class Router: RouterProtocol {
    
    var navigationController: UINavigationController
    var builder: BuilderProtocol
    
    init(navigationController: UINavigationController, builder: BuilderProtocol) {
        self.builder = builder
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = builder.resolveStartGameViewController(router: self)
        navigationController.viewControllers = [vc]
    }
    
    func presentGameVC(connectionMannager: ConnectionManager, isTraining: Bool, isCreatedGame: Bool) {
        let vc = builder.resolveGameViewController(router: self, connectionMannager: connectionMannager, isTraining: isTraining, isCreatedGame: isCreatedGame)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        navigationController.present(vc, animated: true)
    }
    
    func presentSettingsVC() {
        let vc = builder.resolveSettingsViewController(router: self)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        navigationController.present(vc, animated: true)
    }
    
    func presentShopVC() {
        let vc = builder.resolveShopViewController(router: self)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        navigationController.present(vc, animated: true)
    }
    
    func presentInfoVC() {
        let vc = builder.resolveInfoViewController(router: self)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        navigationController.present(vc, animated: true)
    }
    
    func presentBonusVC() {
        let vc = builder.ressolveBonusViewController(router: self)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        navigationController.present(vc, animated: true)
    }
    
    func presentPrivacyVC() {
        guard let url = URL(string: "https://docs.google.com/document/d/1V4wEeazU47I-K3dOcN_0T83T7kCqBozgbqiBO8tQrns/edit?usp=sharing") else {return}
        let vc = builder.createPrivacyPolicViewController(url: url)
        vc.modalPresentationStyle = .formSheet
        if let topVC = UIApplication.getTopViewController() {
            topVC.present(vc, animated: true)
        }
    }
    
    func dissmissVC() {
        
        navigationController.dismiss(animated: true)
    }
}
