//
//  OnboardingPageOne.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/22/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import UIKit

class OnboardingPageOne: UIViewController {
    
    override func viewDidLoad() {
        onboardingBackground() // Setup background gradient
        
        let doubleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.skipOnboarding)) // Initalize and set handler
        doubleTap.numberOfTapsRequired = 2 // Double tap
        view.addGestureRecognizer(doubleTap) // Add to view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ScrollData.setCurrentPage(index: 1)
    }
    
    // Segue past onboarding
    func skipOnboarding() {
        print("Skipping onboarding via segue")
        self.performSegue(withIdentifier: SegueIdentifiers.skipOnboarding, sender: self)
    }
    
    func updateScrollPercentage() {
        let percentage = CGFloat(ScrollData.value)
//        print("Page one registered scroll percentage: \(percentage)")
    }
    
}
