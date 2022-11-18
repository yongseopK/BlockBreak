//
//  Variables.swift
//  BlockBreak
//
//  Created by yongseopKim on 2022/11/15.
//

import Foundation
import SpriteKit

struct Variables {
    static var scene = SKScene()
    static var paddle = SKSpriteNode()
    static var ball = SKShapeNode(circleOfRadius: 10)
    
    static let ballCategory: UInt32 = 0x1 << 0      //00000001
    static let paddleCategory: UInt32 = 0x1 << 1    //00000010
    static let bottomCategory: UInt32 = 0x1 << 2    //00000100
    static let blockCategory: UInt32 = 0x1 << 3     //00001000
    
    static var blockNum = 0
    static var isPlayed = false
    static var stageNum = 1
}
