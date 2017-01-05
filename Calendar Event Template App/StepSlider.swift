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
    
    public var stepValue: Float = 2.0 // Default is by 1
    public var animationTime: Double = 0.25 // Default is 0.25
    
    // Call when released - animate to rounded value
    public func released() {
        let setTo: Float = roundf(value / stepValue) * stepValue
        print(setTo)
        UIView.animate(withDuration: animationTime, animations: { () in
            self.setValue(setTo, animated: true)
        })
    }

}
