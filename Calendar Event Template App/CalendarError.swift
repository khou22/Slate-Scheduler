//
//  CalendarError.swift
//  Slate Calendar
//
//  Created by Kevin Hou on 2/3/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import UIKit

class CalendarError: UIViewController {
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var calendarErrorImageNoX: UIImageView!
    var calendarErrorWithX: UIImageView = UIImageView()
    
    override func viewDidLoad() {
        onboardingBackground() // Use gradient background
        print("Calendar permission error")
        
        self.settingsButton.layer.cornerRadius = 4 // Round corners
        
        // Setup image with x
        self.calendarErrorWithX = UIImageView(frame: self.calendarErrorImageNoX.frame) // Initialize with same frame
        if let image = UIImage(named: Images.calendarError) {
            self.calendarErrorWithX.image = image // Add image to image view
        }
        self.calendarErrorWithX.alpha = 0.0 // Start transparent
        self.view.addSubview(self.calendarErrorWithX) // Add to view
        
        Analytics.setScreenName("Calendar Error Screen") // Log screen name
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.entranceAnimation() // Begin entrance animations
    }
    
    func entranceAnimation() {
        UIView.animate(withDuration: 1.0, delay: 0.5, usingSpringWithDamping: 1.0, initialSpringVelocity: 5.0, options: .curveEaseInOut, animations: {
            self.calendarErrorWithX.alpha = 1.0 // Make visible
        }, completion: nil)
    }
    
    @IBAction func pressedSettings(_ sender: Any) {
        // Open settings app
        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
            return
        } // Get url location for Settings app
        if UIApplication.shared.canOpenURL(settingsUrl) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
//                    print("Settings opened: \(success)") // Prints true
                })
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(NSURL(string:UIApplicationOpenSettingsURLString)! as URL)
            }
        }

    }
}
