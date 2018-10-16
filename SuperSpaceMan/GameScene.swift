//
//  GameScene.swift
//  SuperSpaceMan
//
//  Created by apple on 2018/9/18.
//  Copyright © 2018年 15132809. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene {
    
    
    
    let backgroundNode = SKSpriteNode(imageNamed: "Background")
    let foregroundNode = SKSpriteNode()
    let playerNode1 = SKSpriteNode(imageNamed: "Player")
    
    
    let CollisionCategoryPlayer : UInt32 = 0x1 << 1
    let CollisionCategoryPowerUpOrbs : UInt32 = 0x1 << 2
    
    let coreMotionManager = CMMotionManager()
    
    var impulseCount = 4
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
        
        backgroundColor = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        
        isUserInteractionEnabled = true
        
        
        // adding the background
        backgroundNode.size.width = frame.size.width
        backgroundNode.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        backgroundNode.position = CGPoint(x: size.width / 2.0, y: 0.0)
        addChild(backgroundNode)
        addChild(foregroundNode)
        
        // add the player
        playerNode1.physicsBody = SKPhysicsBody(circleOfRadius: playerNode1.size.width / 2)
        playerNode1.physicsBody?.isDynamic = false
        
        playerNode1.position = CGPoint(x: size.width / 2.0 , y: 180.0)
        playerNode1.physicsBody?.linearDamping = 1.0
        playerNode1.physicsBody?.allowsRotation = false
        playerNode1.physicsBody?.categoryBitMask = CollisionCategoryPlayer
        playerNode1.physicsBody?.contactTestBitMask = CollisionCategoryPowerUpOrbs
        playerNode1.physicsBody?.collisionBitMask = 0
        foregroundNode.addChild(playerNode1)
        

        
        var orbNodePosition = CGPoint(x: playerNode1.position.x, y: playerNode1.position.y + 100)
        
        for _ in 0...19 {
            let orbNode = SKSpriteNode(imageNamed: "PowerUp")
            
                    orbNodePosition.y += 140
                    orbNode.position = orbNodePosition
                    orbNode.physicsBody = SKPhysicsBody(circleOfRadius: orbNode.size.width / 2.0)
                    orbNode.physicsBody?.isDynamic = false
            
                    orbNode.physicsBody?.categoryBitMask = CollisionCategoryPowerUpOrbs
                    orbNode.physicsBody?.collisionBitMask = 0
                    orbNode.name = "POWER_UP_ORB"
                    foregroundNode.addChild(orbNode)
            
            
        }
        
        orbNodePosition = CGPoint(x: playerNode1.position.x + 50, y: orbNodePosition.y)
        for _ in 0...19 {
            let orbNode = SKSpriteNode(imageNamed: "PowerUp")
            orbNodePosition.y += 140
            orbNode.position = orbNodePosition
            orbNode.physicsBody = SKPhysicsBody(circleOfRadius: orbNode.size.width / 2)
            orbNode.physicsBody?.isDynamic = false
            orbNode.physicsBody?.categoryBitMask = CollisionCategoryPowerUpOrbs
            orbNode.physicsBody?.collisionBitMask = 0
            orbNode.name = "POWER_UP_ORB"
            foregroundNode.addChild(orbNode)
        }
        
       // let playerNode2 = SKSpriteNode(imageNamed: "Player")
        //playerNode2.position = CGPoint(x: size.width / 2.0, y: 100.0)
        //addChild(playerNode2)
        
        //let playerNode3 = SKSpriteNode(imageNamed: "Player")
       // playerNode3.position = CGPoint(x: size.width / 2.0, y: 120.0)
        //addChild(playerNode3)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !playerNode1.physicsBody!.isDynamic {
            playerNode1.physicsBody?.isDynamic = true
            
            coreMotionManager.accelerometerUpdateInterval = 0.3
            coreMotionManager.startAccelerometerUpdates()
        }
        
        if impulseCount > 0 {
            
        playerNode1.physicsBody?.applyImpulse(CGVector(dx: 0.00, dy: 40.0))
        impulseCount -= 1
    }
    }
    
    override func update(_ currentTime: TimeInterval){
        
        if playerNode1.position.y >= 180.0 {
            backgroundNode.position = CGPoint(x: backgroundNode.position.x, y: -((playerNode1.position.y - 180.0)/8))
            
            foregroundNode.position = CGPoint(x: foregroundNode.position.x, y: -(playerNode1.position.y - 180.0))
        }}
    
    override func didSimulatePhysics() {
        if let accelerometerData = coreMotionManager.accelerometerData {
            
            playerNode1.physicsBody!.velocity = CGVector(dx: CGFloat(accelerometerData.acceleration.x * 380.0), dy: playerNode1.physicsBody!.velocity.dy)
        }
        
        if playerNode1.position.x < -(playerNode1.size.width / 2){
            
            playerNode1.position = CGPoint(x: size.width - playerNode1.size.width / 2, y: playerNode1.position.y)
        }
        else if playerNode1.position.x > self.size.width {
            playerNode1.position = CGPoint(x: playerNode1.size.width / 2, y: playerNode1.position.y)
        }
        
        
    }
    deinit {
        coreMotionManager.stopAccelerometerUpdates()
    }
    
}
    extension GameScene: SKPhysicsContactDelegate {
        
        func didBegin(_ contact: SKPhysicsContact){
            let nodeB = contact.bodyB.node!
            
            if nodeB.name == "POWER_UP_ORB" {
                nodeB.removeFromParent()
            }
            
            
            
        }
        
      
    }
    
    

