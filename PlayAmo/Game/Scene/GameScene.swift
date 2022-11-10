//
//  GameScene.swift
//  PlayAmo
//
//  Created by Anastasia Koldunova on 26.10.2022.
//

import SpriteKit
import GameplayKit

protocol GameOverDelegate: AnyObject {
    func gameOver(win:Bool)
}
class GameScene: SKScene {
    
    var firstLaunch = true
    var gameManager: GameSceneManager!
    weak var gamOverDelegate: GameOverDelegate?
    weak var parentVC: GameViewController?
    var ballSpawnBalls: Int = 0
    var ballGotIntoCup: Int = 0 {
        didSet {
//            if ballGotIntoCup == 2 {
//                let ballNode = spawnBallNode()
//                gameManager.toucheble.append(ballNode)
//                addChild(ballNode)
//            }
        }
    }
    
//    lazy var ballNode: BallNode = {
//        let ballNode = BallNode()
//        ballNode.position = CGPoint(x: 0, y: -300)
//        return ballNode
//    }()
    
    override func sceneDidLoad() {
        gameManager = GameSceneManager(scene: self)
    }
    
    override func didMove(to view: SKView) {
        let ballNode = spawnBallNode()
        gameManager.toucheble.append(ballNode)
        addChild(ballNode)
        // Get label node from scene and store it for use later
        
        setUpPhysicBodies()
        let table = childNode(withName: "tenissTable") as! SKSpriteNode
        let tableText = ShopManager.selectedModel.table.texture
        table.texture = tableText
      
    }
    
    func spawnBallNodeAtScene() {
        let ball = childNode(withName: "ball")
        if parentVC?.presenter.isCreatedGame ?? false {
            if !firstLaunch {
                
                ballSpawnBalls = 0
                let ballNode = spawnBallNode()
                gameManager.toucheble.append(ballNode)
                addChild(ballNode)
            } else {
                firstLaunch = false
            }
        } else {
            ballSpawnBalls = 0
            let ballNode = spawnBallNode()
            gameManager.toucheble.append(ballNode)
            addChild(ballNode)
        }
    }
    
    func spawnBallNode() -> BallNode {
        let ballNode = BallNode()
        ballNode.position = CGPoint(x: 0, y: -300)
        return ballNode
    }
    
    func setUpPhysicBodies() {
        let cups = children.filter({$0.name == "cup"}) as! [SKSpriteNode]
        for cup in cups {
            let cupText = ShopManager.selectedModel.cup.texture
            let midText = ShopManager.selectedModel.cup.middleTexture
            cup.texture = cupText
            let midCup = cup.childNode(withName: "middlecp") as! SKSpriteNode
            midCup.texture = midText
            let winPoint = midCup.childNode(withName: "winPoint") as! SKSpriteNode
            winPoint.physicsBody = SKPhysicsBody(rectangleOf: winPoint.size)
            winPoint.physicsBody?.pinned = true
            winPoint.physicsBody?.categoryBitMask = PhysicCategory.winPoint
    //        winPoint.physicsBody?.contactTestBitMask = PhysicCategory.ball
            winPoint.physicsBody?.collisionBitMask = 0
            
            
            let borders = cup.children.filter({$0.name == "border"}) as! [SKSpriteNode]
            for border in borders {
                border.physicsBody = SKPhysicsBody(rectangleOf: border.size)
                border.physicsBody?.pinned = true
                border.physicsBody?.categoryBitMask = PhysicCategory.border
                border.physicsBody?.collisionBitMask = 0
            }
            
        }
       
        
//        let ground = childNode(withName: "table") as! SKSpriteNode
        let groundArray = children.filter({$0.name == "table"}) as! [SKSpriteNode]
        for ground in groundArray {
            ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
            ground.physicsBody?.pinned = true
            ground.physicsBody?.restitution = 1.0
            ground.physicsBody?.categoryBitMask = PhysicCategory.ground
//            ground.physicsBody?.contactTestBitMask = PhysicCategory.ball
            ground.physicsBody?.collisionBitMask = 0
        }
        let upTable = childNode(withName: "upTable") as! SKSpriteNode
//        let upTables = children.filter({$0.name == "upTable"}) as! [SKSpriteNode]
//        for upTable in upTables {
            upTable.physicsBody = SKPhysicsBody(rectangleOf: upTable.size)
            upTable.physicsBody?.pinned = true
            upTable.physicsBody?.restitution = 1.0
            upTable.physicsBody?.allowsRotation = false
            upTable.physicsBody?.categoryBitMask = PhysicCategory.upGroudn
//        }
//        let upTable1 = childNode(withName: "upTable1") as! SKSpriteNode
//        upTable1.physicsBody = SKPhysicsBody(rectangleOf: upTable1.size)
//        upTable1.physicsBody?.pinned = true
//        upTable1.physicsBody?.restitution = 1.0
//        upTable1.physicsBody?.allowsRotation = false
//        upTable1.physicsBody?.categoryBitMask = PhysicCategory.upGroudn1
    }
   
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        gameManager.toucheble.forEach { node in
            node.touchesBegan(touches, with: event)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        gameManager.toucheble.forEach { node in
            node.touchesMoved(touches, with: event)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        gameManager.toucheble.forEach { node in
            node.touchesEnded(touches, with: event)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        gameManager.toucheble.forEach { node in
            node.touchesCancelled(touches, with: event)
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
