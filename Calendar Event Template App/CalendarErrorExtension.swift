//
//  CalendarErrorExtension.swift
//  Slate Calendar
//
//  Created by Kevin Hou on 2/4/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import UIKit
import EventKit

extension UIViewController {
    func showCalendarErrorScreen() {
        let calendarPermission = EKEventStore.authorizationStatus(for: EKEntityType.event) // Get authorization status
        let authorized = (calendarPermission == .authorized)
        if !authorized { // If not authorized calendar
            print("Calendar not authorized...seguing to error screen")
            let calendarError = storyboard?.instantiateViewController(withIdentifier: Storyboard.calendarError) as! CalendarError // Retrieve calendar error screen
            let segueToErrorScreen: UIStoryboardSegue = UIStoryboardSegue(identifier: "SegueToError", source: self, destination: calendarError) // Create segue to error screen
            
//            segueToErrorScreen.perform() // Perform segue
        }
    }
}
