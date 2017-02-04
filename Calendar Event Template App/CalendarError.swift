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
    
    override func viewDidLoad() {
        onboardingBackground() // Use gradient background
        print("Calendar permission error")
        
        self.settingsButton.layer.cornerRadius = 4 // Round corners
    }
    
    func entranceAnimation() {
        let calendarImageWithX: UIImageView = UIImageView(frame: self.calendarErrorImageNoX.frame) // Initialize with same frame
        if let image = UIImage(named: Images.calendarError) {
            calendarImageWithX.image = image // Add image to image view
        }
        UIView.animate(withDuration: 0.75, delay: 0.5, usingSpringWithDamping: 1.0, initialSpringVelocity: 5.0, options: .curveEaseInOut, animations: {
            self.view.addSubview(calendarImageWithX) // Add to view
        }, completion: nil)
    }
}
