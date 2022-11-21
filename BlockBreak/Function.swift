//
//  Function.swift
//  BlockBreak
//
//  Created by yongseopKim on 2022/11/15.
//

import Foundation
import SpriteKit
import AVKit

extension GameScene {
    
    func setting() {
        
        let stageName = "Stage\(Variables.stageNum)"
        stage = (NSClassFromString("BlockBreak.\(stageName)") as! Stages.Type ).init()
        stage?.bg()
        stage?.blocks()
        
//        tiliting()
        bgm()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let node: SKNode = self.atPoint(location)
            if Variables.isPlayed {
                Variables.paddle.run(SKAction.moveTo(x: location.x, duration: 0.2))
            } else {
                Variables.paddle.run(SKAction.moveTo(x: location.x, duration: 0.2))
                Variables.ball.run(SKAction.moveTo(x: location.x, duration: 0.2))
            }
            
            if node.name == "restart" {
                restart()
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
            gameOver()
            firstBody.node?.run(SKAction.playSoundFileNamed("gameOver.wav", waitForCompletion: false))
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
                //다음 스테이지 이동
                nextStage()
            }
        }
        if firstBody.categoryBitMask == Variables.ballCategory && secondBody.categoryBitMask == Variables.paddleCategory {
            print("hit the paddle")
            firstBody.node?.run(SKAction.playSoundFileNamed("paddle.wav", waitForCompletion: false))
        }
    }
    
    //다음 스테이지 이동
    func nextStage() {
        let view = Variables.scene.view!
        //공 제거
        Variables.ball.removeFromParent()
        let clearText = SKLabelNode()
        clearText.fontName = "Courier-Bold"
        clearText.fontSize = 50
        clearText.text = "STAGE CLEAR!!"
        clearText.position = CGPoint(x: 0, y: 0)
        clearText.color = .white
        clearText.zPosition = 3
        clearText.alpha = 0
        Variables.scene.addChild(clearText)
        
        let action = SKAction.fadeIn(withDuration: 0.5)
        let action1 = SKAction.wait(forDuration: 1)
        let action2 = SKAction.scale(by: 1.5, duration: 0.5)
        let action3 = SKAction.fadeOut(withDuration: 0.5)
        let sequence = SKAction.sequence([action, action1, action2, action3])
        clearText.run(sequence) {
            Variables.stageNum += 1
            Variables.isPlayed = false
            Variables.scene.removeAllChildren()
            
            //모든 스테이지 클리어 시 처음하면으로
            if Variables.stageNum == 6 {
                Variables.stageNum = 1
            }
            
            let scene = GameScene(size: view.frame.size)
            scene.scaleMode = .aspectFill
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            let transition = SKTransition.moveIn(with: .right, duration: 0.5)
            view.presentScene(scene, transition: transition)
        }
    }
    
    //공이 바닥에 닿았을 때
    func gameOver() {
        let view = Variables.scene.view!
        let bg = SKSpriteNode()
        bg.color = .black
        bg.alpha = 0.8
        bg.zPosition = 10
        bg.name = "gameoverBG"
        bg.position = CGPoint(x: 0, y: 0)
        bg.size = view.frame.size
        Variables.scene.addChild(bg)
        
        let gameOverText = SKLabelNode()
        gameOverText.fontName = "Courier-Bold"
        gameOverText.fontSize = 100
        gameOverText.text = "GAME OVER"
        gameOverText.position = CGPoint(x: 0, y: 0)
        gameOverText.color = .white
        gameOverText.zPosition = 11
        gameOverText.alpha = 0
        
        bg.addChild(gameOverText)
        
        let btn = SKSpriteNode()
        btn.size = CGSize(width: 150, height: 50)
        btn.texture = SKTexture(imageNamed: "restart_btn")
        btn.position = CGPoint(x: 0, y: -80)
        btn.zPosition = 11
        btn.name = "restart"
        bg.addChild(btn)
        
        let action = SKAction.fadeIn(withDuration: 0.1)
        gameOverText.run(action) {
            view.isPaused = true
        }
    }
    
    func restart() {
        if let bg = Variables.scene.childNode(withName: "gameoverBG") {
            bg.removeFromParent()
            Variables.isPlayed = false
            Variables.scene.view?.isPaused = false
            Variables.ball.position = CGPoint(x: Variables.paddle.position.x, y: Variables.paddle.position.y + 30)
            Variables.ball.physicsBody?.isDynamic = false
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
    
    //BGM
    func bgm() {
        if let url = Bundle.main.path(forResource: "bgm", ofType: "mp3") {
            do {
                bgSound = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: url))
            } catch {
                print("error to load bgm.mp3")
            }
            bgSound.volume = 0.5
            bgSound.numberOfLoops = -1
            bgSound.play()
        }
    }
    
    func shadowAnim(point: CGPoint) {
        let anim = SKShapeNode(circleOfRadius: 3)
        anim.strokeColor = .cyan
        anim.fillColor = .green
        anim.blendMode = .screen
        anim.glowWidth = 10
        anim.name = "animNode"
        anim.position = point
        Variables.scene.addChild(anim)
        
        let action = SKAction.wait(forDuration: 0.1)
        let action1 = SKAction.fadeOut(withDuration: 0.3)
        let action2 = SKAction.removeFromParent()
        let sequence = SKAction.sequence([action, action1, action2])
        
        anim.run(sequence) {
            anim.removeAllActions()
            anim.removeFromParent()
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        let ballPosition = Variables.ball.position
        shadowAnim(point: ballPosition)
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
}
