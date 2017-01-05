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
            print(data)
            let encoded = data as! NSMutableArray // Retrieve data object
            return decode(array: encoded) // Unarchive and return
        } else {
            // If no data logged before
            return []
        }
    }
    
    /************ Writing Data ************/
    static func newCategory(category: Category) {
        // Get category data if data exists
        if let data = Constants.defaults.object(forKey: Keys.categoryData) { // Data exists
            
            print("Updating...")
            var encoded = data as! NSMutableArray // Retrieve data object
            var decoded: [Category] = decode(array: encoded) // Decoded items
            
            // Update data set
            decoded.append(category) // Append new item
            
            encoded = encode(category: decoded) // Archive
            
            // Store updated data
            Constants.defaults.setValue(encoded, forKey: Keys.categoryData)
            Constants.defaults.synchronize()
            
            print("Updated category data")
        } else {
            print("Creating...")
            // If no data logged before, add array of single category
            let encodedData = encode(category: [category]) // Encode data
            Constants.defaults.set(encodedData, forKey: Keys.categoryData)
            Constants.defaults.synchronize()
            print("Updated category data")
        }
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
}
