//
//  OnboardingPageThree.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/23/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import UIKit
import EventKit

class OnboardingPageFour: UIViewController {
    
    // UI Elements
    @IBOutlet weak var summaryCard: UIImageView! // Main event summary card image
    var summaryCardBottom: UIImageView = UIImageView() // Bottom summary card (rotated right)
    var summaryCardTop: UIImageView = UIImageView() // Top summary card (rotated left)
    @IBOutlet weak var pageTitle: UILabel!
    
    @IBOutlet weak var categoryLabelSwitch: UISwitch!
    @IBOutlet weak var getStartedButton: UIButton!
    
    var cardsAnimated: Bool = false // If cards are in the animated position
    
    // Constraints to modify
    @IBOutlet weak var categoryLabelStackBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var summaryCardLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var summaryCardRightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        adjustForScreenSizes() // Adjust constraints for screen sizes
        
        onboardingBackground() // Setup background gradient
        setupSummaryCards() // Create the other two summary cards
        
        self.getStartedButton.layer.cornerRadius = 4 // Round button corners
        self.getStartedButton.setTitleColor(Colors.lightGrey, for: .selected) // Set button text color when pressed
        self.getStartedButton.showsTouchWhenHighlighted = true // Show a button press
        
        // Set initial state of category label switch
        if (DataManager.onboardingStatus()) { // If user has already been through onbaording
            self.categoryLabelSwitch.isOn = DataManager.includeCategoryLabel() // Use preference
        } else { // If user's first time going through onboarding
            self.categoryLabelSwitch.isOn = true // Default is on
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ScrollData.setCurrentPage(index: 4)
        
        Analytics.setScreenName("Onboarding Page Four") // Log screen name
        
        self.checkCalendarAuth() // Check for calendar authorization
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !self.cardsAnimated {
            self.animateSummaryCards() // Start animations
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.resetSummaryCardAnimation() // Reset animations
    }
    
    // Triggered when category label switch is flipped
    @IBAction func categoryLabelSwitchUpdated(_ sender: Any) {
        if self.categoryLabelSwitch.isOn { // If category
            self.summaryCardTop.image = UIImage(named: Images.eventSummaryCard) // Set most visible image
        } else { // If user has opted for no category label
            self.summaryCardTop.image = UIImage(named: Images.eventSummaryCardNoCategory) // Set most visible image
        }
    }
    
    func setupSummaryCards() {
        // Superimpose on summary card
        self.summaryCardBottom = UIImageView(frame: self.summaryCard.frame)
        self.summaryCardTop = UIImageView(frame: self.summaryCard.frame)
        
        // Set images
        self.summaryCardTop.image = self.summaryCard.image // Set most visible
        self.summaryCardBottom.image = UIImage(named: Images.eventSummaryCardAlt2)
        self.summaryCard.image = UIImage(named: Images.eventSummaryCardAlt1)
        
        // Insert views
        view.insertSubview(self.summaryCardBottom, belowSubview: self.summaryCard) // Insert below original
        view.insertSubview(self.summaryCardTop, aboveSubview: self.summaryCard) // Insert above original
    }
    
    func animateSummaryCards() {
        // Animate positions
        UIView.animate(withDuration: 1.2, delay: 0.05, usingSpringWithDamping: 1.0, initialSpringVelocity: 15.0, options: .curveEaseOut, animations: {
            // Copy and create summary cards from original
            self.summaryCardBottom.frame = self.summaryCard.frame.applying(CGAffineTransform(translationX: -10.0, y: 34.0)) // Update frame
            let transformBottom: CGAffineTransform = CGAffineTransform(rotationAngle: CGFloat(Angles.radians(12.0))) // Rotate rights
            
            self.summaryCardTop.frame = self.summaryCard.frame.applying(CGAffineTransform(translationX: 3.0, y: -45.0)) // Top summary card with transform
            let transformTop: CGAffineTransform = CGAffineTransform(rotationAngle: CGFloat(Angles.radians(-12.0))) // Rotate left
//            transformTop.translatedBy(x: 2.0, y: 50.0) // Shift right and up

            self.summaryCardBottom.transform = transformBottom // Apply transformation
            self.summaryCardTop.transform = transformTop // Apply transformation
        }, completion: { (completion) in
//            print("Cards finished animating")
            self.cardsAnimated = true // Positions in animated state
        })
    }
    
    func resetSummaryCardAnimation() {
        // Reset the translations for summary cards
        self.summaryCardBottom.transform = CGAffineTransform.identity
        self.summaryCardTop.transform = CGAffineTransform.identity
        
        // Reset frame to main frame
        self.summaryCardBottom.frame = self.summaryCard.frame
        self.summaryCardTop.frame = self.summaryCard.frame
        
        self.cardsAnimated = false // Positions reset
    }
    
    @IBAction func getStarted(_ sender: Any) {
        DataManager.setCategoryLabelSetting(value: self.categoryLabelSwitch.isOn) // Set user preference
        DataManager.userCompletedOnboarding() // Store that user completed onboarding
        self.performSegue(withIdentifier: SegueIdentifiers.completeOnboarding, sender: self)
    }
    
    func checkCalendarAuth() {
        let calendarPermission = EKEventStore.authorizationStatus(for: EKEntityType.event)
        if calendarPermission != .authorized { // If not authorized the calendar
            DispatchQueue.main.async {
                self.pageTitle.text = "Calendar permission is required for this app."
                self.getStartedButton.setTitle("Swipe back to authorize", for: .normal) // Button feedback
                self.getStartedButton.setTitleColor(Colors.white, for: .normal) // Button text color
                self.getStartedButton.isEnabled = false // Disable button
                self.getStartedButton.backgroundColor = Colors.lightRed // Change color
            }
        } else { // If calendar is authorized
            DispatchQueue.main.async {
                self.pageTitle.text = "You’re good to go!"
                self.getStartedButton.setTitle("Get started", for: .normal) // Button feedback
                self.getStartedButton.setTitleColor(Colors.white, for: .normal) // Button text color
                self.getStartedButton.isEnabled = true // Enable button
                self.getStartedButton.backgroundColor = Colors.red // Change color to original
            }
        }
    }
    
    func adjustForScreenSizes() {
        if DeviceTypes.iPhoneSE || DeviceTypes.iPhone7Zoomed {
            // Change constraint constants, etc. here
            self.categoryLabelStackBottomConstraint.constant = 16
            self.summaryCardLeftConstraint.constant = 40
            self.summaryCardRightConstraint.constant = 40
            
            view.layoutIfNeeded()
            
        } else {
            
        }
    }

}
