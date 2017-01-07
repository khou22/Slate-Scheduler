//
//  CalendarManager.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/6/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//
//  Handles all communication with iOS calendar

import Foundation
import EventKit

class CalendarManager {
    
    var eventStore: EKEventStore = EKEventStore()
    
    // Request access to read and add calendar events
    func requestAccess() {
        self.eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (error != nil) {
                print("Error \(error)")
            } else {
                print("Granted access \(granted)")
            }
        })
    }
}
