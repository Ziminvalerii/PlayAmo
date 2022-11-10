//
//  GameViewController.swift
//  PlayAmo
//
//  Created by Anastasia Koldunova on 26.10.2022.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: BaseViewController<GamePresenterProtocol>, GameView {

    @IBOutlet weak var playerScoreLabel: UILabel!
    @IBOutlet weak var oponentScoreLabel: UILabel!
    @IBOutlet weak var scoreView: UIView! {
        didSet {
            scoreView.isHidden = presenter.isTraining
        }
    }
    var gameOverView : GameOverView?
    var waitingView: WaitingView?
    var homeView: HomeView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                if let scene = scene as? GameScene {
                    scene.gamOverDelegate = self
                    scene.parentVC = self
                }
                
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
//            view.showsPhysics = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        if presenter.isCreatedGame && !presenter.isTraining {
            waitingView = WaitingView(frame: view.bounds)
            let gameView = view as! SKView
            gameView.isPaused = true
            view.addSubview(waitingView!)
            animateIn(waitingView!)
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    @IBAction func homeButtonpressed(_ sender: Any) {
        homeView = HomeView(frame: view.bounds)
        let gameView = view as! SKView
        gameView.isPaused = true
        homeView!.delegate = self
        view.addSubview(homeView!)
        
//        gameOverView?.isWin = win
        animateIn(homeView!)
    }
    
    func updateCurrentScore(with score: Int ) {
        playerScoreLabel.text = score.description
    }
    
    func recivedScore(_ score: Int) {
        DispatchQueue.main.async {
            self.oponentScoreLabel.text = score.description
            if let waitingView = self.waitingView {
                self.animateOut(waitingView) {
                    let gameView = self.view as! SKView
                    gameView.isPaused = false
                    if let scene = gameView.scene as? GameScene {
                        scene.spawnBallNodeAtScene()
                    }
                }
            }
        }
       
    }
    
    func showGameOverView(win: Bool) {
        gameOverView = GameOverView(frame: view.bounds, iswin: win)
        let gameView = view as! SKView
        gameView.isPaused = true
        gameOverView!.delegate = self
        view.addSubview(gameOverView!)
//        gameOverView?.isWin = win
        animateIn(gameOverView!)
        AudioManager.shared.player?.pause()
        AudioManager.shared.playSound(win ? .win : .loss)
        gameOverView!.animateImages()
    }
    
    func sendScore(_ score: Int) {
        presenter.connectionMannager.send(message: .score(score))
        updateCurrentScore(with: score)
        waitingView = WaitingView(frame: view.bounds)
        let gameView = view as! SKView
        gameView.isPaused = true
        view.addSubview(waitingView!)
        animateIn(waitingView!)
        
    }
    
    func gameOver(_ isWin: Bool) {
        presenter.connectionMannager.send(message: .win(isWin))
        if isWin {
            Defaults.coinsCount! += Defaults.stake
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.showGameOverView(win: isWin)
        }
    }
    
    func animateIn(_ view: UIView) {
        view.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        view.alpha = 0
        UIView.animate(withDuration: 0.4) {
            view.alpha = 1
            view.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut(_ view : UIView, complition: @escaping () -> Void) {
        UIView.animate(withDuration: 0.4) {
            view.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            view.alpha = 0
        } completion: { (_) in
            view.removeFromSuperview()
            complition()
        }
    }
}

extension GameViewController: GameOverDelegate {
    func gameOver(win: Bool) {
        if presenter.isTraining {
            showGameOverView(win: win)
        }
//        gameOverView = GameOverView(frame: view.bounds, iswin: win)
//        let gameView = view as! SKView
//        gameView.isPaused = true
//        gameOverView!.delegate = self
//        view.addSubview(gameOverView!)
////        gameOverView?.isWin = win
//        animateIn(gameOverView!)
//        AudioManager.shared.player?.pause()
//        AudioManager.shared.playSound(win ? .win : .loss)
//        gameOverView!.animateImages()
    }
    
    
}

extension GameViewController: GameOverViewDelegate {
    func menuButtonPressed() {
        if presenter.isTraining {
            presenter.dismissVC()
        } else {
            presenter.connectionMannager.disconnect()
            presenter.dismissVC()
        }
    }
    
    
}

extension GameViewController: HomeViewDelegate {
    func okButtonPressed() {
        if presenter.isTraining {
            presenter.dismissVC()
        } else {
            presenter.connectionMannager.disconnect()
            presenter.dismissVC()
        }
        
    }
    
    func cancelButtonPressed() {
        animateOut(homeView!) {
            let gameView = self.view as! SKView
            gameView.isPaused = false
        }
    }
    
    
}
