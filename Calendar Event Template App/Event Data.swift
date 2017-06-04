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
        meta.noCategory = category == Constants.emptyCategory // If empty category, there is no category declared
        
        // Set start time for analytics purposes
        user.startTime = Date.timeIntervalSinceReferenceDate // Reset
    }
    
    // MARK - Public functions to update the event values
    public static func updateEventName(name: String) {
        event.name = name // Set name
    }
    
    public static func updateEventLocation(location: String) {
        event.location = location // SEt location
    }
}
