//
//  EventDetailsMore.swift
//  Slate Calendar
//
//  Created by Kevin Hou on 6/3/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import UIKit
import EventKit

class EventDetailsMore: UIViewController, UITableViewDelegate, UITableViewDataSource, MonthDayPickerDelegate {
    
    @IBOutlet weak var dayPicker: MonthDayPicker!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var eventListTable: UITableView!
    var daysEvents: [EKEvent] = [] // Start empty
    let calendarManager: CalendarManager = CalendarManager() // Instance of calendar manager
    
    @IBOutlet weak var timeSlider: StepSlider!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var durationSlider: StepSlider!
    @IBOutlet weak var durationLabel: UILabel!
    
    @IBOutlet weak var allDaySwitch: UISwitch!
    
    override func viewDidLoad() {
        dayPicker.delegate = self // Set delegate to self
        
        self.timeSlider.stepValue = 0.25 // Rounds to quarter hour
        self.timeSlider.maximumValue = self.timeSlider.maximumValue + data.sliderOffset(raw: Float(self.timeSlider.roundValue())) // Fix offset
    }

    override func viewWillAppear(_ animated: Bool) {
        setInitialStates() // Sync with data struct
    }
    
    func setInitialStates() {
        timeSlider.value = Float(data.event.time / 3600.0)
        durationSlider.value = Float(data.event.duration / 3600.0)
        allDaySwitch.isOn = data.event.allDay
        timeLabel.text = data.formatTimeLabel()
        durationLabel.text = data.formatDurationLabel()
        dayPicker.setDate(date: data.event.date)
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
    
    @IBAction func updatedAllDay(_ sender: Any) {
        data.event.allDay = allDaySwitch.isOn // Make global change
        
        // Push frontend changes
        timeLabel.text = data.formatTimeLabel() // Update frontend
        durationLabel.text = data.formatDurationLabel()
    }

    func updateTime() {
        let minutesFromMidnight = timeSlider.roundValue() * 3600.0 // Minutes from midnight
        data.event.time = minutesFromMidnight // Change global variable
        allDaySwitch.isOn = false
        data.event.allDay = false
        timeLabel.text = data.formatTimeLabel() // Update frontend
        durationLabel.text = data.formatDurationLabel()
    }
    
    func updateDuration() {
        data.event.duration = self.durationSlider.roundValue() * 3600.0 // Store round value in seconds
        allDaySwitch.isOn = false
        data.event.allDay = false
        durationLabel.text = data.formatDurationLabel() // Real time rounded value of slider
        timeLabel.text = data.formatTimeLabel()
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

    @IBAction func backToMain(_ sender: Any) {
        self.navigationController?.popViewController(animated: true) // Go back to previous page
    }
}

