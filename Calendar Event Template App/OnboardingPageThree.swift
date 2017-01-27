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
    
    override func viewWillAppear(_ animated: Bool) {
        ScrollData.setCurrentPage(index: 3)
    }
    
    func updateScrollPercentage() {
        let percentage = CGFloat(ScrollData.value)
//        print("Page three registered scroll percentage: \(percentage)")
    }
    
    func setupSummaryCards() {
        // Copy and create summary cards from original
        self.summaryCardBottom = UIImageView(frame: self.summaryCard.frame.applying(CGAffineTransform(translationX: -10.0, y: 34.0))) // Bottom summary card with transform
        self.summaryCardBottom.image = self.summaryCard.image // Add image
        let transformBottom: CGAffineTransform = CGAffineTransform(rotationAngle: CGFloat(Angles.radians(12.0))) // Rotate rights
        transformBottom.translatedBy(x: -2.0, y: -10.0) // Shift left and down
        self.summaryCardBottom.transform = transformBottom // Apply transformation
        
        self.summaryCardTop = UIImageView(frame: self.summaryCard.frame.applying(CGAffineTransform(translationX: 3.0, y: -45.0))) // Top summary card with transform
        self.summaryCardTop.image = self.summaryCard.image // Add image
        let transformTop: CGAffineTransform = CGAffineTransform(rotationAngle: CGFloat(Angles.radians(-12.0))) // Rotate left
        transformTop.translatedBy(x: 2.0, y: 50.0) // Shift right and up
        self.summaryCardTop.transform = transformTop // Apply transformation
        
        view.insertSubview(self.summaryCardBottom, belowSubview: self.summaryCard) // Insert below original
        view.insertSubview(self.summaryCardTop, aboveSubview: self.summaryCard) // Insert above original
    }
    
    @IBAction func getStarted(_ sender: Any) {
        self.performSegue(withIdentifier: SegueIdentifiers.completeOnboarding, sender: self)
    }
}
