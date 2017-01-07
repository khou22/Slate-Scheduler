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
    
    func saveEvent(event: EKEvent) {
        do {
            try self.eventStore.save(event, span: .thisEvent) // Try to add to calendar
            
            print("Event added successfully")
        } catch {
            print("Event could not be added")
        }
    }
    
    func getEvents(day: Date) -> [EKEvent] {
        let start: Date = day.dateWithoutTime() // Current day
        let end: Date = start.addingTimeInterval(24.0 * 60.0 * 60.0) // Exactly one day after
        let calendars: [EKCalendar] = eventStore.calendars(for: .event) // For all calendars
        let predicate: NSPredicate = eventStore.predicateForEvents(withStart: start, end: end, calendars: calendars)
        let events: [EKEvent] = self.eventStore.events(matching: predicate) // Return events
        print("Retrieved \(events.count) events")
        return events
    }
}
