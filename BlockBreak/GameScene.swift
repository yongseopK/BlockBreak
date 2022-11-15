//
//  GameScene.swift
//  BlockBreak
//
//  Created by yongseopKim on 2022/11/15.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    

    
    override func didMove(to view: SKView) {
        Variables.scene = self
        setting()
    }
    
}
