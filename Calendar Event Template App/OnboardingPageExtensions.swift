//
//  OnboardingPageExtensions.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/26/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//
//  Functions that need to be used in all onboarding view controllers

import UIKit

extension UIViewController {
    
    func onboardingBackground() {
        let backgroundView = UIView(frame: self.view.bounds) // Background view
        
        let gradient = CAGradientLayer()
        gradient.colors = [Colors.white.withAlphaComponent(0.4).cgColor, Colors.red.withAlphaComponent(0.4).cgColor] // [top, bottom]
        gradient.locations = [0.4, 1.0] // Locations of the colors
        gradient.frame = self.view.bounds // Fill entire
        
        backgroundView.backgroundColor = Colors.white
        
        backgroundView.layer.insertSublayer(gradient, at: 1) // Insert gradient layer
        
        view.insertSubview(backgroundView, at: 0) // Add to view in the back
    }
}
