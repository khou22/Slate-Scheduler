//
//  AnalyticsManager.swift
//  Slate Calendar
//
//  Created by Kevin Hou on 1/31/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//
//  Google Analytics manager

import Foundation

struct Analytics {
    
    static var GATracker: GAITracker = GAI.sharedInstance().defaultTracker
    
    
    private struct Categories {
        static let onboarding               = "Onboarding"
        static let authentication           = "Authentication"
        static let permissions              = "Permissions"
        static let shortcuts                = "Force Touch Shortcuts"
        static let createdEvent             = "Event Creation"
        static let categoryManagement       = "Category Management"
    }
    
    // Setting the user's current screen
    static func setScreenName(_ name: String) {
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: name)
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    // MARK - Analytics Events
    // Useful tool to easily create and send events to Google Analytics
    private static func sendGAEvent(withCategory: String!, action: String!, label: String!, value: NSNumber!) {
        let event: GAIDictionaryBuilder = GAIDictionaryBuilder.createEvent(withCategory: withCategory, action: action, label: label, value: value) // Create event
        let build = (event.build() as NSDictionary) as! [AnyHashable: Any] // Build and cast as correct type
        
        // Print statement feedback
        var printStatement: String = "\(withCategory): \"\(action)\""
        if label != nil {
            printStatement += " with label \"\(label)\""
        }
        if value != nil {
            printStatement += " with value \"\(value)\""
        }
        print(printStatement)
        
        GATracker.send(build) // Send event
    }
    
    /********** Onboarding **********/
    // First time app is launched
    static func firstLaunch() {
        sendGAEvent(withCategory: Categories.onboarding, action: "User Launched App for First Time", label: nil, value: nil)
    }
    
    // Completed onboarding
    static func completedOnboarding(duration seconds: Int) {
        let value: NSNumber = NSNumber(integerLiteral: seconds) // Convert to NSNumber
        sendGAEvent(withCategory: Categories.onboarding, action: "User Completed Onboarding", label: nil, value: value) // Create and send event
    }
    
    // Exited mid onboarding
    static func exitedOnboarding() {
        
    }
    
    // Launched onboarding from manage categories screen
    static func onboardingFromCategoryEditing() {
        sendGAEvent(withCategory: Categories.onboarding, action: "User Entered Onboarding from Category Management Screen", label: nil, value: nil) // Create and send event
    }
    
    /********** Permissions **********/
    // If calendar permission is approved
    static func calendarPermissionGranted() {
        var label: String? = nil
        if let firstLaunch = Constants.defaults.object(forKey: Keys.firstLaunchDate) {
            let timeSinceFirstLaunch: TimeInterval = Date().timeIntervalSince(firstLaunch as! Date)
            print(timeSinceFirstLaunch)
            label = "Time since app was first opened: \(timeSinceFirstLaunch.stringFromTimeInterval())"
            print(label)
        }
        sendGAEvent(withCategory: Categories.permissions, action: "Calendar Permission Granted", label: label, value: nil) // Create and send event
    }
    
    // Calendar permission denied
    static func calendarPermissionDenied() {
        
    }
    
    // If location permission is approved
    static func locationPermissionGranted() {
        
    }
    
    // Location permission denied
    static func locationPermissionDenied() {
        
    }
    
    // Allowed calendar access but not location access
    static func calendarAccessNoLocationAccess() {
        
    }
    
    /********** Force Touch Shortcuts **********/
    // Adding category event with shortcut
    static func shortcutCreateWithCategory() {
        
    }
    
    // Adding event with shortcut no category
    static func shortcutCreateNoCategory() {
        sendGAEvent(withCategory: Categories.shortcuts, action: "Used Force Touch Shortcut", label: "No Category", value: nil)
    }
    
    static func userTurnedOffCalenderPermissionAfterOnboarding() {
        sendGAEvent(withCategory: Categories.authentication, action: "Showing Calendar Authentication Error Screen", label: "User turned off calendar permission sometime after onboarding", value: nil)
    }
    
    /********** Event Creation **********/
    // New event with category: how long it took to make that event and if they used a force touch shortcut
    static func createdEventWithCategory(duration seconds: Int, withShortcut: Bool) {
        var label: String? = nil
        if withShortcut {
            label = "With Force Touch Shortcut"
        }
        sendGAEvent(withCategory: Categories.createdEvent, action: "Created Event With Category", label: label, value: seconds as NSNumber!)
    }
    
    // Created event without category attached: how long it took to make that event and if they used a force touch shortcut
    static func createdEventNoCategory(duration seconds: Int, withShortcut: Bool) {
        var label: String? = nil
        if withShortcut {
            label = "With Force Touch Shortcut"
        }
        sendGAEvent(withCategory: Categories.createdEvent, action: "Created Event Without Category", label: label, value: seconds as NSNumber!)
    }
    
    // User cancelled creation of event
    static func cancelledEventCreation(duration seconds: Int, withShortcut: Bool) {
        var label: String? = nil
        if withShortcut {
            label = "With Force Touch Shortcut"
        }
        sendGAEvent(withCategory: Categories.createdEvent, action: "Cancelled Event Creation", label: label, value: seconds as NSNumber!)
    }
    
    /********** Category Management **********/
    // Created new category and log the name of the category
    static func createdCategory(with name: String) {
        sendGAEvent(withCategory: Categories.categoryManagement, action: "Created New Category", label: name, value: nil)
    }
    
    // Deleted a category
    static func deletedCategory(name: String) {
        sendGAEvent(withCategory: Categories.categoryManagement, action: "Deleted Category", label: name, value: nil)
    }
    
    // Changed the order of categories
    static func modifiedCategoryOrder() {
        sendGAEvent(withCategory: Categories.categoryManagement, action: "Modified Category Order", label: nil, value: nil)
    }
    
    // Renamed a category
    static func renamedCategory(name: String) {
        let label = "Renamed to: " + name
        sendGAEvent(withCategory: Categories.categoryManagement, action: "Renamed Category", label: label, value: nil)
    }
    
    // Reset category history for a single category
    static func resetCategoryPredictions(name: String, totalPrediction: Int) {
        let label = "Category name: " + name
        sendGAEvent(withCategory: Categories.categoryManagement, action: "Reset Category Predictions", label: label, value: totalPrediction as NSNumber!)
    }
    
    // Removed an event name prediction from category history
    static func removedNamePrediction() {
        sendGAEvent(withCategory: Categories.categoryManagement, action: "Removed Event Name Prediction", label: nil, value: nil)
    }
    
    // Removed a location prediction from category history
    static func removedLocationPrediction() {
        sendGAEvent(withCategory: Categories.categoryManagement, action: "Removed Location Prediction", label: nil, value: nil)
    }
}
