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
    // Useful tool: http://stackoverflow.com/questions/35215694/format-timer-label-to-hoursminutesseconds-in-swift
    func stringFromTimeInterval() -> String {
        let hours = self / 3600
        let minutes = (self / 60).truncatingRemainder(dividingBy: 60.0)
        let seconds = self.truncatingRemainder(dividingBy: 60.0)
        return String(format:"%02i hours, %02i minutes, %02i seconds", hours, minutes, seconds)
    }

}
