//
//  StepSlider.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/4/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//
//  Custom UISlider class to round values

import UIKit

class StepSlider: UISlider {
    
    public var stepValue: Float = 0.25 // Default is by 1
    private var animationTime: Double = 0.25 // Default is 0.25
    
    // Call when released - animate to rounded value
    public func released() {
        let setTo: Float = roundf(value / stepValue) * stepValue
        UIView.animate(withDuration: animationTime, animations: { () in
            self.setValue(setTo, animated: true)
        })
    }
    
    // Return the string representation of the rounded value
    public func roundString() -> String {
        let rounded: Float = roundf(value / stepValue) * stepValue
        
        // Convert float to human-readable string
        let format = NSString(format: "%.1f", rounded) // Return number with one decimal place
        
        return format as String // Return string value
    }

    // Return just the value
    public func roundValue() -> Double {
        return Double(roundf(value / stepValue) * stepValue)
    }

}
