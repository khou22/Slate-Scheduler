//
//  OnboardingPageFour.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/28/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

struct PageThreeData {
    @available(iOS 10.0, *)
    static var scrollingAnimations: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 2.0, timingParameters: UISpringTimingParameters(mass: 2.5, stiffness: 70, damping: 55, initialVelocity: CGVector(dx: 0, dy: 0)))
}

class OnboardingPageThree: UIViewController, CLLocationManagerDelegate {
    
    // UI Elements
    @IBOutlet weak var globeImage: UIImageView!
    @IBOutlet weak var locationPermissionButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var permissionGranted: UIImageView!
    @IBOutlet weak var lowerLabel: UILabel!
    
    // Constraints
    @IBOutlet weak var mapPinBottomConstraint: NSLayoutConstraint!
    var originalMapPinBottomConstraintConst: CGFloat = -26.0
    @IBOutlet weak var globeImageWidthConstraint: NSLayoutConstraint! // Default 200 for iPhone 7
    @IBOutlet weak var mapPinWidthConstraint: NSLayoutConstraint! // Default 130 for iPhone 7
    @IBOutlet weak var locationPermissionButtonLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var locationPermissionButtonRightConstraint: NSLayoutConstraint!
    @IBOutlet weak var globeImageBottomConstraint: NSLayoutConstraint!
    
    
    let locationManager: CLLocationManager = CLLocationManager()
    var failedAccessGrant: Bool = false // Track whether user denied access
    
    override func viewDidLoad() {
        onboardingBackground() // Setup background gradient
        self.initializeScrollAnimations() // Initialize scrolling animations
        
        // Round button corners
        self.locationPermissionButton.layer.cornerRadius = 4
        
        self.permissionGranted.layer.opacity = 0.0 // Hide permission granted checkmark
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ScrollData.setCurrentPage(index: 3)
        
        Analytics.setScreenName("Onboarding Page Three") // Log screen name
    }
    
    override func viewDidLayoutSubviews() {
        self.adjustForScreenSizes()
        self.entranceAnimations() // Start animations before screen appears
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.checkLocationPermissions() // Check status and update frontend
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.resetAnimations() // Reset scrolling animations
    }
    
    // User is requesting location permission
    @IBAction func pressedLocationPermissionButton(_ sender: Any) {
//        print("Pressed location access button")
        
        // If already asked and failed
        if self.failedAccessGrant {
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            } // Get url location for Settings app
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in // print("Settings opened: \(success)") // Prints true
                })
            }
            return // Terminate function
        }
        
        // Hide button and load activity indicator
        self.locationPermissionButton.isHidden = true // Hide button
        self.activityIndicator.layer.opacity = 1.0 // Show and animate spinner
        
        // Prompt user to allow location permission
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization() // Ask for authorization
    }

    // If authorization status changed
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        print("Location access changed")
        self.checkLocationPermissions() // Check status and update frontend
    }
    
    func checkLocationPermissions() {
        let status: CLAuthorizationStatus = CLLocationManager.authorizationStatus() // Get authorization status
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            print("Authorized location services")
            // Success
            UIView.animate(withDuration: 0.25, animations: {
                self.locationPermissionButton.isHidden = true // Hide button if not already hidden
                self.activityIndicator.layer.opacity = 0.0 // Hide spinner
                self.permissionGranted.layer.opacity = 1.0 // Show permission granted checkmark
                self.lowerLabel.text = "We will never track your location — we only need it so you can easily add locations to your events."
            })
        } else { // Didn't authorize
            if (status != .notDetermined) { // Only show alerts if access denied
                print("Didn't authorize location services")
                UIView.animate(withDuration: 0.25, animations: {
                    self.activityIndicator.layer.opacity = 0.0 // Hide spinner
                    self.lowerLabel.text = "For the best experience, please enable location access in the Settings app."
                    self.locationPermissionButton.setTitle("Go to Settings", for: .normal)
                    self.failedAccessGrant = true // User denied access
                    self.locationPermissionButton.isHidden = false
                })
            }
        }
    }

    func prepareEntranceAnimations() {
        self.originalMapPinBottomConstraintConst = self.mapPinBottomConstraint.constant // Store
    }
    
    func entranceAnimations() {
        self.prepareEntranceAnimations() // Prepare animations
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 2.0, options: [.autoreverse, .repeat, .curveEaseInOut], animations: {
            self.mapPinBottomConstraint.constant = -12.0 // Move upwards
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    // Function called when user is scrolling
    func updateScrollPercentage() {
        let percentage = CGFloat(ScrollData.value)
        
        // Update animation percentage complete
        if #available(iOS 10.0, *) {
            PageThreeData.scrollingAnimations.fractionComplete = percentage * 0.95
        }
    }
    
    func initializeScrollAnimations() {
        if #available(iOS 10.0, *) {
            PageThreeData.scrollingAnimations.addAnimations({
                // Rotate globe
                self.globeImage.transform = CGAffineTransform(rotationAngle: CGFloat(Angles.radians(-120)))
            })
        } else {
            // Fallback on earlier versions
        }
    }
    
    func resetAnimations() {
        self.globeImage.transform = .identity // Reset animations
    }
    
    func adjustForScreenSizes() {
        
        if DeviceTypes.iPhoneSE || DeviceTypes.iPhone7Zoomed {
            // Change constraint constants, etc. here
            self.globeImageWidthConstraint.constant = 150
            self.mapPinWidthConstraint.constant = 80
            self.locationPermissionButtonLeftConstraint.constant = 60
            self.locationPermissionButtonRightConstraint.constant = 60
            self.globeImageBottomConstraint.constant = 25
            
            view.layoutIfNeeded()
            
        } else {
            
        }
    }

}
