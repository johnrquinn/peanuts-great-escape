//
//  Dialogue.swift
//  PGE
//
//  Created by John Quinn on 7/4/17.
//  Copyright © 2017 Dilldrup LLC. All rights reserved.
//

import Foundation
import GameplayKit

class Dialogue: SKScene, SKPhysicsContactDelegate {

    var peanut = SKSpriteNode()
    
    let peanutTexture = SKTexture(imageNamed: "peanutSpeaking.png")
    
    override func didMove(to view: SKView) {
        
        peanut = SKSpriteNode(texture: peanutTexture)
        
        peanut.position = CGPoint(x: self.frame.midX, y: -300)
        
        self.addChild(peanut)
        
    }
    
}

