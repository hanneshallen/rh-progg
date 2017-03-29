//
//  BugController.swift
//  BouncyBugs
//
//  Created by Hannes Hallén on 2017-03-29.
//  Copyright © 2017 Prograsmus Studios. All rights reserved.
//

import SpriteKit

class BugController {
    
    private let minX: CGFloat = -300.0
    private let maxX: CGFloat = 300.0
    
    func spawnBug() -> SKSpriteNode {
        let item = SKSpriteNode(imageNamed: "Bug")
        
        item.zPosition = 2
        item.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        item.setScale(0.3)
        item.physicsBody = SKPhysicsBody(circleOfRadius: item.size.height / 2)
        item.physicsBody?.isDynamic = true
        item.physicsBody?.velocity = CGVector(dx: 0, dy: -400)
        item.physicsBody?.restitution = 1.0
        item.physicsBody?.friction = 0.0
        item.physicsBody?.linearDamping = 0.0
        item.physicsBody?.mass = 0.0
        item.physicsBody?.charge = 0.0
        item.physicsBody?.density = 0.0
        item.physicsBody?.angularDamping = 0.0
        item.physicsBody?.allowsRotation = false
        item.position.y = 800
        item.position.x = random(between: minX, and: maxX)
        
        return item
    }
    
    
    func random(between first: CGFloat, and second: CGFloat) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(first - second) + min(first, second)
    }
    
}
