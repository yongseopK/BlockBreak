//
//  GameScene.swift
//  BlockBreak
//
//  Created by yongseopKim on 2022/11/15.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let motion = CMMotionManager()
    
    override func didMove(to view: SKView) {
        Variables.scene = self
        self.physicsWorld.contactDelegate = self
        setting()
    }
    
}
