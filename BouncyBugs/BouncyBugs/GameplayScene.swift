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
    var activeDrawingLine: SKShapeNode?
    
    override func didMove(to view: SKView) {
        
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.speed = 1.0
        
        //Tramshannes
        bugController = BugController()
        
        // Set timeer to spawn new bugs
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(spawnBug), userInfo: nil, repeats: true)
        // Set timeer to remove old bugs
        Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(removeBugs), userInfo: nil, repeats: true)
        
        
        //rasmus coola bugcatcherrektangel
        bugcatcher = self.childNode(withName: "bugcatcher") as! SKShapeNode
        bugcatcher.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: bugcatcher.frame.size.width, height: bugcatcher.frame.size.height))
        bugcatcher.physicsBody?.isDynamic = false
        
        bugcatcher.physicsBody?.contactTestBitMask = 2
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        view.addGestureRecognizer(tapGesture)
        
        //Border
        
    }
    
    func didTap(_ rec: UITapGestureRecognizer) {
        let viewTouchLocation = rec.location(in: self.view)
        guard let sceneTouchPoint = scene?.convertPoint(fromView: viewTouchLocation),
            let touchedNode = scene?.atPoint(sceneTouchPoint),
            touchedNode.name == "Line" else { return }
        touchedNode.removeFromParent()
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
        newLine.physicsBody?.restitution = 1.0
        newLine.physicsBody?.isDynamic = false
        newLine.physicsBody?.friction = 0.0
        newLine.physicsBody?.linearDamping = 0.0
        newLine.physicsBody?.mass = 0.0
        newLine.physicsBody?.density = 0.0
        newLine.physicsBody?.angularDamping = 0.0
        newLine.physicsBody?.allowsRotation = false
        newLine.name = "Line"
    
        activeDrawingLine?.removeFromParent()
        activeDrawingLine = newLine
        scene?.addChild(newLine)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        applyFadeOutAction(onLine: activeDrawingLine)
        activeDrawingLine = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        applyFadeOutAction(onLine: activeDrawingLine)
        activeDrawingLine = nil
    }
    
    // MARK: - Physics Contact Delegate
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if contact.bodyA.node?.name == "bugcatcher" {
            secondBody = contact.bodyB
            secondBody.node?.removeFromParent()
            print("call")
        } else {
            firstBody.node?.removeFromParent()
        }
    }
    
    // MARK: - Private Funtions
    
    
    func spawnBug() {
        self.scene?.addChild(bugController.spawnBug())
        print("spawn")
    }
    
    func applyFadeOutAction(onLine line: SKShapeNode?) {
        line?.run(
            SKAction.sequence([
                SKAction.wait(forDuration: (1.0)),
                SKAction.fadeAlpha(to: 0, duration: 0.3),
                SKAction.removeFromParent()
                ])
        )
    }
    
    func removeBugs() {
        for child in children {
            if let name = child.name, name.lowercased().contains("_bug") {
                if child.position.y < scene!.frame.height - 100 {
                    child.removeFromParent()
                }
            }
        }
    }
    
    
}
