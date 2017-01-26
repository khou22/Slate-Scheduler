//
//  OnboardingPageThree.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/23/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import UIKit

class OnboardingPageThree: UIViewController {
    
    // UI Elements
    @IBOutlet weak var summaryCard: UIImageView! // Main event summary card image
    var summaryCardBottom: UIImageView = UIImageView() // Bottom summary card (rotated right)
    var summaryCardTop: UIImageView = UIImageView() // Top summary card (rotated left)
    
    override func viewDidLoad() {
        onboardingBackground() // Setup background gradient
        setupSummaryCards() // Create the other two summary cards
    }
    
    func setupSummaryCards() {
        // Copy and create summary cards from original
        self.summaryCardBottom = UIImageView(frame: self.summaryCard.frame) // Bottom summary card
        self.summaryCardBottom.image = self.summaryCard.image // Add image
        self.summaryCardBottom.transform = CGAffineTransform(rotationAngle: CGFloat(Angles.radians(10.0))) // Rotate left
        
        self.summaryCardTop = UIImageView(frame: self.summaryCard.frame) // Top summary card
        self.summaryCardTop.image = self.summaryCard.image // Add image
        self.summaryCardTop.transform = CGAffineTransform(rotationAngle: CGFloat(Angles.radians(-10.0))) // Rotate right
        
        view.insertSubview(self.summaryCardBottom, belowSubview: self.summaryCard) // Insert below original
        view.insertSubview(self.summaryCardTop, aboveSubview: self.summaryCard) // Insert above original
    }
}
