//
//  OnboardingPageOne.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/22/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import UIKit

struct PageOneData {
    @available(iOS 10.0, *)
    static var scrollingAnimations: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 2.0, timingParameters: UISpringTimingParameters(mass: 2.5, stiffness: 70, damping: 55, initialVelocity: CGVector(dx: 0, dy: 0)))
}

class OnboardingPageOne: UIViewController {
    
    // Calendar client icons
    @IBOutlet weak var outlookIcon: UIImageView!
    @IBOutlet weak var yahooIcon: UIImageView!
    @IBOutlet weak var iOSCalendarIcon: UIImageView!
    @IBOutlet weak var iCloudIcon: UIImageView!
    @IBOutlet weak var googleCalendarIcon: UIImageView!
    
    // UI Elements
    @IBOutlet weak var calendarImage: UIImageView!
    
    // Animation options
    var entranceDistance: CGFloat = 100.0
    
    override func viewDidLoad() {
        onboardingBackground() // Setup background gradient
        
        self.styleIcons() // Add styling to the icons
        self.initializeScrollAnimations() // Initialize interactive scrolling animations
        
        // Prepare entrance animations
        self.calendarImage.alpha = 0.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ScrollData.setCurrentPage(index: 1)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.entranceAnimations() // Start entrance animations
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.resetAnimations()
    }
    
    func updateScrollPercentage() {
        let percentage = CGFloat(ScrollData.value)
//        print("Page one registered scroll percentage: \(percentage)")
        
        // Update animation percentage complete
        if #available(iOS 10.0, *) {
            PageOneData.scrollingAnimations.fractionComplete = percentage * 0.95
        }
    }
    
    func initializeScrollAnimations() {
        if #available(iOS 10.0, *) {
            PageOneData.scrollingAnimations.addAnimations({
                // Icon translations
                self.outlookIcon.transform = CGAffineTransform(translationX: -350, y: 0)
                self.iOSCalendarIcon.transform = CGAffineTransform(translationX: -850, y: 0)
                self.yahooIcon.transform = CGAffineTransform(translationX: -450, y: 0)
                self.iCloudIcon.transform = CGAffineTransform(translationX: -250, y: 0)
                self.googleCalendarIcon.transform = CGAffineTransform(translationX: -600, y: 0)
            })
        } else {
            // Fallback on earlier versions
        }
    }
    
    func resetAnimations() {
        self.resetIcon(icon: self.outlookIcon)
        self.resetIcon(icon: self.yahooIcon)
        self.resetIcon(icon: self.iOSCalendarIcon)
        self.resetIcon(icon: self.iCloudIcon)
        self.resetIcon(icon: self.googleCalendarIcon)
    }
    
    func entranceAnimations() {
        // Move all icons off screen
        self.setupIconForEntrance(icon: self.outlookIcon, xDisplacement: self.entranceDistance)
        self.setupIconForEntrance(icon: self.yahooIcon, xDisplacement: -self.entranceDistance)
        self.setupIconForEntrance(icon: self.iOSCalendarIcon, xDisplacement: self.entranceDistance)
        self.setupIconForEntrance(icon: self.iCloudIcon, xDisplacement: -self.entranceDistance)
        self.setupIconForEntrance(icon: self.googleCalendarIcon, xDisplacement: self.entranceDistance)
        
        // Make calendar image transparent
        self.calendarImage.alpha = 0.0
        
        // Animate icons set 1
        UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 1.0, initialSpringVelocity: 5.0, options: .curveEaseInOut, animations: {
            self.resetIcon(icon: self.outlookIcon) // Animate in
        }, completion: { (completion) in
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 10.0, options: .curveEaseInOut, animations: {
                self.resetIcon(icon: self.yahooIcon) // Animate in
            }, completion: { (completion) in
                // This animation finished last - all animations complete
                self.resetAnimations() // Ensure all in default positions
            })
        })
        
        // Animate icons set 2
        UIView.animate(withDuration: 0.2, delay: 0.00, usingSpringWithDamping: 0.5, initialSpringVelocity: 10.0, options: .curveEaseInOut, animations: {
            self.resetIcon(icon: self.iOSCalendarIcon) // Animate in
            self.resetIcon(icon: self.iCloudIcon) // Animate in
        }, completion: { (completion) in
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 15.0, options: .curveEaseInOut, animations: {
                self.resetIcon(icon: self.googleCalendarIcon) // Animate in
            }, completion: nil)
        })
        
        // Animate calendar image transparency
        UIView.animate(withDuration: 0.25, animations: {
            self.calendarImage.alpha = 1.0
        })
    }
    
    func resetIcon(icon: UIImageView) {
        icon.transform = .identity
        icon.alpha = 1.0
    }
    
    func setupIconForEntrance(icon: UIImageView, xDisplacement: CGFloat) {
        icon.transform = CGAffineTransform(translationX: xDisplacement, y: 0.0)
        icon.alpha = 0.0
    }
    
    func styleIcons() {
        // Store all icons in array
        let icons: [UIImageView] = [
            self.outlookIcon,
            self.yahooIcon,
            self.iOSCalendarIcon,
            self.iCloudIcon,
            self.googleCalendarIcon
        ]
        
        for (_, icon) in icons.enumerated() {
            icon.layer.shadowColor = UIColor.black.cgColor
            icon.layer.shadowOpacity = 0.3
            icon.layer.shadowOffset = CGSize(width: 6, height: 3)
            icon.layer.shadowRadius = 4
        }
        
    }
}
