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
    
    var bg = SKSpriteNode() // used to set background
    
    var edge = SKSpriteNode() // used for removing baddies when they move off the screen
    
    var goal = SKSpriteNode() // used for scoring
    
    var lastUpdateTime: TimeInterval = 0
    
    var score = 0
    
    var highScore = 0
    
    var jumpCount = 0
    
    var gameOver = false
    
    var gameOverLabel = SKLabelNode()
    
    var highScoreLabel = SKLabelNode()
    
    var scoreLabel = SKLabelNode()
    
    enum ColliderType: UInt32 {
        
        case Peanut = 1
        case Baddie = 2
        case Object = 4
        case Goal = 30
        case Edge = 31
        
    }
    
    override func didMove(to view: SKView) {
    
        self.physicsWorld.contactDelegate = self
        
        setupGame()
        
    }
    
    func setupGame() {
        
        lastUpdateTime = 0
        
        score = 0
        
        // SET UP THE BACKGROUND
        
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
        
        floor.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: floor.size.width, height: floor.size.height))
        
        floor.physicsBody!.isDynamic = false
        
        floor.physicsBody!.categoryBitMask = ColliderType.Peanut.rawValue
        floor.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        floor.physicsBody!.contactTestBitMask = ColliderType.Peanut.rawValue
                
        floor.position = CGPoint(x: self.frame.midX, y: -530)
        
        self.addChild(floor)
        
        // SET UP THE SCORE
        
        highScore = UserDefaults.standard.integer(forKey: "HIGHSCORE")
        
        scoreLabel.fontName = "Helvetica"
        
        scoreLabel.fontSize = 60
        
        scoreLabel.text = "0"
        
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2 - 70)
        
        self.addChild(scoreLabel)
        
        // SET UP THE EDGE -- edge removes baddies when they move off screen
        
        edge.alpha = 0
        
        edge.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 2, height: self.size.height))
        
        edge.physicsBody!.isDynamic = false
        
        edge.physicsBody!.categoryBitMask = ColliderType.Edge.rawValue
        edge.physicsBody!.collisionBitMask = ColliderType.Edge.rawValue
        
        edge.position = CGPoint(x: -435, y: self.frame.midY)
        
        self.addChild(edge)
        
        // SET UP THE GOAL
        
        goal.alpha = 0
        
        goal.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 1, height: self.size.height))
        
        goal.physicsBody!.isDynamic = false
        
        goal.physicsBody!.categoryBitMask = ColliderType.Goal.rawValue
        goal.physicsBody!.collisionBitMask = 0
        goal.physicsBody!.contactTestBitMask = ColliderType.Baddie.rawValue
        
        goal.position = CGPoint(x: -125, y: self.frame.midY)
        
        self.addChild(goal)
        
        // SPAWN BADDIES INFINITELY
        
        let wait = SKAction.wait(forDuration: 3, withRange: 3)
        
        let spawn = SKAction.run {
            self.makeBaddie(at: CGPoint(x: 400, y: -349))
        }
        
        let spawnBaddies = SKAction.sequence([wait, spawn])
        self.run(SKAction.repeatForever(spawnBaddies))
        
    }
    
    func makeBaddie(at position: CGPoint) {
        
        // SET UP BADDIE
        
        var baddie = SKSpriteNode()
        
        let baddieTexture = SKTexture(imageNamed: "vacuumBaddie.png")
        
        baddie = SKSpriteNode(texture: baddieTexture)
        
        baddie.physicsBody = SKPhysicsBody(circleOfRadius: baddieTexture.size().height / 2)
        
        baddie.physicsBody!.isDynamic = true
        baddie.physicsBody!.allowsRotation = false
        baddie.physicsBody!.affectedByGravity = false // this is my hack to have baddies score when they hit the goal but not be stopped by the goal object... turn off gravity, set the y value for makeBaddie at the exact height and set collisionBitMask to 0. There MUST be a better way to do this... 
        
        baddie.physicsBody!.categoryBitMask = ColliderType.Baddie.rawValue
        baddie.physicsBody!.collisionBitMask = 0
        baddie.physicsBody!.contactTestBitMask = ColliderType.Peanut.rawValue
        baddie.physicsBody!.contactTestBitMask = ColliderType.Goal.rawValue
        
        baddie.position = position
        addChild(baddie)
        
        // MOVE BADDIES LEFT
        
        let moveLeft = SKAction.moveBy(x: -800, y:0, duration:6.0) // TRY -- making baddies unaffected by gravity and setting collision bitmask to 0
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
        
        if (firstBody.categoryBitMask == 2 && secondBody.categoryBitMask == 30) {
            // if baddie hit goal
            score += 1
            scoreLabel.text = String(score)
            print("Baddie hit goal")
            //goal.physicsBody!.categoryBitMask = ColliderType.Baddie.rawValue
        } else if (firstBody.categoryBitMask == 2 && secondBody.categoryBitMask == 31) {
            // if baddie hit left wall
            contact.bodyB.node?.removeFromParent()
        } else if (firstBody.categoryBitMask == 1 && secondBody.categoryBitMask == 4) {
            // if peanut hit the floor
            jumpCount = 0
        }
        else if (firstBody.categoryBitMask == 1 && secondBody.categoryBitMask == 2) {
            // if peanut hit a baddie
            self.speed = 0
            
            self.removeAllActions() // NOTE -- this line fixed the bug where baddies spawned faster after restarting the game
            
            gameOver = true
            
            // set high score
            
            gameOverLabel.fontName = "Helvetica"
            highScoreLabel.fontName = "Helvetica"
            
            gameOverLabel.fontSize = 30
            highScoreLabel.fontSize = 30
            
            gameOverLabel.text = "Game Over! Tap to play again."
            
            gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 10)
            highScoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 25)
            
            if score > highScore {
                
                saveHighScore()
                
                highScoreLabel.text = "You set the high score! New high score is \(score)."
            
            } else {
            
            highScoreLabel.text = "High score is \(highScore). Try harder, loser!"
                
            }
            self.addChild(gameOverLabel)
            self.addChild(highScoreLabel)
        }
        
    }
    
    func saveHighScore() {
        UserDefaults.standard.set(score, forKey: "HIGHSCORE")
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
            
            //need to add another line of code to make sure labels are gone?
            
            setupGame()
            
        }
        
    }
    
    // I THINK EVERYTHING BELOW HERE IS TRASHABLE?    
    
    func touchDown(atPoint pos : CGPoint) {
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
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
