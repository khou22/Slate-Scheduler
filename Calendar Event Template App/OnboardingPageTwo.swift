//
//  OnboardingPageTwo.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/23/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import UIKit
import EventKit

class OnboardingPageTwo: UIViewController {
    
    @IBOutlet weak var calendarPermissionButton: UIButton!
    @IBOutlet weak var permissionGranted: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var lowerLabel: UILabel!
    
    // UI elements to animate
    @IBOutlet weak var alertPromptImage: UIImageView!
    @IBOutlet weak var alertPromptImageLeading: NSLayoutConstraint!
    @IBOutlet weak var alertPromptImageTrailing: NSLayoutConstraint!
    
    var failedAccessGrant = false // If user denied calendar access permission
    
    override func viewDidLoad() {
        onboardingBackground() // Setup background gradient
//        print("Onboarding page two loaded")
        
        self.permissionGranted.layer.opacity = 0.0 // Start invisible
        self.calendarPermissionButton.setTitleColor(Colors.lightGrey, for: .selected) // Set button text color when pressed
        self.calendarPermissionButton.showsTouchWhenHighlighted = true // Show a button press
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ScrollData.setCurrentPage(index: 2) // Set current page
        
        self.prepareAnimation() // Make alert prompt image small
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.entranceAnimation() // Trigger entrance animation
    }
    
    func updateScrollPercentage() {
//        let percentage = CGFloat(ScrollData.value)
//        print("Page two registered scroll percentage: \(percentage)")
    }
    
    @IBAction func promptCalendarPermission(_ sender: Any) {
        if self.failedAccessGrant {
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            } // Get url location for Settings app
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
//                    print("Settings opened: \(success)") // Prints true
                })
            }
            return // Terminate function
        }
        
        // Hide button and load activity indicator
        self.calendarPermissionButton.isHidden = true // Hide button
        self.activityIndicator.layer.opacity = 1.0 // Show and animate spinner
        
        // Request calendar access
        CalendarManager().requestAccess(completion: { (success) in
            print("Requested calendar access \(success)")
            let calendarPermission = EKEventStore.authorizationStatus(for: EKEntityType.event)
            let authorized = (success && calendarPermission == .authorized)
            self.activityIndicator.isHidden = true // Hide and turn off spinner
            if authorized { // If authorized the calendar
                print("Success")
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.25, animations: {
                        self.activityIndicator.layer.opacity = 0.0 // Hide spinner
                        self.permissionGranted.layer.opacity = 1.0 // Show permission granted checkmark
                    })
                }
            } else { // If didn't authorize calendar
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.25, animations: {
                        self.activityIndicator.layer.opacity = 0.0 // Hide spinner
                        self.lowerLabel.text = "Please enable calendar access in the Settings app. Without it this app cannot do its job."
                        self.calendarPermissionButton.setTitle("Go to Settings", for: .normal)
                        self.failedAccessGrant = true // User denied access
                        self.calendarPermissionButton.isHidden = false
                    })
                }
            }
        })
    }
    
    func entranceAnimation() {
        self.prepareAnimation()
        
        UIView.animate(withDuration: 0.2, delay: 0.2, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            // Set to original autolayout constraints
            self.alertPromptImage.alpha = 1.0
            self.alertPromptImageLeading.constant = 20.0
            self.alertPromptImageTrailing.constant = -20.0
            self.view.layoutIfNeeded() // Update layout
        }, completion: nil)
    }
    
    func prepareAnimation() {
        // Decrease size of prompt image
        self.alertPromptImageLeading.constant = 40.0
        self.alertPromptImageTrailing.constant = -40.0
        view.layoutIfNeeded()
        
        // Set transparent
        self.alertPromptImage.alpha = 0.0
    }
}
