//
//  AnalyticsManager.swift
//  Slate Calendar
//
//  Created by Kevin Hou on 1/31/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//
//  Google Analytics manager

import Foundation

struct Analytics {
    
    static func setScreenName(_ name: String) {
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: name)
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
}
