//
//  DateExtension.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/6/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//
//  Helpful function extensions of Date class

import Foundation

extension Date {
    
    // Remove the time component of a Date type
    func dateWithoutTime() -> Date {
        let dateFormatter = DateFormatter() // Initialize new Date Formatter
        
        dateFormatter.dateStyle = .medium // Doesn't include time component
        let dateToPrint: NSString = dateFormatter.string(from: self) as NSString // Format into medium style string
        let dateNoTime = dateFormatter.date(from: dateToPrint as String) // Get a date from midnight that day
        
        return dateNoTime! // Return result
    }
    
}

extension TimeInterval {
    
    // Time interval to string
    func toString() -> String {
        let seconds: Int = Int(self.truncatingRemainder(dividingBy: 60.0))
        let minutes: Int = Int((self / 60.0).truncatingRemainder(dividingBy: 60.0))
        let hours: Int = Int(self / 3600)
        let str = "\(hours):\(minutes):\(seconds)"
        
        return str
    }
}
