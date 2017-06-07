//
//  EventDetailsMore.swift
//  Slate Calendar
//
//  Created by Kevin Hou on 6/3/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import UIKit
import CalendarKit
import EventKit
import DateToolsSwift

class EventDetailsMore: DayViewController {
    
    var calendarManager = CalendarManager()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Return an array of EventDescriptors for particular date
    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        var models = self.calendarManager.getEvents(day: date.dateWithoutTime()) // Get events (models) from the storage / API
        
        var events = [Event]()
        
        for model in models {
            // Create new EventView
            let event = Event()
            // Specify TimePeriod
            let datePeriod = TimePeriod(beginning: model.startDate, end: model.endDate)
            event.datePeriod = datePeriod
            // Add info: event title, subtitle, location to the array of Strings
            var info = [model.title, model.location]
            info.append("\(datePeriod.beginning!.format(with: "HH:mm")) - \(datePeriod.end!.format(with: "HH:mm"))")
            
            // Set "text" value of event by formatting all the information needed for display
            event.text = info.reduce("", {_,_ in info[0]! + info[1]! + "\n"})
            events.append(event)
        }
        
        return events
    }
    
    // MARK: DayViewDelegate
    
    override func dayViewDidSelectEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? Event else {
            return
        }
        print("Event has been selected: \(descriptor) \(String(describing: descriptor.userInfo))")
    }
    
    override func dayViewDidLongPressEventView(_ eventView: EventView) {
        guard let descriptor = eventView.descriptor as? Event else {
            return
        }
        print("Event has been longPressed: \(descriptor) \(String(describing: descriptor.userInfo))")
    }
    
    override func dayView(dayView: DayView, willMoveTo date: Date) {
        //    print("DayView = \(dayView) will move to: \(date)")
    }
    
    override func dayView(dayView: DayView, didMoveTo date: Date) {
        //    print("DayView = \(dayView) did move to: \(date)")
    }
}

