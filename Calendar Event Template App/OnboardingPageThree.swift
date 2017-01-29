//
//  OnboardingPageFour.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/28/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import UIKit

struct PageThreeData {
    @available(iOS 10.0, *)
    static var scrollingAnimations: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 2.0, timingParameters: UISpringTimingParameters(mass: 2.5, stiffness: 70, damping: 55, initialVelocity: CGVector(dx: 0, dy: 0)))
}

class OnboardingPageThree: UIViewController {
    
    @IBOutlet weak var globeImage: UIImageView!
    @IBOutlet weak var mapPinBottomConstraint: NSLayoutConstraint!
    var originalMapPinBottomConstraintConst: CGFloat = -26.0
    
    override func viewDidLoad() {
        onboardingBackground() // Setup background gradient
        self.initializeScrollAnimations() // Initialize scrolling animations
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ScrollData.setCurrentPage(index: 3)
    }
    
    override func viewDidLayoutSubviews() {
        self.entranceAnimations() // Start animations before screen appears
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.resetAnimations() // Reset scrolling animations
    }
    
    func prepareEntranceAnimations() {
        self.originalMapPinBottomConstraintConst = self.mapPinBottomConstraint.constant // Store
    }
    
    func entranceAnimations() {
        self.prepareEntranceAnimations() // Prepare animations
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 2.0, options: [.autoreverse, .repeat, .curveEaseInOut], animations: {
            self.mapPinBottomConstraint.constant = -12.0 // Move upwards
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    // Function called when user is scrolling
    func updateScrollPercentage() {
        let percentage = CGFloat(ScrollData.value)
        
        // Update animation percentage complete
        if #available(iOS 10.0, *) {
            PageThreeData.scrollingAnimations.fractionComplete = percentage * 0.95
        }
    }
    
    func initializeScrollAnimations() {
        if #available(iOS 10.0, *) {
            PageThreeData.scrollingAnimations.addAnimations({
                // Rotate globe
                self.globeImage.transform = CGAffineTransform(rotationAngle: CGFloat(Angles.radians(-120)))
            })
        } else {
            // Fallback on earlier versions
        }
    }
    
    func resetAnimations() {
        self.globeImage.transform = .identity // Reset animations
    }
}
