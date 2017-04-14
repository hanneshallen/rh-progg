//
//  GameScene.swift
//  Railybugs
//
//  Created by Rasmus on 2017-04-06.
//  Copyright © 2017 Rasmus. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var splinePoints = [CGPoint]()
    var activeDrawingLine: SKShapeNode?
    
    var background = SKSpriteNode(imageNamed: "background.png")
    var bugHole = SKSpriteNode(imageNamed: "bughole.png")
    private var bugControl = BugControl()
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        setUpGame()
        
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(GameScene.spawnBugs), userInfo: nil, repeats: true)

    }
    
    
    func setUpGame() {
        
        //BAKGRUND
        background.size.height = self.frame.height
        background.size.width = self.frame.width
        background.zPosition = 0
        self.addChild(background)
        
        
        //BUGHOLE
        bugHole.zPosition = 2
        bugHole.name = "bughole"
        bugHole.size = CGSize(width: 100, height: 100)
        
        bugHole.physicsBody = SKPhysicsBody(circleOfRadius: 40)
        bugHole.physicsBody?.contactTestBitMask = 2
        bugHole.physicsBody?.isDynamic = false
        self.addChild(bugHole)
    }
    
    func spawnBugs() {
        self.scene?.addChild(bugControl.spawnBug())
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        splinePoints.removeAll()
        guard let touch = touches.first else { return }
        splinePoints.append(touch.location(in: self))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        if let lastPoint = splinePoints.last,
            point.distance(toPoint: lastPoint) < 25 {
            return
        }
        splinePoints.append(point)
        let newLine = SKShapeNode(points: &splinePoints, count: splinePoints.count)
        newLine.lineWidth = 5
        newLine.physicsBody = SKPhysicsBody(edgeChainFrom: newLine.path!)
        newLine.name = "Line"
        newLine.zPosition = 2
        newLine.strokeColor = .black
        activeDrawingLine?.removeFromParent()
        activeDrawingLine = newLine
        scene?.addChild(newLine)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "bluebug" && contact.bodyB.node?.name == "bughole" {
            contact.bodyA.node?.removeFromParent()
        } else if contact.bodyA.node?.name == "bughole" && contact.bodyB.node?.name == "bluebug" {
            contact.bodyB.node?.removeFromParent()
        }
    }
}




