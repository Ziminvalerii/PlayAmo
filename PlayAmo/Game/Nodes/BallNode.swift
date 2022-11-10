//
//  ballNode.swift
//  PlayAmo
//
//  Created by Anastasia Koldunova on 27.10.2022.
//

import SpriteKit

class BallNode: SKSpriteNode {
    
    
    var isGotIntoCup: Bool = false
    //    var touchedBorder: Bool = false
    var touchedTable: Bool = false
    var touchedBorder: Bool = false
    private var ballTouchPos: CGPoint?
    var shouldAcceptTouches: Bool = true {
        didSet {
            self.isUserInteractionEnabled = shouldAcceptTouches
        }
    }
    
    init() {
        let texture = ShopManager.selectedModel.ball.texture
        //        let texture = SKTexture(imageNamed: "ball2")
        super.init(texture: texture, color: .clear, size: CGSize(width: 70, height: 70))
        zPosition = 22
        name = "ball"
        preparePhysicBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func preparePhysicBody() {
        physicsBody = SKPhysicsBody(circleOfRadius: 45/2)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.restitution = 1.5
        self.physicsBody?.mass = 0.15
        physicsBody?.pinned = true
        self.physicsBody?.categoryBitMask = PhysicCategory.ball
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = 0
    }
    
}
extension BallNode : Touchable {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let scene = scene else {return}
        if containsTouches(touches: touches, scene: scene, node: self) {
            if let touch = touches.first {
                ballTouchPos = touch.location(in: scene)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let scene = scene else {return}
        guard let ballPos = ballTouchPos else {return}
        if let touch = touches.first {
            let touchPoint =  touch.location(in: scene)
            if let touchedNode = scene.atPoint(touchPoint) as? BallNode {
                print("not swipe")
                return
            }
            physicsBody?.pinned = false
            
            let x = getNeededX(point1: touchPoint, point2: ballPos, neededY: scene.size.height/2 - 100)
            applyAction(xPos: x, yPos: ballPos.y - touchPoint.y)
            //
        }
    }
    
    
    func getNeededX(point1: CGPoint, point2: CGPoint, neededY: CGFloat) -> CGFloat {
        let pointDifX = point2.x - point1.x
        let pointDifY = point2.y - point1.y
        let neededPointY = neededY - point1.y
        let x = (pointDifX*neededPointY/pointDifY)+point1.x
        let dispanse = sqrt(pow((point2.x - point1.y), 2.0) + pow((point2.y - point1.y), 2.0))
        
        let angle = -atan2((-pointDifX), (-pointDifY))
        let dx = cos(angle + .pi / 2)
        return (-pointDifX)/7
    }
    
    func applyAction(xPos: CGFloat, yPos: CGFloat) {
        var ypos: CGFloat
        if yPos < 0 {
            ypos = -yPos
        } else {
            ypos = yPos
        }
        guard let scene = scene as? GameScene else {return}
        let impulseAction = SKAction.run {
            self.physicsBody?.applyImpulse(CGVector(dx: xPos, dy: ypos), at: CGPoint(x: 0, y: scene.size.height/2 - self.size.height/2))
        }
        
        let whoosh = SKAction.playSoundFileNamed("whoosh.mp3", waitForCompletion: false)
        self.run(whoosh)
        let groupAction = SKAction.group([impulseAction, SKAction.resize(toWidth: 45, height: 45, duration: 1)])
        let lastPosition = self.position
        scene.gameManager.toucheble.removeAll { node in
            if let node = node as? SKNode {
                return node.name == "ball"
            } else {
                return false
            }
        }
        self.run(SKAction.sequence([groupAction, SKAction.run {
            if ypos > 0 {
                let waitAction = SKAction.wait(forDuration: 1.9)
                self.run(waitAction) {
                    self.removeFromParent()
                }
            }
            if ypos > 170 {
                self.zPosition = 19
                
            }
            if ypos >= 300 {
                self.zPosition = 0
                //                let waitAction = SKAction.wait(forDuration: 1.9)
                //                self.run(waitAction) {
                //                        self.removeFromParent()
                //                }
                
            } else if ypos >= 275 {
                self.zPosition = 1.5
                self.physicsBody?.collisionBitMask = PhysicCategory.upGroudn
                self.physicsBody?.contactTestBitMask = PhysicCategory.upGroudn
            }
//                else if ypos > 260 {
//                self.physicsBody?.collisionBitMask = PhysicCategory.upGroudn1
//                self.physicsBody?.contactTestBitMask = PhysicCategory.upGroudn1
//            }
            else {
                self.physicsBody?.collisionBitMask = PhysicCategory.border | PhysicCategory.ground | PhysicCategory.upGroudn1
                self.physicsBody?.contactTestBitMask = PhysicCategory.ground | PhysicCategory.winPoint | PhysicCategory.border | PhysicCategory.upGroudn1
            }
            let groundArr = scene.children.filter({$0.name == "table"}) as! [SKSpriteNode]
            for node in groundArr {
                self.touchedTable = self.touchedTable || self.intersects(node)
            }
            
            //            let cup = scene.childNode(withName: "cup") as! SKSpriteNode
            //            let collisionPoint = cup.childNode(withName: "collisionPoint") as! SKSpriteNode
            //            let isIntersect = self.intersects(collisionPoint)
            //            self.touchedBorder = isIntersect
            
            //                self.zPosition = 15
            //            }
            if scene.parentVC?.presenter.isTraining ?? true {
                let ball = BallNode()
                ball.position = lastPosition
                scene.addChild(ball)
                scene.gameManager.toucheble.append(ball)
            } else {
                if scene.ballSpawnBalls < 1 {
                    scene.ballSpawnBalls += 1
                    let ball = BallNode()
                    ball.position = lastPosition
                    scene.addChild(ball)
                    scene.gameManager.toucheble.append(ball)
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        scene.parentVC?.sendScore(scene.ballGotIntoCup)
                    }
                }
            }
        }]))
    }
    
    func containsTouches(touches: Set<UITouch>, scene: SKScene, node: SKNode)->Bool {
        return touches.contains { touch in
            let touchPoint = touch.location(in: scene)
            let touchedNode = scene.atPoint(touchPoint)
            return touchedNode == node
        }
    }
    
}
