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
    
    @IBOutlet weak var outlookIcon: UIImageView!
    @IBOutlet weak var yahooIcon: UIImageView!
    @IBOutlet weak var iOSCalendarIcon: UIImageView!
    @IBOutlet weak var iCloudIcon: UIImageView!
    @IBOutlet weak var googleCalendarIcon: UIImageView!
    
    var entranceDistance: CGFloat = 100.0
    
    override func viewDidLoad() {
        onboardingBackground() // Setup background gradient
        
        self.styleIcons() // Add styling to the icons
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
        
        UIView.animate(withDuration: 0.4, delay: 0.1, usingSpringWithDamping: 1.0, initialSpringVelocity: 20.0, options: .curveEaseInOut, animations: {
            self.resetIcon(icon: self.outlookIcon) // Animate in
        }, completion: { (completion) in
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 2.0, initialSpringVelocity: 30.0, options: .curveEaseInOut, animations: {
                self.resetIcon(icon: self.yahooIcon) // Animate in
            }, completion: { (completion) in
                print("Finished all animations")
                self.resetAnimations() // Ensure all in default positions
            })
        })
        
        UIView.animate(withDuration: 0.3, delay: 0.05, usingSpringWithDamping: 1.5, initialSpringVelocity: 10.0, options: .curveEaseInOut, animations: {
            self.resetIcon(icon: self.iOSCalendarIcon) // Animate in
            self.resetIcon(icon: self.iCloudIcon) // Animate in
        }, completion: { (completion) in
            UIView.animate(withDuration: 0.3, delay: 0.1, usingSpringWithDamping: 1.0, initialSpringVelocity: 20.0, options: .curveEaseInOut, animations: {
                self.resetIcon(icon: self.googleCalendarIcon) // Animate in
            }, completion: { (completion) in
            })
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
