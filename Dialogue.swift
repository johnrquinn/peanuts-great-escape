//
//  Dialogue.swift
//  PGE
//
//  Created by John Quinn on 7/4/17.
//  Copyright © 2017 Dilldrup LLC. All rights reserved.
//

import SpriteKit
import GameplayKit

class Dialogue: SKScene, SKPhysicsContactDelegate {
    
    var peanut = SKSpriteNode()
    
    var storyProgress = 0
    
    var line1 = SKLabelNode()
    var line2 = SKLabelNode()
    var line3 = SKLabelNode()
    var line4 = SKLabelNode()
    var line5 = SKLabelNode()
    
    override func didMove(to view: SKView) {
        
        prepDialogue()
        
        setDialogue()
        
    }

    func prepDialogue() {
        
        line1.fontName = "Helvetica"
        line1.fontSize = 35
        
        line2.fontName = "Helvetica"
        line2.fontSize = 35
        
        line3.fontName = "Helvetica"
        line3.fontSize = 35
        
        line4.fontName = "Helvetica"
        line4.fontSize = 35
        
        line5.fontName = "Helvetica"
        line5.fontSize = 35
        
        if storyProgress == 0 {
            line3.text = "this place sux, im outta here"
            storyProgress += 1
        } else if storyProgress == 1 {
            
        } else if storyProgress == 2 {
            
        } else if storyProgress == 3 {
            
        } else if storyProgress == 4 {
            
        }
    }
    
    func setDialogue() {
        
        // SET UP SCENE
        
        let peanutTexture = SKTexture(imageNamed: "peanutSpeaking.png")
        
        peanut = SKSpriteNode(texture: peanutTexture)
        
        peanut.position = CGPoint(x: self.frame.midX - 160, y: self.frame.midY)
        
        self.addChild(peanut)
        
        // ADD SPEECH or THOUGHT BUBBLE
        
        // ADD TEXT LABELS
        
        line1.position = CGPoint(x: self.frame.midX + 140, y: self.frame.midY + 400)
        self.addChild(line1)
        
        line2.position = CGPoint(x: self.frame.midX + 140, y: self.frame.midY + 350)
        self.addChild(line2)
        
        line3.position = CGPoint(x: self.frame.midX + 140, y: self.frame.midY + 300)
        self.addChild(line3)
        
        line4.position = CGPoint(x: self.frame.midX + 140, y: self.frame.midY + 250)
        self.addChild(line4)
        
        line5.position = CGPoint(x: self.frame.midX + 140, y: self.frame.midY + 200)
        self.addChild(line5)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // NEED TO PERMANENTLY REMEMBER storyProgress here?
        
        sendToGame()
        
        }

    func sendToGame() {
    
        self.removeAllActions()
        self.removeAllChildren()
        
        let SceneMove = GameScene(size: self.scene!.size)
        SceneMove.scaleMode = SKSceneScaleMode.aspectFill
        self.scene!.view!.presentScene(SceneMove)
        
        /*
 
        let transition = SKTransition.reveal(with: .down, duration: 0.5)
        
        let nextScene = GameScene(size: scene!.size)
        nextScene.scaleMode = .aspectFill
        
        scene?.view?.presentScene(nextScene, transition: transition)

        */
        
    }

    
}


