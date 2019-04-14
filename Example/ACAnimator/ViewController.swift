//
//  ViewController.swift
//  ACAnimator
//
//  Created by acotilla91 on 04/13/2019.
//  Copyright (c) 2019 acotilla91. All rights reserved.
//

import UIKit

import ACAnimator

extension UIScrollView {
    var contentReach: CGFloat {
        let elements = subviews.sorted { $0.frame.maxY < $1.frame.maxY }
        return elements.last?.frame.maxY ?? 0
    }
}

// From https://stackoverflow.com/a/10681299/1792699
class TopAlignedLabel: UILabel {
    override func drawText(in rect:CGRect) {
        guard let labelText = text else {  return super.drawText(in: rect) }
        
        let attributedText = NSAttributedString(string: labelText, attributes: [NSAttributedString.Key.font: font!])
        var newRect = rect
        newRect.size.height = attributedText.boundingRect(with: rect.size, options: .usesLineFragmentOrigin, context: nil).size.height
        
        if numberOfLines != 0 {
            newRect.size.height = min(newRect.size.height, CGFloat(numberOfLines) * font.lineHeight)
        }
        
        super.drawText(in: newRect)
    }
}

class ViewController: UIViewController {

    var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = UIScrollView(frame: CGRect(origin: .zero, size: UIScreen.main.bounds.size))
        view.addSubview(scrollView)
        
        setupMovementSection()
        setupTypewriterSection()
        setupTransformationSection()
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: scrollView.contentReach + 30)
    }
    
    private func setupMovementSection() {
        addHeaderLabel(with: "Movement")
        
        let box = UIView(frame: CGRect(x: 0, y: scrollView.contentReach + 30, width: 40, height: 40))
        box.backgroundColor = .red
        scrollView.addSubview(box)
        
        // Determine the target value
        let targetX = UIScreen.main.bounds.width - box.frame.width
        
        // Prepare and run the animation
        let animator = ACAnimator(duration: 3.0, easeFunction: .bounceOut, options: [.repeat, .autoreverse], animation: { (fraction, _, _) in
            // Calculate the proper value for the current "frame"
            let newValue = targetX * CGFloat(fraction)

            // Apply the new value
            box.transform = CGAffineTransform(translationX: newValue, y: 0)
        })
        animator.start()
    }
    
    private func setupTypewriterSection() {
        addHeaderLabel(with: "Typewriter")

        let paragraph = "ACAnimator lets you animate almost anything on iOS or tvOS (including non-animatable properties). Can also be used to \"animate\" logical changes not just visual (e.g. fade in/out audio). It supports over 30 different easing functions and it uses CADisplayLink for optimal performance."
        
        let label = TopAlignedLabel(frame: CGRect(x: 20, y: scrollView.contentReach + 30, width: scrollView.frame.width - 20, height: 0))
        scrollView.addSubview(label)
        label.numberOfLines = 0
        label.text = paragraph
        label.sizeToFit()
        label.text = ""
        
        let animator = ACAnimator(duration: 20, easeFunction: .linear, options: [.repeat, .autoreverse], animation: { (fraction, _, _) in
            // Calculate the proper value for the current "frame"
            let newValue = paragraph.prefix(Int(Double(paragraph.count) * fraction))
            
            // Apply the new value
            label.text = String(newValue)
        })
        animator.start()
    }
    
    private func setupTransformationSection() {
        addHeaderLabel(with: "Transformation")

        let size = CGSize(width: 250, height: 160)
        let origin = CGPoint(x: scrollView.frame.width/2 - size.width/2, y: scrollView.contentReach + 30)
        let box = UIView(frame: CGRect(origin: origin, size: size))
        scrollView.addSubview(box)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.blue.cgColor
        box.layer.addSublayer(shapeLayer)
        
        // Determine the target value
        let targetCurvature = 1.0
        
        let animator = ACAnimator(duration: 3.0, easeFunction: .elasticIn(magnitude: nil), options: [.repeat, .autoreverse], animation: { (fraction, _, _) in
            // Calculate the proper value for the current "frame"
            let newValue = targetCurvature * fraction
            
            // Apply the new value
            shapeLayer.path = self.bottomCurvedPath(for: box.frame.size, curvature: CGFloat(newValue)).cgPath
        })
        animator.start()
    }
    
    private func addHeaderLabel(with text: String) {
        let label = UILabel(frame: CGRect(x: 20, y: scrollView.contentReach + 60, width: 300, height: 40))
        label.font = UIFont.boldSystemFont(ofSize: 40)
        scrollView.addSubview(label)
        label.text = text
    }
    
    private func bottomCurvedPath(for size: CGSize, curvature: CGFloat) -> UIBezierPath {
        let bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let w = bounds.size.width
        let h = bounds.size.height
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: w, y: 0))
        path.addLine(to: CGPoint(x: w, y: h - (h * curvature)))
        
        // Draw quadratic curve.
        // Calculate the control point based on the 3 points that the curve must pass through.
        // Based on: https://stackoverflow.com/a/38753266/1792699
        func controlPoint(_ leftPoint: CGPoint, _ rightPoint: CGPoint, _ middlePoint: CGPoint) -> CGPoint {
            let x = 2 * middlePoint.x - leftPoint.x / 2 - rightPoint.x / 2
            let y = 2 * middlePoint.y - leftPoint.y / 2 - rightPoint.y / 2
            return CGPoint(x: x, y: y)
        }
        
        let leftPoint = CGPoint(x: 0, y: h - (h * curvature))
        let middlePoint = CGPoint(x: w / 2, y: h)
        let rightPoint = CGPoint(x: w, y: h - (h * curvature))
        
        path.addQuadCurve(to: leftPoint, controlPoint: controlPoint(leftPoint, rightPoint, middlePoint))
        
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.close()
        
        return path
    }
}

