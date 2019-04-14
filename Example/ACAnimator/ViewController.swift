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

class ViewController: UIViewController {

    var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = UIScrollView(frame: CGRect(origin: .zero, size: UIScreen.main.bounds.size))
        view.addSubview(scrollView)
        
        setupMovementSection()
        setupTypewriterSection()
        setupTransformationsSection()
        
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

    }
    
    private func setupTransformationsSection() {
        addHeaderLabel(with: "Transformations")

    }
    
    private func addHeaderLabel(with text: String) {
        let label = UILabel(frame: CGRect(x: 20, y: scrollView.contentReach + 60, width: 300, height: 40))
        label.font = UIFont.boldSystemFont(ofSize: 40)
        scrollView.addSubview(label)
        label.text = text
    }
}

