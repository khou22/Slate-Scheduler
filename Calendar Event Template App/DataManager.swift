//
//  DataManager.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/4/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation

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
    
    /************ User Details ************/
    static func userCompletedOnboarding() {
        Constants.defaults.set(true, forKey: Keys.completedOnboarding)
    }
    
    static func onboardingStatus() -> Bool {
        return Constants.defaults.bool(forKey: Keys.completedOnboarding) // If key doesn't exist, false
    }
    
    /************ User Settings ************/
    static func setCategoryLabelSetting(value: Bool) {
        Constants.defaults.set(value, forKey: Keys.categoryLabelOnEvents)
    }
    
    static func includeCategoryLabel() -> Bool {
        let value = Constants.defaults.bool(forKey: Keys.categoryLabelOnEvents) // If key doesn't exist, it's false
        return value
    }
}
