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
    
    // Form data
    var eventDate: Date = Date().dateWithoutTime() // Today, but no time
    var eventTime: Double = 11 * 3600.0 // Minutes from midnight
    
    // Quick day picker
    @IBOutlet weak var quickDayPicker: UICollectionView!
    let numQuickDays: Int = 5 // Can quickly pick 5 days
    var weekdayLabels: [String] = ["Today", "Tomorrow", "Monday", "Tuesday", "Wednesday"] // Starting values, only modify last three
    var dayLabels: [String] = ["1", "2", "3", "4", "5"] // Starting values, modify all
    var dateOptions: [Date] = [Date(), Date(), Date(), Date(), Date()] // Initialize array of length 5
    var selectedIndex: Int = 0 // Start with today selected
    
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
        self.eventTime = minutesFromMidnight // Change global variable
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
        
        // If this cell is the one selected
        if (self.selectedIndex == index) {
            // Styling for a selected date
            cell.userSelected()
        } else { // If not selected
            cell.userUnselected()
        }
        
//        print(dayLabels[index] + ": " + weekdayLabels[index])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        print(index)
        let previousSelection = self.selectedIndex // Store previous selection
        self.selectedIndex = index // Update what is selected
        self.eventDate = self.dateOptions[index] // Change the event date
        print("Selected item: " + self.weekdayLabels[index])
        
        // Always QuickDayPickerCell types
        let previousSelected = self.quickDayPicker.cellForItem(at: IndexPath(item: previousSelection, section: indexPath.section)) as! QuickDayPickerCell
        let selectedCell = self.quickDayPicker.cellForItem(at: indexPath) as! QuickDayPickerCell
        
        // Update styling
        previousSelected.userUnselected()
        selectedCell.userSelected()
        
        print("update styling")
        
        // Reload to show user feedback
        DispatchQueue.main.async {
            self.quickDayPicker.reloadData()
        }
    }
}
