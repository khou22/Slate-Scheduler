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
        static let test                 = "Test Category"
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
    static func sendGAEvent(withCategory: String!, action: String!, label: String!, value: NSNumber!) {
        let event: GAIDictionaryBuilder = GAIDictionaryBuilder.createEvent(withCategory: withCategory, action: action, label: label, value: value) // Create event
        let build = (event.build() as NSDictionary) as! [AnyHashable: Any] // Build and cast as correct type
        GATracker.send(build) // Send event
    }
    
    /********** Onboarding **********/
    // Completed onboarding
    static func completedOnboarding(duration seconds: Int) {
        let value: NSNumber = NSNumber(integerLiteral: seconds) // Convert to NSNumber
        sendGAEvent(withCategory: Analytics.Categories.test, action: "User Completed Onboarding", label: nil, value: value) // Create and send event
    }
    
    // Exited mid onboarding
    static func exitedOnboarding() {
        
    }
    
    // Launched onboarding from manage categories screen
    static func onboardingFromCategoryEditing() {
        
    }
    
    /********** Permissions **********/
    // If calendar permission is approved
    static func calendarPermissionGranted() {
        
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
        
    }
    
    /********** Event Creation **********/
    // New event with category: how long it took to make that event and if they used a force touch shortcut
    static func createdEventWithCategory(duration seconds: Int, with shortcut: Bool) {
        
    }
    
    // Created event without category attached: how long it took to make that event and if they used a force touch shortcut
    static func createdEventNoCategory(duration seconds: Int, with shortcut: Bool) {
        
    }
    
    // User cancelled creation of event
    static func cancelledEventCreation() {
        
    }
    
    /********** Category Management **********/
    // Created new category and log the name of the category
    static func createdCategory(with name: String) {
        
    }
    
    // Deleted a category
    static func deletedCategory() {
        
    }
    
    // Renamed a category
    static func renamedCategory() {
        
    }
    
    // Reset category history for a single category
    static func resetCategoryPredictions() {
        
    }
    
    // Removed an event name prediction from category history
    static func removedNamePrediction() {
        
    }
    
    // Removed a location prediction from category history
    static func removedLocationPrediction() {
        
    }
}
