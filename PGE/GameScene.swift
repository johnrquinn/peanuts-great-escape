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
    
    var lastUpdateTime: TimeInterval = 0
    
    var score = 0
    
    var gameOver = false
    
    enum ColliderType: UInt32 {
        
        case Object = 1
        
    }
    
    override func didMove(to view: SKView) {
    
        self.physicsWorld.contactDelegate = self
        
        setupGame()
        
    }
    
    func setupGame() {
        
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
        
        // SETTING UP THE CAT
        
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
        
        peanut.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        peanut.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        peanut.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        self.addChild(peanut)
        
        // SETTING UP THE FLOOR
        
        let floorTexture = SKTexture(imageNamed: "wood.png")
        
        floor = SKSpriteNode(texture: floorTexture)
        
        floor.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: floor.size.width,
                                                              height: floor.size.height))
        
        floor.physicsBody!.isDynamic = false
        
        floor.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        floor.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        floor.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        floor.position = CGPoint(x: self.frame.midX, y: -550)
        
        self.addChild(floor)
        
        // SPAWN BADDIES INFINITELY
        
        let wait = SKAction.wait(forDuration: 3, withRange: 2)
        
        let spawn = SKAction.run {
            self.makeBaddie(at: CGPoint(x: 300, y: -330))
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
        
        baddie.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        baddie.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        baddie.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        baddie.position = position
        addChild(baddie)
        
        // MOVE BADDIES LEFT
        
        let moveLeft = SKAction.moveBy(x: -800, y:0, duration:6.0)
        baddie.run(moveLeft)
        
        // need to remove baddies once they move off the screen.
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
        
        print("*******")
        print(firstBody)
        print("*******")
        print(secondBody)
        
        /*
        if gameOver == false {
            
            self.speed = 0
            
            gameOver = true
            
            timer.invalidate()
            
            gameOverLabel.fontName = "Helvetica"
            
            gameOverLabel.fontSize = 30
            
            gameOverLabel.text = "Game Over! Tap to play again."
            
            gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            
            self.addChild(gameOverLabel)
            
        } -- modify this code to end the game when peanut hits a baddie */
        
    }
    
    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameOver == false {
            
            peanut.physicsBody!.isDynamic = true
            
            peanut.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
            
            peanut.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 65))
            
        } else {
            
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

        /*
        var i = 0
        
        if i % 50000 == 0 {
            print("makeBaddie")
            makeBaddie(at: CGPoint(x: 300, y: -300))
        }
        
        i += 1  */
    }
}
