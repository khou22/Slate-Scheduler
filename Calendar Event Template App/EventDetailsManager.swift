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
        
//        print("Calculated quick days")
    }
    
    func refreshQuickDay() {
        self.calcQuickDays() // Calculate quick days
        
        // Refresh collection view
        DispatchQueue.main.async {
            self.quickDayPicker.reloadData()
        }
    }
    
    func refreshDaysEvents() {
        self.daysEvents = CalendarManager().getEvents(day: eventDate.dateWithoutTime())
        
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
        let event: EKEvent = EKEvent(eventStore: CalendarManager().eventStore)
        event.title = self.eventNameInput.text!
        event.location = self.locationInput.text
        
        // Date and time
        let startDate: Date = self.eventDate.addingTimeInterval(self.eventTime) // Create start date
        event.startDate = startDate
        event.endDate = startDate.addingTimeInterval(self.durationSlider.roundValue() * 3600.0) // Convert hours to time interval
        event.isAllDay = false // Not all day
        
        CalendarManager().saveEvent(event: event) // Save event
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
        
        // Hide loading spinner
        self.loadingSpinner.layer.opacity = 0.0
    }
    
    func generateCard() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.blackFade.layer.opacity = 0.75 // Black backdrop
            self.summaryCardTopConstraint.constant = self.summaryCardTopConstraint.constant - ScreenSize.screen_height // Move it back on screen
            self.view.layoutIfNeeded() // Animate update position
        }, completion: { finished in
            // Start loading spinner
            self.loadingSpinner.layer.opacity = 1.0
            self.loadingSpinner.startAnimating()
            self.cardExit()
        })
    }
    
    func cardExit() {
        UIView.animate(withDuration: 0.5, delay: 1.0, options: .curveEaseIn, animations: {
            self.blackFade.layer.opacity = 0 // Transparent
            self.summaryCardTopConstraint.constant = self.summaryCardTopConstraint.constant - ScreenSize.screen_height // Move it off screen up
            self.view.layoutIfNeeded() // Animate update position
        }, completion: { finished in
            // Adding event complete
            self.summaryCard.layer.opacity = 0.0 // Make transparent
            self.dismiss(animated: true, completion: nil) // Exit segue back to category selection
        })
    }
}
