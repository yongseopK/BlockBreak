//
//  Function.swift
//  BlockBreak
//
//  Created by yongseopKim on 2022/11/15.
//

import Foundation
import SpriteKit

extension GameScene {
    
    func setting() {
        let stage = Stages()
//        tiliting()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if Variables.isPlayed {
                Variables.paddle.run(SKAction.moveTo(x: location.x, duration: 0.2))
            } else {
                Variables.ball.run(SKAction.moveTo(x: location.x, duration: 0.2))
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if Variables.isPlayed {
                Variables.paddle.run(SKAction.moveTo(x: location.x, duration: 0.2))
            } else {
                Variables.paddle.run(SKAction.moveTo(x: location.x, duration: 0.2))
                Variables.ball.run(SKAction.moveTo(x: location.x, duration: 0.2))
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let node: SKNode = self.atPoint(location)
            if node.name == "paddle" {
                if !Variables.isPlayed {
                    Variables.isPlayed = true
                    Variables.ball.physicsBody?.isDynamic = true
                    Variables.ball.physicsBody?.applyImpulse(CGVector(dx: 10, dy: 10))
                }
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == Variables.ballCategory && secondBody.categoryBitMask == Variables.bottomCategory {
            print("Game Over")
        }
        if firstBody.categoryBitMask == Variables.ballCategory && secondBody.categoryBitMask == Variables.blockCategory {
            
            //효과음
            let num: String = String(secondBody.node!.name!.last!)
            let soundName = "sound\(num).wav"
            firstBody.node!.run(SKAction.playSoundFileNamed(soundName, waitForCompletion: false))
            
            //블럭제거 효과
            emitter(blockName: secondBody.node!.name!, point: secondBody.node!.position)
            
            //블럭 제거
            secondBody.node?.removeFromParent()
            
            //블럭 제거 사운드
            Variables.blockNum -= 1
            
            if Variables.blockNum == 0 {
                //게임 클리어
                print("게임 클리어")
                //다음 스테이지 이동
            }
        }
        if firstBody.categoryBitMask == Variables.ballCategory && secondBody.categoryBitMask == Variables.paddleCategory {
            print("hit the paddle")
            firstBody.node?.run(SKAction.playSoundFileNamed("paddle.wav", waitForCompletion: false))
        }
    }
    
    //블럭 제거 효과
    func emitter(blockName: String, point: CGPoint) {
        let emit = SKEmitterNode(fileNamed: "Explosion.sks")
        emit?.particleTexture = SKTexture(imageNamed: blockName)
        emit?.position = point
        emit?.zPosition = 2
        Variables.scene.addChild(emit!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            emit?.removeFromParent()
            emit?.removeAllActions()
        }
    }
    
    //기기 기울기로 패들 움직이기
    func tiliting() {
        motion.accelerometerUpdateInterval = 0.1
        motion.startAccelerometerUpdates(to: .main) { (data, error) in
            let value = data!.acceleration.y * 1000
            print("data \(value)")
            Variables.paddle.run(SKAction.moveTo(x: CGFloat(value), duration: 0.2))
        }
    }
}//
