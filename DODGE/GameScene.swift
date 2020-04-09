//
//  GameScene.swift
//  DODGE
//
//  Created by Filippos Taprantzis on 06/06/2017.
//  Copyright © 2017 Filippos Taprantzis. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var beginGame = false
    var endGame = false
    var square = SKSpriteNode()
    var square_ = SKSpriteNode()
    var background = SKSpriteNode()
    
    var light = SKLightNode()
    var mainLight = SKLightNode()

    var remover = SKSpriteNode()
    var fan = SKSpriteNode()
    var musicSwitch = SKSpriteNode()
    var creditsSwitch = SKSpriteNode()

    var musicON = true

    var remover2 = SKSpriteNode()
    var remover3 = SKSpriteNode()
    var remover4 = SKSpriteNode()
    var digitalizer = SKSpriteNode()
    
    let defaults = UserDefaults.standard
    
    
    var ground = SKSpriteNode()
    var label = SKLabelNode()
    var best = SKLabelNode()

    var touchTo = SKLabelNode()
    var player: AVAudioPlayer?
    var player2: AVAudioPlayer?
    var player_pause: AVAudioPlayer?
    var volume = 1

    var score = 0
    var bestScore = 7549
    var dead = false
    
    var touching = false
    var goToRight = false
    var goToLeft = false
    
    override func didMove(to view: SKView) {
        
        //setup world
        
        
        physicsWorld.gravity.dy = -15
        physicsWorld.contactDelegate = self
        
        //setup nodes
        
        
        
        square = (self.childNode(withName: "square") as? SKSpriteNode)!
        fan = (self.square.childNode(withName: "fan") as? SKSpriteNode)!

        remover = (self.childNode(withName: "remover") as? SKSpriteNode)!
        remover2 = (self.childNode(withName: "remover2") as? SKSpriteNode)!
        remover3 = (self.childNode(withName: "remover3") as? SKSpriteNode)!
        remover4 = (self.childNode(withName: "remover4") as? SKSpriteNode)!
        musicSwitch = (self.childNode(withName: "musicSwitch") as? SKSpriteNode)!
        creditsSwitch = (self.childNode(withName: "credits") as? SKSpriteNode)!

        square_ = (self.childNode(withName: "square_") as? SKSpriteNode)!
        digitalizer = (self.childNode(withName: "digitalizerMove") as? SKSpriteNode)!

        
        ground = (self.childNode(withName: "ground") as? SKSpriteNode)!
        label = (self.childNode(withName: "label") as? SKLabelNode)!
        best = (self.childNode(withName: "best") as? SKLabelNode)!
        
        
        touchTo = (self.childNode(withName: "touchTo") as? SKLabelNode)!

//        background = (self.childNode(withName: "background") as? SKSpriteNode)!
                
//        light = (self.childNode(withName: "light") as? SKLightNode)!
//        mainLight = (self.childNode(withName: "mainLight") as? SKLightNode)!

        ground.physicsBody?.usesPreciseCollisionDetection = true
        
        touchTo.run(SKAction.repeatForever(SKAction.sequence([SKAction.fadeOut(withDuration: 0.6), SKAction.fadeIn(withDuration: 0.2)])))
        fan.run(SKAction.repeatForever(SKAction.rotate(byAngle: 5, duration: 0.1)))

        playSound()
        
        if defaults.integer(forKey: "best") < 10 {
            best.text = "BEST: 0000\(defaults.integer(forKey: "best"))"
            
        } else if defaults.integer(forKey: "best") < 100 {
            best.text = "BEST: 000\(defaults.integer(forKey: "best"))"
            
        } else if defaults.integer(forKey: "best") < 1000 {
            best.text = "BEST: 00\(defaults.integer(forKey: "best"))"
            
        } else if defaults.integer(forKey: "best") < 10000{
            best.text = "BEST: 0\(defaults.integer(forKey: "best"))"
        } else {
            best.text = "BEST: \(defaults.integer(forKey: "best"))"
            
        }
        
//        let moveEmitter = SKEmitterNode(fileNamed: "moveParticle.sks")
//        moveEmitter?.zPosition = -10
//        moveEmitter?.zPosition = 1000
//        square.addChild(moveEmitter!)
//        moveEmitter?.position = CGPoint(x: 0, y: -40)
        
        
        }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        let touch = touches.first!
        let location = touch.location(in: self)
        let node : SKNode = self.atPoint(location)
        
        if node.name == "musicSwitch" {
            
            if musicON {
                
                player?.volume = 0
                player_pause?.volume = 0
            
                musicSwitch.texture = SKTexture(imageNamed: "red.sound")
                musicON = false
                
                
                
            } else {
                
                player?.volume = 1
                player_pause?.volume = 1

                musicSwitch.texture = SKTexture(imageNamed: "green.sound")
                musicON = true
            }
  
        }
        
        else {
        
        if !beginGame  {
            
            beginGame = true
            beginGameFunc()
            
        }

            
            
        
        if node.name == "digitalizerMove" {
            
                if location.x > frame.midX {
                    
                    goToRight = true
                    goToLeft = false

                    }
                    
                else if location.x < frame.midX {
                    
                    goToRight = false
                    goToLeft = true
                    
                }
            }
            
            
        
        touching = true
        
        if endGame{
            
            musicSwitch.run(SKAction.moveTo(x: frame.maxX + 130, duration: 0.3))

            beginGame = true
            endGame = false
            
            player?.rate = 1.0
            
            player?.volume = 0.3

            
            dead = false
            
            player?.currentTime = 2
            
        
            removeAllChildren()
            
            addChild(ground)
            addChild(label)
            addChild(square)
            addChild(square_)
//            addChild(light)
            addChild(background)
            addChild(remover)
            addChild(remover2)
            addChild(remover3)
            addChild(remover4)
            addChild(touchTo)
            addChild(best)
//            addChild(mainLight)
            
            addChild(musicSwitch)
            addChild(digitalizer)

            fan.run(SKAction.repeatForever(SKAction.rotate(byAngle: 5, duration: 0.1)))

            
            
            touchTo.removeAllActions()
            touchTo.run(SKAction.fadeOut(withDuration: 0.2))
            
            
            if defaults.integer(forKey: "best") < 10 {
                best.text = "BEST: 0000\(defaults.integer(forKey: "best"))"
                
            } else if defaults.integer(forKey: "best") < 100 {
                best.text = "BEST: 000\(defaults.integer(forKey: "best"))"
                
            } else if defaults.integer(forKey: "best") < 1000 {
                best.text = "BEST: 00\(defaults.integer(forKey: "best"))"
                
            } else if defaults.integer(forKey: "best") < 10000{
                best.text = "BEST: 0\(defaults.integer(forKey: "best"))"
            } else {
                best.text = "BEST: \(defaults.integer(forKey: "best"))"
                
            }


//            let moveEmitter = SKEmitterNode(fileNamed: "moveParticle.sks")
//            moveEmitter?.zPosition = -10
//            moveEmitter?.zPosition = 1000
//            square.addChild(moveEmitter!)
//            moveEmitter?.position = CGPoint(x: 0, y: -40)
            
            square.position.x = frame.midX
            square.position.y = frame.maxY + 10
            
            physicsWorld.gravity.dy = -15
            physicsWorld.contactDelegate = self
            
            score = 0

            physicsWorld.speed = 1
            
            square.zRotation = 0
            
            square.physicsBody?.angularVelocity = 0
            square.physicsBody?.pinned = true
            
//            secondLabel.text =  "\("BEST: \(self.bestScore - self.score)")"

            square.removeAllActions()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
                
                self.square.physicsBody?.pinned = false

            }
            
            
            self.run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 2),SKAction.run(self.drop)
                ])))
            
            self.run(SKAction.repeatForever(SKAction.sequence([SKAction.run(self.scoreFunc), SKAction.wait(forDuration: 0.1
                )])))

            
            
            
            }
        
        }
        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        touching = false
        
        goToLeft = false
        goToRight = false
        
        //add joystick mechanic to shoot projectiles
        
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        if !musicON{
            player?.volume = 0
        }
        
        // Called before each frame is rendered
    
        light.position = square.position
        
            
        
        if beginGame {
            
            if score < 10 {
                label.text = "0000\(score)"

            } else if score < 100 {
                label.text = "000\(score)"

            } else if score < 1000 {
                label.text = "00\(score)"

            } else if score < 10000{
                label.text = "0\(score)"
            } else {
                label.text = "\(score)"

            }
            
//            secondLabel.text =  "\("BEST: \(self.bestScore - self.score)")"
        }
        if beginGame && goToRight && touching && !goToLeft  {
            square.physicsBody?.applyForce(CGVector(dx: 800, dy: 0))
        } else if beginGame && !goToRight && touching  && goToLeft {
            square.physicsBody?.applyForce(CGVector(dx: -800, dy: 0))
        }
        
        if beginGame && square.position.y < ground.position.y && !dead{
            restart()
            shatter(object: square, final: true)
            dead = true
        }
        
    
        
    }
    
    func beginGameFunc() {
        
        beginGame = true

        //ground.run(SKAction.resize(toWidth: frame.size.width-70, duration: 0.3))
        
        touchTo.removeAllActions()
        
        
        label.run(SKAction.move(to: (CGPoint(x: frame.midX - 140 , y: frame.maxY - 100)), duration: 0.2))
        label.run(SKAction.scale(by: 0.5, duration: 0.2))
        
        musicSwitch.run(SKAction.moveTo(x: frame.maxX + 130, duration: 0.3))
        
        
        
        touchTo.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.1), SKAction.fadeIn(withDuration: 0.2),SKAction.run( {self.touchTo.text = "DODGE!"}), SKAction.fadeOut(withDuration: 0.6)]))
        
        
        self.run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 2),SKAction.run(self.drop)
            ])))
        
        self.run(SKAction.repeatForever(SKAction.sequence([SKAction.run(self.scoreFunc), SKAction.wait(forDuration: 0.1
            )])))

        
        label.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.1), SKAction.run( {self.label.text = "\(self.score)"
        }), SKAction.fadeIn(withDuration: 0.2)]))
        
        
//        secondLabel.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.1), SKAction.run( {self.secondLabel.text = "\(" BEST : \(self.bestScore - self.score)")"
//        }), SKAction.fadeIn(withDuration: 0.2)]))
        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        
        let bodyA = contact.bodyA.node?.name
        let bodyB = contact.bodyB.node?.name
        if (bodyA == "square" && bodyB == "missle")  || (bodyB == "square" && bodyA == "missle") {
            

            shatter(object: contact.bodyA.node as! SKSpriteNode, final: true)
            shatter(object: contact.bodyB.node as! SKSpriteNode, final: true)
            restart()

        } else if (bodyA == "square" && bodyB == "TNT")  || (bodyB == "square" && bodyA == "TNT"){
            
            shatter(object: contact.bodyA.node as! SKSpriteNode, final: true)
            shatter(object: contact.bodyB.node as! SKSpriteNode, final: true)
            restart()
            
        } else if (bodyA == "ground" && bodyB == "missle")  || (bodyB == "ground" && bodyA == "missle"){
            
            if contact.bodyA.node?.name == "missle" {
                
                shatter(object: contact.bodyA.node as! SKSpriteNode, final: false)

            } else {
                
                shatter(object: contact.bodyB.node as! SKSpriteNode, final: false)
                
            }
        }
        
            else if (bodyA == "block" && bodyB == "TNT")  || (bodyB == "block" && bodyA == "TNT"){
                
                shatter(object: contact.bodyA.node as! SKSpriteNode, final: false)
                shatter(object: contact.bodyB.node as! SKSpriteNode, final: false)
            }
            
            else if (bodyA == "block" && bodyB == "missle")  || (bodyB == "block" && bodyA == "missle"){
                
                shatter(object: contact.bodyA.node as! SKSpriteNode, final: false)
                shatter(object: contact.bodyB.node as! SKSpriteNode, final: false)
            }
            
            else if (bodyA == "missle" && bodyB == "TNT")  || (bodyB == "missle" && bodyA == "TNT"){
                
                shatter(object: contact.bodyA.node as! SKSpriteNode, final: false)
                shatter(object: contact.bodyB.node as! SKSpriteNode, final: false)
            }
        
            else if (bodyA == "remover" || bodyB == "remover"){
                
            if contact.bodyA.node?.name == "remover"{
                
                contact.bodyB.node?.removeFromParent()
                
            } else {
                
                contact.bodyA.node?.removeFromParent()

            }
        }
        
    }
    
    func shatter(object: SKSpriteNode, final: Bool) {
        
            let generator = UIImpactFeedbackGenerator(style: .light)

            let explosions: [SKSpriteNode] = [SKSpriteNode(), SKSpriteNode(), SKSpriteNode(), SKSpriteNode(), SKSpriteNode(),SKSpriteNode(), SKSpriteNode(), SKSpriteNode(), SKSpriteNode()]
        
        
            for explosion in explosions {
                generator.impactOccurred()
                explosion.size = CGSize(width: 15, height: 15)
                explosion.position = CGPoint(x: object.position.x, y: object.position.y)
                explosion.color = object.color
                explosion.shadowCastBitMask = 1
                explosion.lightingBitMask = 1
                explosion.physicsBody = SKPhysicsBody(rectangleOf: (explosion.size))
                addChild(explosion)

                explosion.physicsBody?.applyImpulse(CGVector(dx: randRange(lower: -10, upper: 10), dy: randRange(lower: -8, upper: 11)))
                
//                if !final {
//                    
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                    explosion.removeFromParent()
//                        
//                    object.removeFromParent()
//                    
//                        
//                    }
//                }
//                    
//        }
//        
        }
        
        object.removeFromParent()
    
    }
    
    func randRange (lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    
    func drop(){
        
        let object = square_.copy() as! SKSpriteNode
        
        
        object.zRotation = 0
        object.alpha = 0.7
        
        object.physicsBody?.angularVelocity = 0
        object.physicsBody?.pinned = true
        
        object.removeAllActions()
        
        object.position.y = frame.maxY + 150
        object.position.x = square.position.x
        

        switch randRange(lower: 1, upper: 3) {
            
        case 1:
            
            //missle
        
            object.size = CGSize(width: 15, height: 70)
            object.color = .red
            object.name = "missle"
            
////
//            object.texture = SKTexture(imageNamed: "missle")
//
//            let jetFire = SKEmitterNode(fileNamed: "jet_fire.sks")
////          jetFire?.position.y = object.position.y - 20
//            jetFire?.zPosition = -10
            object.zPosition = 1000
//            object.addChild(jetFire!)
            

            
        case 2:
            //block

            object.size = CGSize(width: 80, height: 80)
            object.color = .gray

            object.name = "block"
            
//            object.texture = SKTexture(imageNamed: "block")
            
          
            
        case 3:
            //TNT
            
            object.size = CGSize(width: 80, height: 80)
            object.name = "TNT"
            object.color = .red
//            object.texture = SKTexture(imageNamed: "TNT2")

//          objecttexture = SKTexture(imageNamed: "TNT")
        
    
        default:
            break
        }
        
//        object.texture = texture
        
//        object.physicsBody = SKPhysicsBody(rectangleOf: object.size)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {

        object.physicsBody?.pinned = false
            
        self.scene?.addChild(object)


        }
    }
    
    func restart(){
        
        touchTo.text = "TOUCH TO RESTART"
        
        if score > defaults.integer(forKey: "best"){
            best.text = "NEW HIGHSCORE!"

            defaults.set(score, forKey: "best")
        }
        

        touchTo.run(SKAction.repeatForever(SKAction.sequence([SKAction.fadeOut(withDuration: 0.6), SKAction.fadeIn(withDuration: 0.2)])))
        
        musicSwitch.run(SKAction.moveTo(x: frame.maxX - 80, duration: 0.3))

        endGame = true
        
        playSound2()
        
        player?.volume = 0.5
        player?.rate = 0.7
        

//        player_pause?.play(atTime: (player?.currentTime)!)

        
        physicsWorld.speed = 0.3
        
        removeAllActions()
        
    }
    
    func playSound(){
        
        if musicON {
            
            let path = Bundle.main.path(forResource: "ver2", ofType:"m4a")!
            let url = URL(fileURLWithPath: path)
            
            do {
                
                let sound = try AVAudioPlayer(contentsOf: url)
                
                self.player = sound
                sound.numberOfLoops = -1
                player?.enableRate = true

                sound.prepareToPlay()
                sound.play()


            } catch {
                
                print("error loading file")
                
            }
            
        }
    }
    
    func playSound2(){
        
        if musicON {
        
            let path = Bundle.main.path(forResource: "dead", ofType:"wav")!
            let url = URL(fileURLWithPath: path)
            
            do {
                
                let sound = try AVAudioPlayer(contentsOf: url)
                
                self.player2 = sound
                player2?.enableRate = true
                sound.prepareToPlay()
                sound.play()
                
                
            } catch {
                
                print("error loading file")
            }
        }
        
    }
    
    func playSoundPause(){
        
        if musicON {
            let path = Bundle.main.path(forResource: "ver2", ofType:"m4a")!
            let url = URL(fileURLWithPath: path)
            
            do {
                
                let sound = try AVAudioPlayer(contentsOf: url)
                self.player_pause = sound
                sound.prepareToPlay()
                sound.numberOfLoops = -1
                sound.play()
                sound.play(atTime: (player?.currentTime)!)
                sound.volume = 1
                player?.stop()
                
            } catch {
                
                print("error loading file")
            }
        }
    }

    
    func scoreFunc() {

        score += 1
        
    }
    

}
