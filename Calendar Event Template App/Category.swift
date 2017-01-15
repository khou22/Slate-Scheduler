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
    var eventNameFreq: [ String : Int ] // Frequency dictionary
    
    // Constructor
    init(name: String, eventNameFreq: [ String : Int ]) {
        self.name = name
        self.eventNameFreq = eventNameFreq
    }
    
    /*
    // When printing the category object
    public var description: String {
        return self.name
    }*/
    
    // Decoding all instance variables when retrieving
    required convenience init(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: Keys.categoryName) as! String
        let eventNameFreq = aDecoder.decodeObject(forKey: Keys.eventNameFreq) as! [ String : Int ]
        
        // Creating a new object but with the same values
        self.init(name: name, eventNameFreq: eventNameFreq)
    }
    
    // Encode all instance variables when storing
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: Keys.categoryName)
        aCoder.encode(eventNameFreq, forKey: Keys.eventNameFreq)
    }
}
