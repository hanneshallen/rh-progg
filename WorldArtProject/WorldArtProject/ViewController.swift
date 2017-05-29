//
//  ViewController.swift
//  WorldArtProject
//
//  Created by Hannes Hallén on 2017-05-09.
//  Copyright © 2017 Prograsmus Studios. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!

    var width: CGFloat!
    var previousPixel: (x: Int, y: Int)?
    var colorIndex: Int = 0
    var colors: [UIColor] = [.black, .white, .red, .green, .blue]
    var rightSwipe: UIScreenEdgePanGestureRecognizer!
    var leftSwipe: UIScreenEdgePanGestureRecognizer!
    
    
    // NEW
    var previousPoint: CGPoint?
    var currentLine = [CGPoint]()
    var firebaseDbRef: DatabaseReference!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        computePixelSize()
        leftSwipe = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(didSwipeLeft(_:)))
        leftSwipe.edges = .left
        leftSwipe.cancelsTouchesInView = true
//        self.view.addGestureRecognizer(leftSwipe)
        rightSwipe = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(didSwipeRight(_:)))
        rightSwipe.edges = .right
        rightSwipe.cancelsTouchesInView = true
//        self.view.addGestureRecognizer(rightSwipe)
        
        
        firebaseDbRef = Database.database().reference()
        
        firebaseDbRef.child("drawing").child("rhdev").observe(.childAdded, with: { (snapshot) -> Void in
            
            print("Child added \(snapshot.childrenCount)")
            
            var pointline = [CGPoint]()
            
            for point in snapshot.children {
                
                if let pointSnap = point as? DataSnapshot,
                    let pointJson = pointSnap.value as? [String: Any],
                    let x = pointJson["x"],
                    let y = pointJson["y"] {
                    
                    pointline.append(CGPoint(x: x as! CGFloat, y: y as! CGFloat))
                }
            }
            self.drawLine(between: pointline)

            
//            for child in snapshot.childSnapshot(forPath: "rhdev").children {
//
//                if let line = child as? DataSnapshot {
//
//                    print(line.childrenCount)
//
//                    var pointline = [CGPoint]()
//                    
//                    for point in line.children {
//                        
//                        if let pointSnap = point as? DataSnapshot,
//                            let pointJson = pointSnap.value as? [String: Any],
//                            let x = pointJson["x"],
//                            let y = pointJson["y"] {
//                            
//                            pointline.append(CGPoint(x: x as! CGFloat, y: y as! CGFloat))
//                        }
//                    }
//                    for i in 1..<pointline.count {
//                        self.drawLine(from: pointline[i - 1], to: pointline[i])
//                    }
//                }
            
//                var points = [CGPoint]()
//                for point in (child as AnyObject).children {
//                    points.append(CGPoint(x: point("x"), y: point("y"))
//                }
//            }
            
        })
    }
    
    override func viewDidLayoutSubviews() {
        computePixelSize()
    }
    
    func didSwipeLeft(_ rec: UISwipeGestureRecognizer) {
        switch rec.state {
        case .began:
            colorIndex = (colorIndex + 1) % colors.count
        default:
            break
        }
    }
    
    func didSwipeRight(_ rec: UISwipeGestureRecognizer) {
        switch rec.state {
        case .began:
            let newIndex = colorIndex - 1
            colorIndex = newIndex >= 0 ? newIndex : colors.count - 1
        default:
            break
        }
    }

    private func computePixelSize() {
        width = imageView.frame.width / 20.0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        previousPoint = touch.location(in: self.imageView)
        currentLine.append(previousPoint!)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first,
            let previousPoint = previousPoint else { return }
//        leftSwipe.isEnabled = false
//        rightSwipe.isEnabled = false
        let point = touch.location(in: self.imageView)
        drawLine(from: previousPoint, to: point)
        currentLine.append(point)
        self.previousPoint = point
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        leftSwipe.isEnabled = true
//        rightSwipe.isEnabled = true
        
        
        
        firebaseDbRef.child("drawing").child("rhdev").childByAutoId().setValue(currentLine.map({ ["x": $0.x, "y": $0.y] }))
        currentLine.removeAll()
        previousPoint = nil
    }
    
    
    private func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, 0)
        
        imageView.image?.draw(in: imageView.bounds)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.move(to: fromPoint)
        context?.addLine(to: toPoint)
        
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(1.0)
        context?.setStrokeColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        context?.setBlendMode(CGBlendMode.normal)
        context?.strokePath()
        
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        imageView.alpha = 1.0
        UIGraphicsEndImageContext()
    }

    private func drawLine(between points: [CGPoint]) {
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, 0)
        
        imageView.image?.draw(in: imageView.bounds)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.addLines(between: points)
        
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(1.0)
        context?.setStrokeColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        context?.setBlendMode(CGBlendMode.normal)
        context?.strokePath()
        
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        imageView.alpha = 1.0
        UIGraphicsEndImageContext()
    }

    
    private func drawPixel(atPoint point: CGPoint) {
        let touchedPixel = pixel(forPoint: point)
        if let previousPixel = previousPixel,
            touchedPixel == previousPixel {
            return
        }
        let touchedRect = rect(forPixel: touchedPixel)
        UIGraphicsBeginImageContext(self.imageView.frame.size)
        imageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.imageView.frame.width, height: self.imageView.frame.height))
        let context = UIGraphicsGetCurrentContext()
        context?.addRect(touchedRect)
        context?.setBlendMode(CGBlendMode.normal)
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(1)
        context?.setFillColor(colors[colorIndex].cgColor)
        context?.fillPath()
        
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        previousPixel = touchedPixel
    }
    
    private func pixel(forPoint point: CGPoint) -> (Int, Int) {
        let x = Int(point.x) / Int(width)
        let y = Int(point.y) / Int(width)
        return (x, y)
    }
    
    private func rect(forPixel pixel: (x: Int, y: Int)) -> CGRect {
        return CGRect(x: pixel.x * Int(width), y: pixel.y * Int(width), width: Int(width), height: Int(width))
    }


}

