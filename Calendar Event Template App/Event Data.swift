//
//  Event Data.swift
//  Slate Calendar
//
//  Created by Kevin Hou on 6/5/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation

// Global struct to store event data
struct data {
    
    // Meta data
    struct meta {
        static var noCategory: Bool = true // Signify if using a category
        static var categoryIndex: Int = 0 // Set the category index
        static var withShortcut: Bool = false // Pass on if used shortcut
        static var category: Category = Constants.emptyCategory // Store category
    }
    
    // Event data
    struct event {
        static var name: String = "" // Event name
        static var location: String = "" // Event location
        static var room: String = "" // Room number
        static var date: Date = Date().dateWithoutTime() // Event date
        static var time: Double = 11 * 3600.0 // Minutes from midnight
        static var duration: Double = 3600.0 // Default one hour
        static var allDay: Bool = false // Default not all day
    }
    
    // User analytics data
    struct user {
        static var startTime = Date.timeIntervalSinceReferenceDate // Current time
    }
    
    // A user triggered init
    public static func newEventSession(with category: Category, categoryIndex: Int, withShortcut: Bool) {
        
        // Set meta data
        meta.category = category
        meta.categoryIndex = categoryIndex
        meta.withShortcut = withShortcut
        meta.noCategory = (categoryIndex == -1) // If empty category, there is no category declared
        
        // Set start time for analytics purposes
        user.startTime = Date.timeIntervalSinceReferenceDate // Reset
        
        // Default values for the event
        event.date = Date().dateWithoutTime()
        event.time = 11 * 3600.0
        event.duration = 3600.0
        event.allDay = false
    }
    
    // MARK - Public functions to update the event values
    public static func updateEventName(name: String) {
        event.name = name // Set name
    }
    
    public static func updateEventLocation(location: String) {
        event.location = location // SEt location
    }
    
    // MARK - Formatting values
    // Formatting the time and returning a string
    public static func formatTimeLabel() -> String {
        if (event.allDay) {
            return "12 AM (All Day Event)" // If an all day event
        }

        // Format event time label
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: Date(timeIntervalSince1970: data.event.time - Double(NSTimeZone.local.secondsFromGMT())))
    }
    
    // Format the duration and return as string
    public static func formatDurationLabel() -> String {
        if (event.allDay) {
            return "24 hours" // For all day events
        }
        
        return String(data.event.duration / 3600.0) + " hours" // Real time rounded value of slider
    }
    
    public static func getStartDate() -> Date {
        var date = data.event.date.addingTimeInterval(data.event.time)
        
        // Componesate for daylight savings
        let offset = -NSTimeZone.local.daylightSavingTimeOffset(for: data.event.date)
        if (NSTimeZone.local.isDaylightSavingTime()) {
            date = date.addingTimeInterval(offset) // Add daylight savings time offset
        }
        
        return date // Return final start date
    }

    
    /************ Log to predictive analytics ************/
    public static func logEventData() {
        // Update number of times the category has been used to create an event
        meta.category.timesUsed += 1 // Increment
        
        // Markov model with category to event name
        if let count = meta.category.eventNameFreq[data.event.name] { // If it has been logged before
//            print("Updated frequency for \(data.event.name): \(count + 1)")
            meta.category.eventNameFreq[data.event.name] = count + 1 // Increment counter
        } else {
//            print("New frequency entry for \(data.event.name)")
            meta.category.eventNameFreq[data.event.name] = 1 // Create a dictionary reference with frequency of 1
        }
        
        // Markov model with category to location
        if (event.location != "") { // Only log if location input exists
            if let count = data.meta.category.locationFreq[data.event.location] { // If it has been logged before
//                print("Updated frequency for \(event.location): \(count + 1)")
                meta.category.locationFreq[data.event.location] = count + 1 // Increment counter
            } else {
//                print("New frequency entry for \(event.location)")
                meta.category.locationFreq[data.event.location] = 1 // Create a dictionary reference with frequency of 1
            }
        }
        
        // Save update markov models
//        print("Updating \(meta.category) with index \(meta.categoryIndex)")
        DataManager.updateOneCategory(with: data.meta.category, index: data.meta.categoryIndex)
    }
    
}
