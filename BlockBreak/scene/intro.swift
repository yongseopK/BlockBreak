//
//  intro.swift
//  BlockBreak
//
//  Created by yongseopKim on 2022/11/21.
//

import Foundation
import SpriteKit
import AVKit

class intro: SKScene {
    var bgSound: AVAudioPlayer!
    
    override func didMove(to view: SKView) {
        bgm()
        bg()
    }
    
//    백그라운드 이미지
    func bg() {
        let bg = SKSpriteNode(imageNamed: "intro")
        bg.size = view!.frame.size
        bg.zPosition = -1
        bg.position = CGPoint(x: 0, y: 0)
        addChild(bg)
    }
    
//    인트로 배경음악
    func bgm() {
        if let url = Bundle.main.path(forResource: "intro", ofType: "mp3") {
            do {
                bgSound = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: url))
            } catch {
                print("error")
            }
            bgSound.volume = 0.5
            bgSound.numberOfLoops = -1
            bgSound.play()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        bgSound.stop()
        let scene = GameScene(size: view!.frame.size)
        scene.scaleMode = .aspectFill
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        let transition = SKTransition.doorsOpenHorizontal(withDuration: 2)
        view?.presentScene(scene, transition: transition)
    }
}
