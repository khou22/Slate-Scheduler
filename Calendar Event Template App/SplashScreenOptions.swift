//
//  SplashScreenOptions.swift
//  Slate Calendar
//
//  Created by Kevin Hou on 2/13/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation

/// The total animation duration of the splash animation
let kAnimationDuration: TimeInterval = 3.0

/// The length of the second part of the duration
let kAnimationDurationDelay: TimeInterval = 0.5

/// The offset between the AnimatedULogoView and the background Grid
let kAnimationTimeOffset: CFTimeInterval = 0.35 * kAnimationDuration

/// The ripple magnitude. Increase by small amounts for amusement ( <= .2) :]
let kRippleMagnitudeMultiplier: CGFloat = 0.025
