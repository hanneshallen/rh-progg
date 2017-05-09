//
//  GameScene.swift
//  TouchTris
//
//  Created by Hannes Hallén on 2017-04-23.
//  Copyright © 2017 Prograsmus Studios. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreGraphics

class GameScene: SKScene {
    
    var currentScore = 0
    let numberColumns = 6
    let numberRows = 3
    let patternDrawMatrix = [[0,0,0],[0,0,0]]
    
    
    override func didMove(to view: SKView) {
        
        //Små rutor heter gameSquare, stora rutor heter drawSquare, dödslinjen heter deathLine
        
        makeDrawZone(numRow: numberRows, numCol: numberColumns)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        view.addGestureRecognizer(tap)
       
        }
    

    override func update(_ currentTime: TimeInterval) {
        
    }
    
    func patternDetection(touchLocation: CGPoint) {
        
    }
    
    func didTap(_ rec: UITapGestureRecognizer) {
        
        let touchLocation = rec.location(in: self.view)
        
        patternDetection(touchLocation: touchLocation)
        
        let sceneTouchPoint = scene?.convertPoint(fromView: touchLocation)
        let touchedNode: SKShapeNode = (scene?.atPoint(sceneTouchPoint!) as! SKShapeNode?)!
        
        guard touchedNode.fillColor != UIColor.black else {
            return
        }
        let touchedNodeName: String = touchedNode.name!
        switch touchedNodeName {
        case "drawSquare":
            if touchedNode.fillColor == UIColor.yellow {
                touchedNode.fillColor = UIColor.black
            } else {
            touchedNode.fillColor = UIColor.yellow
            }
        case "gameSquare":
            if touchedNode.fillColor == UIColor.green {
                touchedNode.fillColor = UIColor.black
            } else {
                touchedNode.fillColor = UIColor.green
            }
        default:
            print("nothing")
        }
    }
    
    func scoreCount () {
        currentScore += 1
    }
    
    func makeDrawZone(numRow: Int, numCol: Int) {
        
        let zoneWidth = (UIScreen.main.bounds.width * 2 ) / 3
        let zoneHeight = (UIScreen.main.bounds.height * 2 ) / 6
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        let screenWidth = screenSize.width
        
        backgroundColor = UIColor.black
        
        for j in 0...1 {
            let scaleHeight = CGFloat(j)
            for i in 0...numRow {
                let scaleConst = CGFloat(i)

                let newRect = CGRect(x: -screenWidth + (scaleConst * zoneWidth) , y: -screenHeight+(scaleHeight * zoneHeight), width: 2*screenWidth/3, height: 2 * screenHeight/6)
                let drawSquare = SKShapeNode(rect: newRect)
                
                
                drawSquare.lineWidth = 1
                drawSquare.strokeColor = UIColor.white
                drawSquare.fillColor = UIColor.black
                drawSquare.name = "drawSquare"
                scene?.addChild(drawSquare)
            }
        }
        for k in 2...numCol*2 {
            let scaleHeight = CGFloat(k)
            for l in 0...numRow*2 {
                let scaleConst = CGFloat(l)
                    
                let newRect = CGRect(x: -screenWidth + (scaleConst * zoneWidth)/2 , y: -screenHeight + zoneHeight + (scaleHeight * zoneHeight)/2, width: screenWidth/3, height: screenHeight/6)
                let gameSquare = SKShapeNode(rect: newRect)
                
                gameSquare.lineWidth = 1
                gameSquare.strokeColor = UIColor.white
                gameSquare.fillColor = UIColor.black
                gameSquare.name = "gameSquare"
                scene?.addChild(gameSquare)
                }
            }
        
        let startPoint = CGPoint(x: -screenWidth, y: -screenHeight + 2*zoneHeight)
        let deathRect = CGRect(x: startPoint.x, y: startPoint.y, width: screenWidth*2, height: 2)
        let deathLine = SKShapeNode(rect: deathRect)
        deathLine.fillColor = UIColor.red
        deathLine.name = "deathLine"
        scene?.addChild(deathLine)
    }
}
