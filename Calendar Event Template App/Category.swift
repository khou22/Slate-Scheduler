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
    
    // Constructor
    init(name: String) {
        self.name = name
    }
    
    /*
    // When printing the category object
    public var description: String {
        return self.name
    }*/
    
    required convenience init(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "name") as! String
        self.init(name: name)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
    }
}
