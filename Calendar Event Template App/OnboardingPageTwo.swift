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

struct PageTwoData {
    @available(iOS 10.0, *)
    static var scrollingAnimations: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 2.0, timingParameters: UISpringTimingParameters(mass: 2.5, stiffness: 70, damping: 55, initialVelocity: CGVector(dx: 0, dy: 0)))
}

class OnboardingPageTwo: UIViewController {
    
    @IBOutlet weak var calendarPermissionButton: UIButton!
    @IBOutlet weak var permissionGranted: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var lowerLabel: UILabel!
    
    // UI elements to animate
    @IBOutlet weak var alertPromptImage: UIImageView!
    @IBOutlet weak var alertPromptImageLeading: NSLayoutConstraint!
    @IBOutlet weak var alertPromptImageTrailing: NSLayoutConstraint!
    
    // Constraints to modify
    @IBOutlet weak var alertPromptImageTopConstraint: NSLayoutConstraint!
    
    var failedAccessGrant = false // If user denied calendar access permission
    
    let calendarManager: CalendarManager = CalendarManager() // Store
    
    override func viewDidLoad() {
        onboardingBackground() // Setup background gradient
        
        self.initializeScrollAnimations() // Setup scrolling percentage
        
        // Round button corners
        self.calendarPermissionButton.layer.cornerRadius = 4
        
        self.permissionGranted.layer.opacity = 0.0 // Start invisible
        self.calendarPermissionButton.setTitleColor(Colors.lightGrey, for: .selected) // Set button text color when pressed
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ScrollData.setCurrentPage(index: 2) // Set current page
        
        Analytics.setScreenName("Onboarding Page Two") // Log screen nameAnalytics.setScreenName("Onboarding Page Two") // Log screen name
        
        self.prepareAnimation() // Prepare entance animation - make alert prompt image small
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.entranceAnimation() // Trigger entrance animation
        
        self.checkCalendarPermissions() // Check location status and update permissions
    }
    
    override func viewDidLayoutSubviews() {
        self.adjustForScreenSizes() // Adjust constraints for screen sizes
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.resetAnimations() // Reset scrolling animations
    }
    
    func updateScrollPercentage() {
        let percentage = CGFloat(ScrollData.value)
        if #available(iOS 10.0, *) {
            PageTwoData.scrollingAnimations.fractionComplete = percentage * 0.95 // Update animation percentage
        }
    }
    
    @IBAction func promptCalendarPermission(_ sender: Any) {
        if self.failedAccessGrant {
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            } // Get url location for Settings app
            if UIApplication.shared.canOpenURL(settingsUrl) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(NSURL(string:UIApplicationOpenSettingsURLString)! as URL)
                }
            }
            return // Terminate function
        }
        
        // Hide button and load activity indicator
        self.calendarPermissionButton.isHidden = true // Hide button
        self.activityIndicator.layer.opacity = 1.0 // Show and animate spinner
        
        // Request calendar access
        DataManager.didAskForCalendarAccess() // Store that asked for calendar access
        self.calendarManager.requestAccess(completion: { (success) in
//            print("Requested calendar access \(success)")
            if success {
                self.checkCalendarPermissions() // Check location status and update permissions
                
                // If just authorized
                if EKEventStore.authorizationStatus(for: EKEntityType.event) == .authorized {
                    Analytics.calendarPermissionGranted() // Log GA event
                } else {
                    Analytics.calendarPermissionDenied() // Log GA event
                }
            }
        })
    }
    
    // Check calendar permission and update frontend
    func checkCalendarPermissions() {
        let calendarPermission = EKEventStore.authorizationStatus(for: EKEntityType.event)
        let authorized = (calendarPermission == .authorized)
        if authorized { // If authorized the calendar
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.25, animations: {
                    self.calendarPermissionButton.isHidden = true // Hide button if not already hidden
                    self.activityIndicator.layer.opacity = 0.0 // Hide spinner
                    self.permissionGranted.layer.opacity = 1.0 // Show permission granted checkmark
                })
            }
        } else { // If didn't authorize calendar
            if (!self.failedAccessGrant && calendarPermission != .notDetermined) { // Only show alerts if already asked user
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
        }
    }
    
    func entranceAnimation() {
        self.prepareAnimation()
        
        UIView.animate(withDuration: 0.2, delay: 0.05, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
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
    
    // Scrolling animations
    func initializeScrollAnimations() {
        if #available(iOS 10.0, *) {
            PageTwoData.scrollingAnimations.addAnimations({
                self.alertPromptImage.transform = CGAffineTransform(translationX: 20.0, y: 0.0) // Parallax effect
            })
        }
    }
    
    // Reset scrolling animations
    func resetAnimations() {
        self.alertPromptImage.transform = .identity // Restore to original
    }
    
    func adjustForScreenSizes() {
        
        if DeviceTypes.iPhoneSE || DeviceTypes.iPhone7Zoomed {
            // Change constraint constants, etc. here
            self.alertPromptImageTopConstraint.constant = 40
            
            view.layoutIfNeeded()
        } else if DeviceTypes.iPad {
            self.alertPromptImageLeading.constant = 50.0
            self.alertPromptImageTrailing.constant = -50.0
        }
    }

}
