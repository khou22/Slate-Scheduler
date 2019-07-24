//
//  AngleHelper.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/26/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//
//  Converting float values between degrees and radians

import Foundation

struct Angles {
    // Convert from degrees to radians
    static let degrees: (_ radians: Float) -> Float = { radians in
        let degrees: Float = (radians * 360.0) / Float(2.0 * .pi)
        return degrees
    }
    
    // Convert from radians to degrees
    static let radians: (_ degrees: Float) -> Float = { degrees in
        let radians: Float = (degrees * Float(2.0 * .pi)) / 360.0
        return radians
    }
}
