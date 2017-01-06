//
//  EventDetails.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/4/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import UIKit

class EventDetails: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Navigation buttons
    @IBOutlet weak var saveButton: UIButton!
    
    // Form inputs
    @IBOutlet weak var eventNameInput: UITextField!
    @IBOutlet weak var durationSlider: StepSlider!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var startTimeSlider: StepSlider!
    @IBOutlet weak var startTimeLabel: UILabel!
    
    // Quick day picker
    @IBOutlet weak var quickDayPicker: UICollectionView!
    let numQuickDays: Int = 5 // Can quickly pick 5 days
    var weekdayLabels: [String] = ["Today", "Tomorrow", "Monday", "Tuesday", "Wednesday"] // Starting values, only modify last three
    var dayLabels: [String] = ["1", "2", "3", "4", "5"] // Starting values, modify all
    
    var category: Category = Category(name: "NA")
    
    override func viewDidLoad() {
        print("Creating event with category: " + self.category.name)
        
        // Calculate labels
        self.refreshQuickDay()
        
        self.hideKeyboardOnTap() // Hide keyboard when tapped away
        
        // Styling
        saveButton.backgroundColor = Colors.blue
        
        // Setup start time slider
        self.startTimeSlider.stepValue = 0.5 // Every half hour
    }
    
    @IBAction func cancelEvent(_ sender: Any) {
        dismiss(animated: true, completion: nil) // Exit segue back to category selection
    }
    
    @IBAction func saveEvent(_ sender: Any) {
        print("Saving event")
    }
    
    // User released the slider
    @IBAction func finishedDragging(_ sender: Any) {
        self.durationSlider.released() // Animate to rounded value
    }
    
    // User dragging slider
    @IBAction func dragging(_ sender: Any) {
        self.durationLabel.text = self.durationSlider.roundString() + " hours" // Real time rounded value of slider
    }
    
    @IBAction func startTimeFinishedDragging(_ sender: Any) {
        self.startTimeSlider.released()
    }
    
    @IBAction func startTimeDragging(_ sender: Any) {
        var minutesFromMidnight = self.startTimeSlider.roundValue() * 3600.0 // Minutes from midnight
        minutesFromMidnight += -Double(NSTimeZone.local.secondsFromGMT()) // Apply time zone shift
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        self.startTimeLabel.text = dateFormatter.string(from: Date(timeIntervalSince1970: minutesFromMidnight))
    }
    
    // MARK - Collection cell calls
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numQuickDays
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Cell for each index
        let cell = quickDayPicker.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.quickDayCell, for: indexPath) as! QuickDayPickerCell
        
        // Apply labels
        let index = indexPath.item
        cell.dayLabel.text = dayLabels[index]
        cell.weekdayLabel.text = weekdayLabels[index]
        
        print(dayLabels[index] + ": " + weekdayLabels[index])
        
        return cell
    }
    
    // Calculate the labels for the quick day picker and update global variables
    func calcQuickDays() {
        let today: Date = Date()
        
        // Date formatter to just get date number
        let dayNumberFormatter = DateFormatter()
        dayNumberFormatter.dateFormat = "d" // Day number ie. '2/1/17' -> '1'
        
        // Date formatter to just get day of week
        let dayOfWeekFormatter = DateFormatter()
        dayOfWeekFormatter.dateFormat = "EEE" // 3 letter abbreviation of weekday
        
        for index in 0..<numQuickDays {
            let currentDate = today.addingTimeInterval(24 * 60 * 60 * Double(index)) // Add x number of days
            
            self.dayLabels[index] = dayNumberFormatter.string(from: currentDate) // Set date number
            
            if (index > 1) { // Exclude the first two days
                self.weekdayLabels[index] = dayOfWeekFormatter.string(from: currentDate) // Set day of week
            }
        }
        
        print("Calculated quick days")
    }
    
    func refreshQuickDay() {
        self.calcQuickDays() // Calculate quick days
        
        // Refresh collection view
        DispatchQueue.main.async {
            self.quickDayPicker.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        print("Selected item: " + self.weekdayLabels[index])
    }
}
