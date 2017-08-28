//
//  Create Event Screen.swift
//  Slate Calendar
//
//  Created by Kevin Hou on 6/5/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import EventKit

class CreateEventScreen: UIViewController {
    
    @IBOutlet weak var containerView: UIView!

    // Card view
    @IBOutlet weak var summaryCard: UIView!
    @IBOutlet weak var summaryTitle: UILabel!
    @IBOutlet weak var summaryLocation: UILabel!
    @IBOutlet weak var summaryDateTime: UILabel!
    @IBOutlet weak var summaryCardTopConstraint: NSLayoutConstraint!
    var blackFade: UIView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSize.screen_width, height: ScreenSize.screen_height)) // Covers full screen
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    // Other UI Elements
    @IBOutlet weak var submitConfirmation: UIImageView!
    @IBOutlet weak var submitConfirmationWidth: NSLayoutConstraint!
    @IBOutlet weak var submitConfirmationHeight: NSLayoutConstraint!
    @IBOutlet weak var submitStatusLabel: UILabel!
    
    // Instance of calendar manager
    let calendarManager: CalendarManager = CalendarManager()
    
    override func viewDidLoad() {
        // Setup summary card view
        self.setupSummaryCard()
        
        // Log screen in GA
        var screenName: String = "Event Details - With Category" // With category
        if data.meta.noCategory { // Change screen name if category
            screenName = "Event Details - No Category"
        }
        Analytics.setScreenName(screenName) // Log screen name
    }
    
    // Cancelled event
    @IBAction func cancelEvent(_ sender: Any) {
        
        // GA Event: User cancelled event
        let secondsEllapsed = Date.timeIntervalSinceReferenceDate - data.event.time // Calculate seconds elapsed
        Analytics.cancelledEventCreation(duration: Int(secondsEllapsed), withShortcut: data.meta.withShortcut) // Log event in GA
        
        view.endEditing(true) // Force keyboard to close
        dismiss(animated: true, completion: nil) // Exit segue back to category selection
    }
    
    // Saved event
    @IBAction func saveEvent(_ sender: Any) {
        let validInputs: Bool = self.validateParameters() // Ensure that form was filled out correctly
        
        if !validInputs { // If not filled out correctly
            let alert = UIAlertController(title: "Form Incomplete", message: "Please enter an event name", preferredStyle: .alert) // Create alert message
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                print("Please fill out even name")
            })) // Add button to dismiss
            self.present(alert, animated: true, completion: nil) // Present alert
        } else {
            // If neccessary inputs filled out correctly
            self.generateCard() // Begin process to add event to calendar
        }
    }
    
    func createEvent() {
        let event: EKEvent = EKEvent(eventStore: self.calendarManager.eventStore)
        
        // Determine even name
        if data.meta.noCategory { // If no category
            event.title = data.event.name
        } else { // Connected to category
            if DataManager.includeCategoryLabel() { // If including category name
                event.title = "[" + data.meta.category.name + "] " + data.event.name
            } else { // If not including category name
                event.title = data.event.name
            }
        }
        
        event.location = data.event.room + " " + data.event.location
        
        // Set the calendar
        event.calendar = self.calendarManager.eventStore.defaultCalendarForNewEvents // Default calendar
        
        // Compensate for daylight savings
        var minutesFromMidnight = data.event.time
        print("data.event.time: \(data.event.time)")
        let timeZone = NSTimeZone.local // Time zone
        let offset = -timeZone.daylightSavingTimeOffset(for: data.event.date)
        if (timeZone.isDaylightSavingTime()) {
            print("Offsetting time by \(offset)")
            minutesFromMidnight += offset // Add daylight savings time offset
        }
        
        // Date and time
        print("Minutes from midnight: \(minutesFromMidnight)")
        let startDate: Date = data.event.date.addingTimeInterval(minutesFromMidnight) // Create start date
        event.startDate = startDate
        event.endDate = startDate.addingTimeInterval(data.event.time)
        event.isAllDay = false // Not all day
        
        // Set event alert
        let secondsBefore: TimeInterval = -1 * DataManager.reminderTime() // Get reminder time
        print("Event reminder time: \(DataManager.reminderTime())") // Debugging
        let defaultAlert: EKAlarm = EKAlarm(relativeOffset: secondsBefore) // Set alert before event time
        event.addAlarm(defaultAlert) // Add default alert
        
        print(event.title)
        
        self.calendarManager.saveEvent(event: event) // Save event
    }
    
    // Check all the form elements to make sure filled
    func validateParameters() -> Bool {
        // Only need to make sure event name and location text inputs are filled
        let nameFilled: Bool = (data.event.name != "")
        let locationFilled: Bool = (data.event.location != "")
        
        if !locationFilled { // Not an error if event doesn't have a location
            print("Location was not filled")
        }
        
        if !nameFilled { // Return false if no event name
            return false
        }
        
        return true // All parameters valid
    }
    
    func setupSummaryCard() {
        // Summary card initial positioning
        self.summaryCardTopConstraint.constant = self.summaryCardTopConstraint.constant + ScreenSize.screen_height // Move it off screen
        self.view.layoutIfNeeded() // Update frontend
        
        // Summary card styling
        self.summaryCard.layer.cornerRadius = 10.0
        self.summaryCard.layer.shadowColor = Colors.grey.cgColor
        self.summaryCard.layer.shadowRadius = 10.0
        self.summaryCard.layer.shadowOffset = CGSize.zero
        self.summaryCard.layer.shadowOpacity = 0.75
        self.summaryCard.clipsToBounds = true
        
        // Setup black fade
        self.blackFade.backgroundColor = Colors.black
        self.blackFade.layer.opacity = 0.0 // Transparent
        self.view.insertSubview(self.blackFade, belowSubview: self.summaryCard) // Insert behind summary card
        
        // Hide loading spinner and submit confirmation
        self.loadingSpinner.layer.opacity = 0.0
        self.submitConfirmation.layer.opacity = 0.0
        self.submitStatusLabel.layer.opacity = 0.0
    }
    
    func generateCard() {
        // Populate information
        
        if data.meta.noCategory { // If no category
            self.summaryTitle.text = data.event.name
        } else { // Connected to category
            if DataManager.includeCategoryLabel() { // If user wants to include category name
                self.summaryTitle.text = "[" + data.meta.category.name + "] " + data.event.name
            } else { // If not including cateogyr name
                self.summaryTitle.text = data.event.name
            }
        }
        
        if data.event.room == "" { // If there's no room number
            self.summaryLocation.text = data.event.location // No leading space
        } else { // If there's a room number
            self.summaryLocation.text = data.event.room + " " + data.event.location // Concatinate
        }
        
        // Format summary time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d" // Date only
        let dateStr: String = dateFormatter.string(from: data.event.date)
        
        // Compensate for daylight savings
        var minutesFromMidnight = data.event.time
        let timeZone = NSTimeZone.local // Time zone
        let offset = -timeZone.daylightSavingTimeOffset(for: data.event.date)
        if (timeZone.isDaylightSavingTime()) {
            minutesFromMidnight += offset // Add daylight savings time offset
        }
        
        dateFormatter.dateFormat = "h:mm a" // Time only
        let startTime: Date = data.event.date.addingTimeInterval(minutesFromMidnight) // Calculate starting time
        let endTime: Date = startTime.addingTimeInterval(data.event.duration) // Calculate end time
        let timeStr: String = dateFormatter.string(from: startTime) + " - " + dateFormatter.string(from: endTime) // Concatinate string
        self.summaryDateTime.text = dateStr + " \n" + timeStr // Add to card view
        
        // Card entrance
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.blackFade.layer.opacity = 0.75 // Black backdrop
            self.summaryCardTopConstraint.constant = self.summaryCardTopConstraint.constant - ScreenSize.screen_height // Move it back on screen
            self.view.layoutIfNeeded() // Animate update position
            
            self.submitStatusLabel.layer.opacity = 1.0 // Make status label visible
        }, completion: { finished in
            // Start loading spinner
            self.loadingSpinner.layer.opacity = 1.0
            self.loadingSpinner.startAnimating()
            
            self.createEvent() // Create and save event to calendar
            
            // Send analytics event
            let secondsEllapsed = Date.timeIntervalSinceReferenceDate - data.user.startTime // Calculate seconds elapsed
            //            print("Created event with time elalapsed: \(secondsEllapsed)") // Feedback
            if data.meta.noCategory { // Not attached to category
                Analytics.createdEventNoCategory(duration: Int(secondsEllapsed), withShortcut: data.meta.withShortcut)
            } else { // Attached to category
                Analytics.createdEventWithCategory(duration: Int(secondsEllapsed), withShortcut: data.meta.withShortcut)
            }
            
            // Update markov models if there's a category
            print(data.meta.noCategory)
            if (!data.meta.noCategory) {
                print("Logging event data")
                data.logEventData()
            }
            
            // Exit animations
            self.saveConfirmation()
            self.cardExit()
        })
    }
    
    func cardExit() {
        UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseIn, animations: {
            // Animate out
            self.blackFade.layer.opacity = 0 // Transparent
            self.summaryCardTopConstraint.constant = self.summaryCardTopConstraint.constant - ScreenSize.screen_height // Move it off screen up
            self.view.layoutIfNeeded() // Animate update position
        }, completion: { finished in
            // MARK - Adding event complete
            
            // Make transparent to prevent user from seeing it
            self.summaryCard.layer.opacity = 0.0
            self.submitConfirmation.layer.opacity = 0.0 // Make label transparent
            
            // Exit segue back to category selection
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func saveConfirmation() {
        UIView.animate(withDuration: 0.15, delay: 0.75, options: .curveLinear, animations: {
            // Animate the save confirmation icon
            self.submitConfirmation.layer.opacity = 1.0
            
            // Enlarge
            self.submitConfirmationWidth.constant = 20.0 // Only change width because aspect fit
            
            self.view.layoutIfNeeded() // Update view
        }, completion: { finished in
            self.loadingSpinner.layer.opacity = 0.0 // Make loading spinner transparent
            
            // Change label to reflect status
            self.submitStatusLabel.text = "Added to Calendar"
        })
    }
}
