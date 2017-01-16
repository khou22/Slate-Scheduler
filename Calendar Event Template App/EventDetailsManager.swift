//
//  EventDetailsManager.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/6/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//
//  This handles all the backend data for the Event Details page
//  Helps clean up code

import Foundation
import UIKit
import EventKit

extension EventDetails {
    
    // Calculate the labels for the quick day picker and update global variables
    func calcQuickDays() {
        let today: Date = Date()
        
        // Date formatter to just get date number
        let dayNumberFormatter = DateFormatter()
        dayNumberFormatter.dateFormat = "d" // Day number ie. '2/1/17' -> '1'
        
        // Date formatter to just get day of week
        let dayOfWeekFormatter = DateFormatter()
        dayOfWeekFormatter.dateFormat = "EEE" // 3 letter abbreviation of weekday
        
        let firstTwoStrings: [String] = ["Today", "Tomorrow"] // First two labels
        
        for index in 0..<numQuickDays {
            let currentDate = today.addingTimeInterval(24 * 60 * 60 * Double(index)) // Add x number of days
            
            self.dateOptions[index] = currentDate.dateWithoutTime() // Date value without time of that day
            
            self.dayLabels[index] = dayNumberFormatter.string(from: currentDate) // Set date number
            
            if (index > 1) { // Exclude the first two days
                self.weekdayLabels[index] = dayOfWeekFormatter.string(from: currentDate) // Set day of week
            } else {
                self.weekdayLabels[index] = firstTwoStrings[index] // Set "Today" and "Tomorrow"
            }
        }
    }
    
    func refreshQuickDay() {
        self.calcQuickDays() // Calculate quick days
        
        // Refresh collection view
        DispatchQueue.main.async {
            self.quickDayPicker.reloadData()
        }
    }
    
    func refreshDaysEvents() {
        self.daysEvents = self.calendarManager.getEvents(day: eventDate.dateWithoutTime())
        
        // Refresh the table
        DispatchQueue.main.async {
            self.eventListTable.reloadData()
        }
    }
    
    func updateDateLabel() {
        // Change frontend label
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d" // Format
        self.dateLabel.text = dateFormatter.string(from: self.eventDate) + " at" // Update label
    }
    
    func createEvent() {
        let event: EKEvent = EKEvent(eventStore: self.calendarManager.eventStore)
        
        // Determine even name
        if self.noCategory { // If no category
            event.title = self.eventNameInput.text!
        } else { // Connected to category
            event.title = "[" + category.name + "] " + self.eventNameInput.text!
        }
        
        event.location = self.roomInput.text! + " " + self.locationInput.text!
        
        // Set the calendar
        event.calendar = self.calendarManager.eventStore.defaultCalendarForNewEvents // Default calendar
        
        // Date and time
        let startDate: Date = self.eventDate.addingTimeInterval(self.eventTime) // Create start date
        event.startDate = startDate
        event.endDate = startDate.addingTimeInterval(self.durationSlider.roundValue() * 3600.0) // Convert hours to time interval
        event.isAllDay = false // Not all day
        
        self.calendarManager.saveEvent(event: event) // Save event
    }
    
    // Check all the form elements to make sure filled
    func validateParameters() -> Bool {
        // Only need to make sure event name and location text inputs are filled
        let nameFilled: Bool = (self.eventNameInput.text != "")
        let locationFilled: Bool = (self.locationInput.text != "")
        
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
        
        if self.noCategory { // If no category
            self.summaryTitle.text = self.eventNameInput.text!
        } else { // Connected to category
            self.summaryTitle.text = "[" + category.name + "] " + self.eventNameInput.text!
        }
        
        self.summaryLocation.text = self.roomInput.text! + " " + self.locationInput.text! // Concatinate
        
        // Format summary time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d" // Date only
        let dateStr: String = dateFormatter.string(from: self.eventDate)
        
        dateFormatter.dateFormat = "h:mm a" // Time only
        let startTime: Date = self.eventDate.addingTimeInterval(self.eventTime) // Calculate starting time
        let endTime: Date = startTime.addingTimeInterval(self.durationSlider.roundValue() * 3600.0) // Calculate end time
        let timeStr: String = dateFormatter.string(from: startTime) + " - " + dateFormatter.string(from: endTime) // Concatinate string
        self.summaryDateTime.text = dateStr + " \n " + timeStr // Add to card view
        
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
            
            // Update markov models
            self.logEventData()
            
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
            // Adding event complete
            
            // Make transparent to prevent user from seeing it
            self.summaryCard.layer.opacity = 0.0
            self.submitConfirmation.layer.opacity = 0.0
            
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
            // Change label to reflect status
            self.submitStatusLabel.text = "Added to Calendar"
        })
    }
    
    /************ Log to predictive analytics ************/
    func logEventData() {
        // Markov model with category to event name
        if let count = self.category.eventNameFreq[self.eventNameInput.text!] { // If it has been logged before
            print("Updated frequency for \(self.eventNameInput.text): \(count + 1)")
            self.category.eventNameFreq[self.eventNameInput.text!] = count + 1 // Increment counter
        } else {
            print("New frequency entry for \(self.eventNameInput.text)")
            self.category.eventNameFreq[self.eventNameInput.text!] = 1 // Create a dictionary reference with frequency of 1
        }
        
        // Markov model with event name to location
        DataManager.updateOneCategory(with: self.category, index: self.categoryIndex)
    }
}
