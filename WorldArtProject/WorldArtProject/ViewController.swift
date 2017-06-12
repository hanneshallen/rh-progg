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
    var currentState: Int = 0
    
    var newImageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    
    var states = ["panState", "drawState", "textState"]
    let panImage = UIImage(named: "move.png")
    let drawImage = UIImage(named: "edit-2.png")
    let textImage = UIImage(named: "type.png")
    var imageState: [UIImage] = []
    var rightSwipe: UIScreenEdgePanGestureRecognizer!
    var leftSwipe: UIScreenEdgePanGestureRecognizer!
    
    var currentTextField: UITextField?
    
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
        
        imageState = [panImage!, drawImage!, textImage!]
        
        
        leftSwipe = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(didSwipeLeft(_:)))
        leftSwipe.edges = .left
        leftSwipe.cancelsTouchesInView = true
        self.view.addGestureRecognizer(leftSwipe)
        
        rightSwipe = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(didSwipeRight(_:)))
        rightSwipe.edges = .right
        rightSwipe.cancelsTouchesInView = true
        self.view.addGestureRecognizer(rightSwipe)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTap(_:)))
        
        
        view.addGestureRecognizer(tap)
        
        
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
    
    
    
    
    
    //VISA BILD PÅ SWIPE
    func didSwipeLeft(_ rec: UISwipeGestureRecognizer) {
        if rec.state == UIGestureRecognizerState.ended {
            currentState = (currentState + 1) % states.count
            displayStateImage(indexNumber: currentState)
            print(currentState)
            print(states[currentState])
        }
    }
    
    func didSwipeRight(_ rec: UISwipeGestureRecognizer) {
        if rec.state == UIGestureRecognizerState.ended {
            currentState = (currentState + 2) % states.count
            displayStateImage(indexNumber: currentState)
            print(currentState)
            print(states[currentState])
        }
    }
    
    func displayStateImage (indexNumber: Int) {
        let centerX = self.view.center.x - newImageView.frame.size.width/2
        let centerY = self.view.center.y - newImageView.frame.size.height/2
        
        newImageView.frame = CGRect(x: centerX, y: centerY, width: 100, height: 100)
        newImageView.image = imageState[indexNumber]
        newImageView.alpha = 1
        newImageView.backgroundColor = UIColor.lightGray
        newImageView.backgroundColor?.withAlphaComponent(0.2)
        newImageView.layer.cornerRadius = 10
        self.view.addSubview(newImageView)
        UIView.animate(withDuration: 1.0, animations: {
            self.newImageView.alpha = 0
        })
        
    }
    
    //SLUT VISA BILD SWIPE
    
    
    
    
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
    
    
    func didTap(_ sender: UITapGestureRecognizer) {
        
        if let currentTextField = currentTextField {
            currentTextField.resignFirstResponder()
            print("HANNES")
            self.currentTextField = nil
            return
        }
        
        let touchPoint = sender.location(in: self.view)
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let widthThing = screenWidth - touchPoint.x
        print ("RASMUS")
        let x_loc = touchPoint.x
        let y_loc = touchPoint.y
        let label = UITextField(frame: CGRect(x: x_loc, y: y_loc, width: widthThing, height: 21))
        label.minimumFontSize = 10
        label.adjustsFontSizeToFitWidth = false
        label.autocapitalizationType = .allCharacters
        
        currentTextField = label
        
        self.view.addSubview(label)
        
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
 //       context?.setFillColor(colors[colorIndex].cgColor)
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

    private func textLetter(startPoint: CGPoint) {
        
    }
}

