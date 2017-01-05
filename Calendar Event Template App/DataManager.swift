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
            return data as! [Category]
        } else {
            // If no data logged before
            return []
        }
    }
    
    /************ Writing Data ************/
    static func newCategory(category: Category) {
        // Get category data if data exists
        if let data = Constants.defaults.object(forKey: Keys.categoryData) { // Data exists
            
            // Update data set
            var updated = data as! [Category] // Make sure right type
            updated.append(category) // Append new item
            
            // Store updated data
            Constants.defaults.setValue(updated, forKey: Keys.categoryData)
        } else {
            // If no data logged before, add array of single category
            Constants.defaults.setValue([category], forKey: Keys.categoryData)
        }
    }
}
