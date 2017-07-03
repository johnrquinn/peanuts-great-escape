//
//  GameScene.swift
//  PGE
//
//  Created by John Quinn on 7/2/17.
//  Copyright © 2017 Dilldrup LLC. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var peanut = SKSpriteNode()
    
    var floor = SKSpriteNode()
    
    var bg = SKSpriteNode()
    
    var edge = SKSpriteNode()
    
    var lastUpdateTime: TimeInterval = 0
    
    var score = 0
    
    var jumpCount = 0
    
    var gameOver = false
    
    var gameOverLabel = SKLabelNode()
    
    var scoreLabel = SKLabelNode()
    
    enum ColliderType: UInt32 {
        
        case Peanut = 1
        case Baddie = 2
        case Object = 4
        case Edge = 31
        
    }
    
    override func didMove(to view: SKView) {
    
        self.physicsWorld.contactDelegate = self
        
        setupGame()
        
    }
    
    func setupGame() {
        
        lastUpdateTime = 0
        
        // SETTING UP BACKGROUND
        
        let bgTexture = SKTexture(imageNamed: "bg.png")
        
        let moveBGAnimation = SKAction.move(by: CGVector(dx: -bgTexture.size().width, dy: 0), duration: 7)
        let shiftBGAnimation = SKAction.move(by: CGVector(dx: bgTexture.size().width, dy: 0), duration: 0)
        let moveBGForever = SKAction.repeatForever(SKAction.sequence([moveBGAnimation, shiftBGAnimation]))
        
        var i: CGFloat = 0
        
        while i < 3 {
            
            bg = SKSpriteNode(texture: bgTexture)
            
            bg.position = CGPoint(x: bgTexture.size().width * i, y: self.frame.midY)
            
            bg.size.height = self.frame.height
            
            bg.run(moveBGForever)
            
            bg.zPosition = -2
            
            self.addChild(bg)
            
            i += 1
            
        }
        
        // SET UP THE CAT
        
        let peanutTexture = SKTexture(imageNamed: "peanutWalk1.png")
        let peanutTexture2 = SKTexture(imageNamed: "peanutWalk2.png")
        
        let animation = SKAction.animate(with: [peanutTexture, peanutTexture2], timePerFrame: 0.15)
        let makePeanutWalk = SKAction.repeatForever(animation)
        
        peanut = SKSpriteNode(texture: peanutTexture)
        
        peanut.position = CGPoint(x: self.frame.midX, y: -300)
        
        peanut.run(makePeanutWalk)
        
        peanut.physicsBody = SKPhysicsBody(circleOfRadius: peanutTexture.size().height / 2)
        
        peanut.physicsBody!.isDynamic = true
        peanut.physicsBody!.allowsRotation = false
        
        peanut.physicsBody!.categoryBitMask = ColliderType.Peanut.rawValue
        peanut.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        peanut.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        peanut.physicsBody!.contactTestBitMask = ColliderType.Baddie.rawValue
        
        self.addChild(peanut)
        
        // SET UP THE FLOOR
        
        let floorTexture = SKTexture(imageNamed: "wood.png")
        
        floor = SKSpriteNode(texture: floorTexture)
        
        floor.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: floor.size.width,
                                                              height: floor.size.height))
        
        floor.physicsBody!.isDynamic = false
        
        floor.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        floor.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        floor.physicsBody!.contactTestBitMask = ColliderType.Peanut.rawValue
                
        floor.position = CGPoint(x: self.frame.midX, y: -550)
        
        self.addChild(floor)
        
        // SET UP THE SCORE
        
        scoreLabel.fontName = "Helvetica"
        
        scoreLabel.fontSize = 60
        
        scoreLabel.text = "0"
        
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2 - 70)
        
        self.addChild(scoreLabel)
        
        // SET UP THE EDGE
        
        edge.alpha = 0
        
        edge.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 2,
                                                              height: self.size.height))
        
        edge.physicsBody!.isDynamic = false
        
        edge.physicsBody!.categoryBitMask = ColliderType.Edge.rawValue
        edge.physicsBody!.collisionBitMask = ColliderType.Baddie.rawValue
        
        edge.position = CGPoint(x: -435, y: self.frame.midY)
        
        self.addChild(edge)
        
        // SPAWN BADDIES INFINITELY
        
        let wait = SKAction.wait(forDuration: 3, withRange: 2)
        
        let spawn = SKAction.run {
            self.makeBaddie(at: CGPoint(x: 400, y: -330))
        }
        
        let sequence = SKAction.sequence([wait, spawn])
        self.run(SKAction.repeatForever(sequence))
        
    }
    
    func makeBaddie(at position: CGPoint) {
        
        var baddie = SKSpriteNode()
        
        let baddieTexture = SKTexture(imageNamed: "vacuumBaddie.png")
        
        baddie = SKSpriteNode(texture: baddieTexture)
        
        baddie.physicsBody = SKPhysicsBody(circleOfRadius: baddieTexture.size().height / 2)
        
        baddie.physicsBody!.isDynamic = true
        baddie.physicsBody!.allowsRotation = false
        
        baddie.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        baddie.physicsBody!.categoryBitMask = ColliderType.Baddie.rawValue
        baddie.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        baddie.physicsBody!.contactTestBitMask = ColliderType.Peanut.rawValue
        
        baddie.position = position
        addChild(baddie)
        
        // MOVE BADDIES LEFT
        
        let moveLeft = SKAction.moveBy(x: -800, y:0, duration:6.0)
        baddie.run(moveLeft)
    
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var firstBody : SKPhysicsBody
        var secondBody : SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (firstBody.categoryBitMask == 2 && secondBody.categoryBitMask == 31) {
            // if baddie hit left wall
            contact.bodyB.node?.removeFromParent()
            score += 1
            scoreLabel.text = String(score)
        } else if (firstBody.categoryBitMask == 1 && secondBody.categoryBitMask == 4) {
            // if peanut hit the floor
            jumpCount = 0
            print("jumpCount reset")
        }
        else if (firstBody.categoryBitMask == 1 && secondBody.categoryBitMask == 2) {
            self.speed = 0
            
            gameOver = true
            
            gameOverLabel.fontName = "Helvetica"
            
            gameOverLabel.fontSize = 30
            
            gameOverLabel.text = "Game Over! Tap to play again."
            
            gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            
            self.addChild(gameOverLabel)
        }
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameOver == false && jumpCount < 3 {
            
            peanut.physicsBody!.isDynamic = true
            
            peanut.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
            
            peanut.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 65))
            
            jumpCount += 1
            
        } else if gameOver == true {
            
            // this is where tapping restarts the game
            
            gameOver = false
            
            self.speed = 1
            
            self.removeAllChildren()
            
            setupGame()
            
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }

    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered

    }
}
