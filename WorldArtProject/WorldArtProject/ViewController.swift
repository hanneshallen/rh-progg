//
//  ViewController.swift
//  WorldArtProject
//
//  Created by Hannes Hallén on 2017-05-09.
//  Copyright © 2017 Prograsmus Studios. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!

    var width: CGFloat!
    var previousPixel: (x: Int, y: Int)?
    var colorIndex: Int = 0
    var colors: [UIColor] = [.black, .white, .red, .green, .blue]
    var rightSwipe: UIScreenEdgePanGestureRecognizer!
    var leftSwipe: UIScreenEdgePanGestureRecognizer!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        computePixelSize()
        leftSwipe = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(didSwipeLeft(_:)))
        leftSwipe.edges = .left
        leftSwipe.cancelsTouchesInView = true
        self.view.addGestureRecognizer(leftSwipe)
        rightSwipe = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(didSwipeRight(_:)))
        rightSwipe.edges = .right
        rightSwipe.cancelsTouchesInView = true
        self.view.addGestureRecognizer(rightSwipe)
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
        let lastPoint = touch.location(in: self.imageView)
        drawPixel(atPoint: lastPoint)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
//        leftSwipe.isEnabled = false
//        rightSwipe.isEnabled = false
        let lastPoint = touch.location(in: self.imageView)
        drawPixel(atPoint: lastPoint)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        leftSwipe.isEnabled = true
//        rightSwipe.isEnabled = true
        previousPixel = nil
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

