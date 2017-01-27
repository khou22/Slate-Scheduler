//
//  OnboardingPageTwo.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/23/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import UIKit

class OnboardingPageTwo: UIViewController {
    
    override func viewDidLoad() {
        onboardingBackground() // Setup background gradient
        print("Onboarding page two loaded")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ScrollData.setCurrentPage(index: 2)
    }
    
    func updateScrollPercentage() {
        let percentage = CGFloat(ScrollData.value)
//        print("Page two registered scroll percentage: \(percentage)")
    }
}
