//
//  GameSceneManager.swift
//  PlayAmo
//
//  Created by Anastasia Koldunova on 27.10.2022.
//

import SpriteKit

protocol GameSceneManagerProtocol  {
    var scene: GameScene? { get }
    var toucheble: [Touchable] { get }
}

class GameSceneManager: NSObject, GameSceneManagerProtocol {
    var scene: GameScene?
    
    
    
    var toucheble: [Touchable] = [Touchable]()
    
    required init(scene: GameScene) {
        self.scene = scene
        super.init()
        preparePhysicsForWold(for: scene)
    }
    
    func preparePhysicsForWold(for scene: SKScene) {
        scene.physicsWorld.gravity = CGVector(dx: 0, dy: -11)
        scene.physicsWorld.contactDelegate = self
    }
    
}


extension GameSceneManager : SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let collision:UInt32 = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

        if collision == (PhysicCategory.winPoint | PhysicCategory.ball) {
            let waitAction = SKAction.wait(forDuration: 0.05)
            let fadeOutAction = SKAction.fadeOut(withDuration: 0.1)
            if let ball = (contact.bodyA.node as? BallNode) {
                let point = (contact.bodyB.node as! SKSpriteNode)
                let midCup = point.parent as! SKSpriteNode
                let cup = midCup.parent as! SKSpriteNode
                var isIntersects: Bool = false
                if let collisionPoint = cup.childNode(withName: "collisionPoint") as? SKSpriteNode {
                    isIntersects =  ball.intersects(collisionPoint)
                }
                if isIntersects && !(ball.position.y > point.position.y) {
                    ball.zPosition = cup.zPosition + 3
                    ball.physicsBody?.contactTestBitMask = PhysicCategory.ground |  PhysicCategory.border
                } else {
                    let splashSound = SKAction.playSoundFileNamed("waterSplash.mp3", waitForCompletion: false)
//                    scene?.run(splashSound)
                    if !ball.isGotIntoCup  {
                        ball.isGotIntoCup = true
                        AudioManager.shared.playSound(.splash)
                        ball.zPosition = cup.zPosition + 1
                        //                if !ball.touchedBorder {
                        ball.run(waitAction) {
                            ball.removeFromParent()
                            let moveAction = SKAction.moveBy(x: 0, y: 100, duration: 1)
                            cup.run(moveAction)
                            
                        }
                    }
                }
            } else if let ball = (contact.bodyB.node as? BallNode) {
                //                if !ball.touchedBorder {
                let point = (contact.bodyA.node as! SKSpriteNode)
                let midCup = point.parent as! SKSpriteNode
                let cup = midCup.parent as! SKSpriteNode
                var isIntersects: Bool = false
                point.move(toParent: scene!)
                if let collisionPoint = cup.childNode(withName: "collisionPoint") as? SKSpriteNode {
                    isIntersects =  ball.intersects(collisionPoint)
                }
                if !ball.isGotIntoCup  {
                    ball.isGotIntoCup = true
                if  !(ball.position.y > point.position.y) {
                    ball.zPosition = cup.zPosition + 3
                    ball.physicsBody?.contactTestBitMask = PhysicCategory.ground |  PhysicCategory.border
                } else {
                    let splashSound = SKAction.playSoundFileNamed("waterSplosh.mp3", waitForCompletion: true)
                    //                    scene?.run(splashSound)
                    
                    AudioManager.shared.playSound(.splash)
                    ball.zPosition = cup.zPosition + 1
                    //                if !ball.touchedBorder {
//                    scene?.gamOverDelegate?.gameOver(win: true)
                    self.scene?.ballGotIntoCup += 1
                    if scene?.ballGotIntoCup == 6 {
                        scene?.parentVC?.gameOver(true)
                    }
                    ball.run(waitAction) {
                        ball.removeFromParent()
                        let moveAction = SKAction.moveBy(x: 0, y: 100, duration: 0.75)
                        cup.run(moveAction) {
                            var xPosiiton: CGFloat
                            if cup.position.x >= 0 {
                                xPosiiton = (self.scene?.size.width ?? 300)/2 + 50
                            } else {
                                xPosiiton = -(self.scene?.size.width ?? 300)/2 - 50
                            }
//                            = (cup.position.x >= 0) ? (scene?.size.width/2 + 50) : (-scene?.size.width/2 - 50)
                            let moveXAction = SKAction.moveTo(x: xPosiiton, duration: 1)
                            cup.run(moveXAction) {
                                cup.removeFromParent()
                                
//                                let ball = self.scene?.childNode(withName: "ball")
//                                if ball == nil {
//                                    print("SEND MESSAGE")
                                    
//                                }
                                let cupArray = self.scene?.children.filter({$0.name == "cup"})
                                if (cupArray?.isEmpty ?? true) || (cupArray?.count == 0) ?? true {
                                    
                                    self.scene?.gamOverDelegate?.gameOver(win: true)
                                }
                            }
                        }
                    }
                    
                }
            }
                point.move(toParent: midCup)
            }
        }
        if collision == (PhysicCategory.ground | PhysicCategory.ball) {
            
            let fadeOutAction = SKAction.fadeOut(withDuration: 1)
            if let ball = (contact.bodyA.node as? BallNode) {
                let ground = contact.bodyB.node as! SKSpriteNode
                let groundArr = scene?.children.filter({$0.name == "table"}) as! [SKSpriteNode]
                if !ball.touchedTable {
                    for element in groundArr {
                        if element != ground {
                            element.physicsBody?.categoryBitMask = 0
                        }
                    }
                } else {
                    ball.touchedTable = false
                }
                let whoosh = SKAction.playSoundFileNamed("pongsound.mp3", waitForCompletion: false)
               
                scene?.run(whoosh)
                ball.physicsBody?.contactTestBitMask = PhysicCategory.ground
                
                ball.run(fadeOutAction) {
                    ball.removeFromParent()
                    for element in groundArr {
                        element.physicsBody?.categoryBitMask = PhysicCategory.ground
                    }
                }
            } else if let ball = (contact.bodyB.node as? BallNode) {
                let ground = contact.bodyA.node as! SKSpriteNode
                let groundArr = scene?.children.filter({$0.name == "table"}) as! [SKSpriteNode]
                if !ball.touchedTable {
                    for element in groundArr {
                        if element != ground {
                            element.physicsBody?.categoryBitMask = 0
                        }
                    }
                } else {
                    ball.touchedTable = false
                }
                let whoosh = SKAction.playSoundFileNamed("pongsound.mp3", waitForCompletion: false)
               
                scene?.run(whoosh)
                ball.physicsBody?.contactTestBitMask = PhysicCategory.ground
                ball.run(fadeOutAction) {
                    ball.removeFromParent()
                    for element in groundArr {
                        element.physicsBody?.categoryBitMask = PhysicCategory.ground
                    }
                }
            }
        }
        if collision == (PhysicCategory.border | PhysicCategory.ball) {
            if let ball = (contact.bodyA.node as? BallNode) {
                let border = (contact.bodyB.node as! SKSpriteNode)
                let cup = border.parent as! SKSpriteNode
                if !ball.isGotIntoCup && !ball.touchedBorder {
                    ball.zPosition =  cup.zPosition + 3
                }
                ball.touchedTable = true
                border.move(toParent: scene!)
                if ball.position.y >= border.position.y {
                    ball.physicsBody?.contactTestBitMask =  PhysicCategory.ground |  PhysicCategory.border
                }
                border.move(toParent: cup)
            } else if let ball = (contact.bodyB.node as? BallNode) {
                let border = (contact.bodyA.node as! SKSpriteNode)
                
                let cup = border.parent as! SKSpriteNode
//                ball.physicsBody?.collisionBitMask = PhysicCategory.border | PhysicCategory.ground
//                ball.physicsBody?.contactTestBitMask = PhysicCategory.ground | PhysicCategory.winPoint | PhysicCategory.border
                if !ball.isGotIntoCup && !ball.touchedBorder {
                    ball.zPosition =  cup.zPosition + 3
                }
                ball.touchedBorder = true
                border.move(toParent: scene!)
                if ball.position.y >= border.position.y {
                    ball.physicsBody?.contactTestBitMask =  PhysicCategory.ground | PhysicCategory.border
                }
                border.move(toParent: cup)
            }
        }
        
        if collision == (PhysicCategory.upGroudn | PhysicCategory.ball) {
            let fadeOutAction = SKAction.fadeOut(withDuration: 1)
            if let ball =  (contact.bodyA.node as? BallNode) {
                ball.run(fadeOutAction)
            } else if let ball = (contact.bodyB.node as? BallNode) {
                ball.run(fadeOutAction)
            }
        }
        if collision == (PhysicCategory.upGroudn1 | PhysicCategory.ball) {
            let fadeOutAction = SKAction.fadeOut(withDuration: 1)
            if let ball =  (contact.bodyA.node as? BallNode) {
                ball.run(fadeOutAction)
            } else if let ball = (contact.bodyB.node as? BallNode) {
                ball.run(fadeOutAction)
            }
        }
    }
}
