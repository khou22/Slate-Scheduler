//
//  DataManager.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/4/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import MapKit

struct DataManager {
    
    /************ Reading Data ************/
    static func getCategories() -> [Category] {
        // Get category data if data exists
        if let data = Constants.defaults.object(forKey: Keys.categoryData) { // Data exists
            let encoded: NSArray = data as! NSArray // Retrieve data object
//            print("Category count: \(encoded.count)") // Debugging
            return decode(array: encoded.mutableCopy() as! NSMutableArray) // Decoded items
        } else {
            // If no data logged before
            return []
        }
    }
    
    static func getFrequentCategories(num: Int) -> [Category] {
        // Get all categories in order
        let allCategories: [Category] = self.getCategories().sorted()
        
        let subarray: ArraySlice<Category> = allCategories[0..<num] // Slice the array to length
        
        return Array(subarray) // Return slice of array as Array type
    }
    
    static func indexForCategory(categoryName: String) -> Int {
        let allCategories: [Category] = self.getCategories()
        if let index = allCategories.index(where: { $0.name == categoryName }) {
            return index // Return the index if found
        } else { // Can't find index for that category name
            // If can't find category
            return -1
        }
    }
    
    /************ Writing Data ************/
    static func newCategory(category: Category) {
        // Get category data if data exists
        if let data = Constants.defaults.object(forKey: Keys.categoryData) { // Data exists
            
            var encoded: NSArray = data as! NSArray // Retrieve data object
            var decoded: [Category] = decode(array: encoded.mutableCopy() as! NSMutableArray) // Decoded items
            
            // Update data set
            decoded.append(category) // Append new item
            
            encoded = encode(category: decoded) // Archive
            
            // Store updated data
            Constants.defaults.setValue(encoded, forKey: Keys.categoryData)
            Constants.defaults.synchronize()
            
        } else {
            // If no data logged before, add array of single category
            let encodedData = encode(category: [category]) // Encode data
            Constants.defaults.set(encodedData, forKey: Keys.categoryData)
            Constants.defaults.synchronize()
        }
    }
    
    // For when you need to update just one category item (must retain same name) — meant for updating markov models
    static func updateOneCategory(with category: Category, index: Int) {
        
        if let data = Constants.defaults.object(forKey: Keys.categoryData) { // Data exists
            
            var encoded: NSArray = data as! NSArray // Retrieve data object
            var decoded: [Category] = decode(array: encoded.mutableCopy() as! NSMutableArray) // Decoded items
            
            if (decoded[index].name != category.name) { // Warning if index didn't match
                // Likely updating category name
                print("Updated category name")
            }
            
            decoded[index] = category // Update
//            print("Updated category object's data")
            
            encoded = encode(category: decoded) // Archive
            
            // Store updated data
            Constants.defaults.setValue(encoded, forKey: Keys.categoryData)
            Constants.defaults.synchronize()
            
        }
    }
    
    // For when you need to update the order, delete item, etc.
    static func refreshData(with set: [Category]) {
        let encoded = encode(category: set) // Archive
        
        // Complete new set of data
        Constants.defaults.setValue(encoded, forKey: Keys.categoryData)
        Constants.defaults.synchronize()
    }
    
    // Delete all current categories
    static func deleteAllCategories() {
        Constants.defaults.set([], forKey: Keys.categoryData)
        Constants.defaults.synchronize()
    }
    
    // Encode category data so can save in NSUserDefaults
    static func encode(category: [Category]) -> NSMutableArray {
        let dataArray: NSMutableArray = NSMutableArray(capacity: [category].count) // Instantiate array
        
        // Archive each item
        for item in category {
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: item) // Archive
            dataArray.add(encodedData) // Add to array
        }
        
        return dataArray
    }
    
    // Decode NSMutableArray to Array<Category>
    static func decode(array: NSMutableArray) -> [Category] {
        var decodedItems: [Category] = [] // Start with empty array
        
        for item in array {
            let decodedObject: Category = NSKeyedUnarchiver.unarchiveObject(with: item as! Data) as! Category // Unarchive
            decodedItems.append(decodedObject)
        }
        
        return decodedItems
    }
    
    /************ Setup Shortcuts ************/
    // Initialize dynamic 3D touch shortcuts
    static func createShortcuts() {
        // Store shortcuts
        var shortcuts: [UIMutableApplicationShortcutItem] = [] // Empty array
        
        // Get three most used categories
        let topCategories: [Category] = DataManager.getFrequentCategories(num: 3)
        
        for category in topCategories {
            // Create shortcut
            let shortcut = UIMutableApplicationShortcutItem(
                type: "kevinhou.Calendar-Event-Template-App.newCategorizedEvent",
                localizedTitle: category.name,
                localizedSubtitle: nil,
                icon: UIApplicationShortcutIcon(templateImageName: ""), // Dot icon
                userInfo: ["categoryName": category.name])
            
            shortcuts.append(shortcut) // Add to master list
        }
        
        
        // Set the shortcut items
        UIApplication.shared.shortcutItems = shortcuts
    }
    
    /************ User Details ************/
    static func userCompletedOnboarding() {
        Constants.defaults.set(true, forKey: Keys.completedOnboarding)
    }
    
    static func onboardingStatus() -> Bool {
        return Constants.defaults.bool(forKey: Keys.completedOnboarding) // If key doesn't exist, false
    }
    
    static func setLatestLocation(coordinates: CLLocationCoordinate2D) { // Store user's location
        let lat = coordinates.latitude
        let long = coordinates.longitude
        
        // Store values
        Constants.defaults.set(lat, forKey: Keys.userLatitude)
        Constants.defaults.set(long, forKey: Keys.userLongitude)
    }
    
    static func getLatestLocation() -> CLLocationCoordinate2D { // Return user's most recent location
        let lat = Constants.defaults.float(forKey: Keys.userLatitude) // Retrieve values
        let long = Constants.defaults.float(forKey: Keys.userLongitude)
        
        if (lat != 0.0 && long != 0.0) { // If logged a location before
            return CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long)) // Return current location
        } else { // Otherwise use default location constant
            return Constants.defaultLocation
        }
    }
    
    static func locationServicesEnabled() -> Bool { // Determine if location services enabled
        switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied: // Not allowed
//                print("Location services not enabled")
                return false
            case .authorizedAlways, .authorizedWhenInUse: // Allowed
//                print("Location services enabled")
                return true
        }
    }
    
    static func didAskForCalendarAccess() { // Store that asked for calendar access
        Constants.defaults.set(true, forKey: Keys.askedCalendarAccess) // Set as true
    }
    
    static func askedForCalendarAccess() -> Bool { // Return whether asked user for calendar permission yet
        // If never asked, will return false
        return Constants.defaults.bool(forKey: Keys.askedCalendarAccess)
    }
    
    /************ User Settings ************/
    static func setCategoryLabelSetting(value: Bool) {
        Constants.defaults.set(value, forKey: Keys.categoryLabelOnEvents)
    }
    
    static func includeCategoryLabel() -> Bool {
        let value = Constants.defaults.bool(forKey: Keys.categoryLabelOnEvents) // If key doesn't exist, it's false
        return value
    }
    
    static func setReminderTime(time: ReminderTime.identifiers) {
        Constants.defaults.set(time, forKey: Keys.defaultReminderTime) // Save enum value
    }
    
    static func reminderTimeState() -> ReminderTime.identifiers {
        return Constants.defaults.value(forKey: Keys.defaultReminderTime) as! ReminderTime.identifiers // Return the enum value
    }
    
    static func reminderTime() -> Double {
        let timeIdentifier: ReminderTime.identifiers = Constants.defaults.value(forKey: Keys.defaultReminderTime) as! ReminderTime.identifiers // Get enum value
        let time: Double = ReminderTime.values[timeIdentifier]! // Get time for enum identifier
        
        return time // Return time value
    }
}
