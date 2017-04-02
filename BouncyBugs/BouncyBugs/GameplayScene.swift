//
//  GameplayScene.swift
//  BouncyBugs
//
//  Created by Hannes Hallén on 2017-03-29.
//  Copyright © 2017 Prograsmus Studios. All rights reserved.
//

import GameplayKit
import SpriteKit
import UIKit


class GameplayScene: SKScene, SKPhysicsContactDelegate {
    
    
    
    var bugcatcher = SKShapeNode()
    
    //HANNES TRAMSKOD FÖR MASSA SKIT
    private var bugController: BugController!
    var splinePoints = [CGPoint]()
    var line: SKShapeNode?
    
    override func didMove(to view: SKView) {
        
        
        self.physicsWorld.contactDelegate = self
        
        //Tramshannes
        bugController = BugController()
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(spawnBug), userInfo: nil, repeats: true)
        
        
        //rasmus coola bugcatcherrektangel
        bugcatcher = self.childNode(withName: "bugcatcher") as! SKShapeNode
        bugcatcher.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: bugcatcher.frame.size.width, height: bugcatcher.frame.size.height))
        bugcatcher.physicsBody?.isDynamic = false
        
        bugcatcher.physicsBody?.contactTestBitMask = 2
        
        
        
        //Border
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        splinePoints.removeAll()
        self.line?.removeFromParent()
        splinePoints.append((touches.first?.location(in: self))!)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        splinePoints.append((touches.first?.location(in: self))!)
        let ground = SKShapeNode(splinePoints: &splinePoints,
                                 count: splinePoints.count)
        ground.lineWidth = 5
        ground.physicsBody = SKPhysicsBody(edgeChainFrom: ground.path!)
        ground.physicsBody?.restitution = 1.0
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.friction = 0.0
        ground.physicsBody?.linearDamping = 0.0
        ground.physicsBody?.mass = 0.0
        ground.physicsBody?.density = 0.0
        ground.physicsBody?.angularDamping = 0.0
        ground.physicsBody?.allowsRotation = false
        
        line?.removeFromParent()
        line = ground
        self.scene?.addChild(ground)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        splinePoints.removeAll()
        self.line?.removeFromParent()
    }
    
    
    //COLLISIONMUS
    func didBegin(_ contact: SKPhysicsContact) {
        
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if contact.bodyA.node?.name == "bugcatcher" {
            secondBody = contact.bodyB
            secondBody.node?.removeFromParent()
            print("call")
        } else {
            firstBody.node?.removeFromParent()
        }
    }
    
    
    func spawnBug() {
        self.scene?.addChild(bugController.spawnBug())
        print("spawn")
    }
    
    
    
}
