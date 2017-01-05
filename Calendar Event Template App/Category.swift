//
//  Category.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/4/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//
//  Will be a dictionary of categories


import Foundation

class Category: CustomStringConvertible {
    
    // Instance variables
    var name: String
    
    // Constructor
    init(name: String) {
        self.name = name
    }
    
    // When printing the category object
    public var description: String {
        return self.name
    }
}
