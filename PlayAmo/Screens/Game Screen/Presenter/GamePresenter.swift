//
//  GamePresenter.swift
//  PlayAmo
//
//  Created by Anastasia Koldunova on 27.10.2022.
//

import UIKit


protocol GameView:AnyObject {
    func recivedScore(_ score: Int)
    func showGameOverView(win: Bool)
}

protocol GamePresenterProtocol: AnyObject {
    var connectionMannager: ConnectionManager { get }
    var isTraining: Bool { get }
    var isCreatedGame: Bool { get }
    init(view: GameView, router: RouterProtocol, connectionMannager: ConnectionManager, isTraining: Bool,isCreatedGame: Bool)
    func dismissVC()
}

class GamePresenter: GamePresenterProtocol {
    weak var view: GameView?
    private var router: RouterProtocol
    var connectionMannager: ConnectionManager
    var isTraining: Bool
    var isCreatedGame: Bool
    
    required init(view: GameView, router: RouterProtocol, connectionMannager: ConnectionManager, isTraining: Bool, isCreatedGame: Bool) {
        self.view = view
        self.router = router
        self.connectionMannager = connectionMannager
        self.isTraining = isTraining
        self.isCreatedGame = isCreatedGame
        connectionMannager.recieveDelegate = self
       
    }
    
    func dismissVC() {
        DispatchQueue.main.async {
            self.router.dissmissVC()
        }
        
    }
}

extension GamePresenter: PeerRecieveDelegate {
    func disconnected() {
        dismissVC()
    }
    
    func recieved(message: MessageType) {
        switch message {
        case .conecting(let int):
            return
        case .score(let score):
            view?.recivedScore(score)
        case .win(let iswin):
            if iswin {
                Defaults.coinsCount! -= Defaults.stake
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.view?.showGameOverView(win: !iswin)
            }
        }
    }
}
