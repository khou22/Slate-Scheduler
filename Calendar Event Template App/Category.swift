//
//  Category.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/4/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//
//  Encode object when saving to NSUserDefaults
//  Source: http://stackoverflow.com/questions/29986957/save-custom-objects-into-nsuserdefaults


import Foundation

class Category: NSObject, NSCoding {
    
    // Instance variables
    var name: String
    var timesUsed: Int // Number of times the category has been used to create an event
    var eventNameFreq: [ String : Int ] // Frequency dictionary
    var locationFreq: [ String : Int ] // Frequency dictionary
    
    // Constructor
    init(name: String, timesUsed: Int, eventNameFreq: [ String : Int ], locationFreq: [String : Int ]) {
        self.name = name
        self.timesUsed = timesUsed
        self.eventNameFreq = eventNameFreq
        self.locationFreq = locationFreq
    }
    
    /*
    // When printing the category object
    public var description: String {
        return self.name
    }*/
    
    // Decoding all instance variables when retrieving
    required convenience init(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: Keys.categoryName) as! String
        let timesUsed = aDecoder.decodeInteger(forKey: Keys.categoryTimesUsed) as! Int
        let eventNameFreq = aDecoder.decodeObject(forKey: Keys.eventNameFreq) as! [ String : Int ]
        let locationFreq = aDecoder.decodeObject(forKey: Keys.locationFrequency) as! [ String : Int ]
        
        // Creating a new object but with the same values
        self.init(name: name, timesUsed: timesUsed, eventNameFreq: eventNameFreq, locationFreq: locationFreq)
    }
    
    // Encode all instance variables when storing
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: Keys.categoryName)
        aCoder.encode(timesUsed, forKey: Keys.categoryTimesUsed)
        aCoder.encode(eventNameFreq, forKey: Keys.eventNameFreq)
        aCoder.encode(locationFreq, forKey: Keys.locationFrequency)
    }
    
    func orderedEventNames() -> [String] {
        var orderedEventNames: [String] = []
        
        // Convert to arrays
        var keys: [String] = []
        var values: [Int] = []
        for (key, value) in self.eventNameFreq {
            keys.append(key)
            values.append(value)
        }
        
        // Sort by frequency
        while (keys.count != 0) {
            
            // Track highest frequency then add to master list
            var highest: Int = 0
            var highestIndex: Int = 0
            for (index, _) in keys.enumerated() {
                let currentFreq = values[index]
                if (currentFreq > highest) {
                    // Set a new high
                    highest = currentFreq
                    highestIndex = index
                }
            }
            
            // Add to master list and remove from originals
            orderedEventNames.append(keys[highestIndex]) // Add to master list
            keys.remove(at: highestIndex) // Remove so won't be used again
            values.remove(at: highestIndex) // Remove so won't be used again
        }
        
        return orderedEventNames // Return the master list
    }
    
    func orderedLocations() -> [String] {
        var orderedLocations: [String] = []
        
        // Convert to arrays
        var keys: [String] = []
        var values: [Int] = []
        for (key, value) in self.locationFreq {
            keys.append(key)
            values.append(value)
        }
        
        // Sort by frequency
        while (keys.count != 0) {
            
            // Track highest frequency then add to master list
            var highest: Int = 0
            var highestIndex: Int = 0
            for (index, _) in keys.enumerated() {
                let currentFreq = values[index]
                if (currentFreq > highest) {
                    // Set a new high
                    highest = currentFreq
                    highestIndex = index
                }
            }
            
            // Add to master list and remove from originals
            orderedLocations.append(keys[highestIndex]) // Add to master list
            keys.remove(at: highestIndex) // Remove so won't be used again
            values.remove(at: highestIndex) // Remove so won't be used again
        }
        
        return orderedLocations // Return the master list
    }
}
