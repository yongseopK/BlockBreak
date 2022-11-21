//
//  Stage2.swift
//  BlockBreak
//
//  Created by yongseopKim on 2022/11/21.
//

import Foundation
import SpriteKit

class Stage2: Stages {
    override func bg() {
        Variables.scene.physicsWorld.speed = 0.5
        let bg = SKSpriteNode()
        bg.texture = SKTexture(imageNamed: "bg2")
        bg.size = view.frame.size
        bg.position = CGPoint(x: 0, y: 0)
        bg.zPosition = -1
        Variables.scene.addChild(bg)

    }
    
    override func blocks() {
        let col = 10
        let row = 4
        let gab = 30
        let block_w = Int(view.frame.width) / col
        let block_h = Int(block_w / 2) + gab
        let startX = Int(-view.frame.width / 2) + (block_w + gab)
        let startY = Int(view.frame.height / 2) - (block_h / 2)
        
        for i in 0..<col {
            for j in 0..<row {
                let block = SKSpriteNode()
                block.size = CGSize(width: block_w, height: block_h)
                let xValue = (block_w - gab / 2) * i
                let yValue = (block_h - gab) * j
                block.position = CGPoint(x: startX + xValue, y: startY - yValue)
                let num = Int.random(in: 1...8)
                block.texture = SKTexture(imageNamed: "block\(num)")
                block.zPosition = 1
                block.name = "block\(num)"
                Variables.scene.addChild(block)
                Variables.blockNum += 1
                block.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: block_w, height: block_h - (gab / 2)))
                block.physicsBody?.isDynamic = false
                block.physicsBody?.affectedByGravity = false
                block.physicsBody?.allowsRotation = false
                block.physicsBody?.categoryBitMask = Variables.blockCategory
                block.physicsBody?.contactTestBitMask = Variables.ballCategory
            }
        }
    }
}
