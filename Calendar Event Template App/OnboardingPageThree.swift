//
//  OnboardingPageFour.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/28/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import UIKit

class OnboardingPageThree: UIViewController {
    
    @IBOutlet weak var mapPinBottomConstraint: NSLayoutConstraint!
    var originalMapPinBottomConstraintConst: CGFloat = -26.0
    
    override func viewDidLoad() {
        onboardingBackground() // Setup background gradient
    }
    
    override func viewDidLayoutSubviews() {
        self.entranceAnimations() // Start animations before screen appears
    }
    
    func prepareEntranceAnimations() {
        self.originalMapPinBottomConstraintConst = self.mapPinBottomConstraint.constant // Store
    }
    
    func entranceAnimations() {
        self.prepareEntranceAnimations() // Prepare animations
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 2.0, options: [.autoreverse, .repeat, .curveEaseIn], animations: {
            self.mapPinBottomConstraint.constant = -12.0 // Move upwards
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
