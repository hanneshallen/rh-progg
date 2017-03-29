//
//  GameplayScene.swift
//  BouncyBugs
//
//  Created by Hannes Hallén on 2017-03-29.
//  Copyright © 2017 Prograsmus Studios. All rights reserved.
//

import SpriteKit

class GameplayScene: SKScene {

    private var bugController: BugController!
    var splinePoints = [CGPoint]()
    var line: SKShapeNode?
    
    override func didMove(to view: SKView) {
        bugController = BugController()
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(spawnBug), userInfo: nil, repeats: true)
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
        ground.physicsBody?.restitution = 0.75
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.restitution = 1.0
        ground.physicsBody?.friction = 0.0
        
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

    
    
    func spawnBug() {
        self.scene?.addChild(bugController.spawnBug())
    }
    
}
