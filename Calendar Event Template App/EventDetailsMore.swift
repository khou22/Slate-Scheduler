//
//  EventDetailsMore.swift
//  Slate Calendar
//
//  Created by Kevin Hou on 6/3/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import UIKit
import EventKit

class EventDetailsMore: UIViewController {
    @IBOutlet weak var timeSlider: StepSlider!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var durationSlider: StepSlider!
    @IBOutlet weak var durationLabel: UILabel!

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
        print("Updated event time: \(data.event.time)")
        
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
}

