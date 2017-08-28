//
//  EventDetailsMore.swift
//  Slate Calendar
//
//  Created by Kevin Hou on 6/3/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import UIKit
import EventKit

class EventDetailsMore: UIViewController, UITableViewDelegate, UITableViewDataSource, DayPickerDelegate {
    
    @IBOutlet weak var dayPicker: DayPicker!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var eventListTable: UITableView!
    var daysEvents: [EKEvent] = [] // Start empty
    let calendarManager: CalendarManager = CalendarManager() // Instance of calendar manager
    
    @IBOutlet weak var timeSlider: StepSlider!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var durationSlider: StepSlider!
    @IBOutlet weak var durationLabel: UILabel!
    
    override func viewDidLoad() {
        dayPicker.delegate = self // Set delegate to self
    }

    override func viewWillAppear(_ animated: Bool) {
        setInitialStates() // Sync with data struct
    }
    
    func setInitialStates() {
        print("(Initial states 2) Time: \(data.event.time). Duration: \(data.event.duration)")
        timeSlider.value = Float(data.event.time / 3600.0)
        durationSlider.value = Float(data.event.duration / 3600.0)
        updateTime()
        updateDuration()
    }
    
    @IBAction func draggingTime(_ sender: Any) {
        updateTime()
    }
    
    @IBAction func releasedTime(_ sender: Any) {
        timeSlider.released()
        updateTime()
    }
    
    @IBAction func draggingDuration(_ sender: Any) {
        updateDuration()
    }
    
    @IBAction func releasedDuration(_ sender: Any) {
        durationSlider.released()
        updateDuration()
    }
    
    func updateTime() {
        var minutesFromMidnight = timeSlider.roundValue() * 3600.0 // Minutes from midnight
        data.event.time = minutesFromMidnight // Change global variable
        
        // Compensate for time zone
        minutesFromMidnight += -Double(NSTimeZone.local.secondsFromGMT()) // Apply time zone shift
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        timeLabel.text = dateFormatter.string(from: Date(timeIntervalSince1970: minutesFromMidnight))
    }
    
    func updateDuration() {
        durationLabel.text = self.durationSlider.roundString() + " hours" // Real time rounded value of slider
        data.event.duration = self.durationSlider.roundValue() * 3600.0 // Store round value in seconds
    }
    
    // MARK - Days Events Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.daysEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Cell for each index
        let cell = eventListTable.dequeueReusableCell(withIdentifier: CellIdentifiers.eventListCell, for: indexPath) as! EventListCell
        
        let index = indexPath.item
        cell.eventName.text = self.daysEvents[index].title
        
        // Time string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a" // Format
        let startDate: Date = self.daysEvents[index].startDate
        let endDate: Date = self.daysEvents[index].endDate
        cell.eventTime.text = dateFormatter.string(from: startDate) + " - \n" + dateFormatter.string(from: endDate) // Concatinate string
        
        //        print(self.daysEvents[index].title)
        
        return cell
    }
    
    func dateChange(date: Date) {
        data.event.date = date // Update struct
        updateDateLabel(newDate: date) // Update label
        refreshDaysEvents()
    }
    
    func refreshDaysEvents() {
        daysEvents = calendarManager.getEvents(day: data.event.date.dateWithoutTime())
        
        // Refresh the table
        DispatchQueue.main.async {
            self.eventListTable.reloadData()
        }
    }
    
    func updateDateLabel(newDate: Date) {
        // Change frontend label
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d" // Format
        self.dateLabel.text = dateFormatter.string(from: newDate) + " at" // Update label
    }

}

