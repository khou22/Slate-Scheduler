//
//  EventDetails.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/4/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import UIKit
import EventKit

// Global variables
struct EventDetailsData {
    static let numQuickDays: Int = 20 // Total number available
    static let quickDaysShown: Int = 5 // Number shown initially, no scroll
}

class EventDetails: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
    
    // Form inputs
    @IBOutlet weak var eventNameInput: AutocompleteTextField!
    @IBOutlet weak var locationInput: AutocompleteTextField!
    @IBOutlet weak var roomInput: UITextField!
    @IBOutlet weak var durationSlider: StepSlider!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var startTimeSlider: StepSlider!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // Quick day picker
    @IBOutlet weak var quickDayPicker: UICollectionView!
    let numQuickDays: Int = EventDetailsData.numQuickDays // Can quickly pick 5 days
    var weekdayLabels: [String] = [String](repeating: "1", count: EventDetailsData.numQuickDays) // Initialize arrays of fixed-length
    var dayLabels: [String] = [String](repeating: "1", count: EventDetailsData.numQuickDays)
    var dateOptions: [Date] = [Date](repeating: Date(), count: EventDetailsData.numQuickDays)
    let cellsPerSection: CGFloat = CGFloat(EventDetailsData.quickDaysShown) // 5 quick days shown
    let cellHeight: CGFloat = 50.0 // Constant cell height (50 is default)
    
    // Calendar list view
    @IBOutlet weak var eventListTable: UITableView!
    var daysEvents: [EKEvent] = [] // Empty
    
    // Instance of calendar manager
    let calendarManager: CalendarManager = CalendarManager()
    
    // Constraints to be modified
    @IBOutlet weak var formItemsLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var formItemsRightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var viewCalendarButton: UIButton!
    
    override func viewDidLoad() {
        self.showCalendarErrorScreen() // Check calendar permission and show error screen if needed
        
        self.adjustForScreenSizes() // Adjust constraints for screen sizes
        self.refreshQuickDay() // Calculate labels
        self.hideKeyboardOnSwipe() // Initialize hide keyboard when tapped away
        
        // Setup horizontal scrolling
        let horizontalScroll = UICollectionViewFlowLayout() // Initialize
        horizontalScroll.scrollDirection = .horizontal // Horizontal
        self.quickDayPicker.collectionViewLayout = horizontalScroll // Apply to view
        
        // Set initial selection for quick day picker view
        self.updateDateLabel() // Update for initial frontend
        
        // Refresh collection view
        DispatchQueue.main.async {
            self.quickDayPicker.reloadData()
        }
        
        // Setup start time slider
        self.startTimeSlider.stepValue = 0.5 // Every half hour
        
        // Autocomplete setup
        self.eventNameInput.nextTextField = self.locationInput // Setup next input
        self.eventNameInput.updateCompletion = { // Completion handler when text changes
            print("Updating event name: \(self.eventNameInput.text)")
            data.event.name = self.eventNameInput.text! // Update
        }
        
        self.locationInput.nextTextField = self.roomInput // Next input
        self.locationInput.updateCompletion = { // Completion handler when text changes
            print("Updating location: \(self.locationInput.text)")
            data.event.location = self.locationInput.text! // Update
        }
        
        // Setup table view if for category
        if (!data.meta.noCategory) {
            self.eventNameInput.setupTableView(view: self.view)
            
            self.locationInput.updateSuggestions(prioritized: data.meta.category.orderedLocations()) // Load previous locations
            self.eventNameInput.updateSuggestions(prioritized: data.meta.category.orderedEventNames()) // Load autocomplete suggestions
        }
        
        // Setup autocomplete table view for location search
        self.locationInput.setupTableView(view: self.view)
        
        // Initial population of event list
        self.refreshDaysEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Populate event time label
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        self.startTimeLabel.text = dateFormatter.string(from: Date(timeIntervalSince1970: data.event.time-Double(NSTimeZone.local.secondsFromGMT())))
        
        // Auto focus on event name input if it's empty
        if (self.eventNameInput.text == "") {
            self.eventNameInput.becomeFirstResponder()
        }
        setInitialStates()
    }
    
    override func viewDidLayoutSubviews() {
        self.styleTextInput() // Must be called after autolayout complete
        self.navigationController?.navigationBar.alpha = 0 // Hide navigation bar
    }
    
    // For syncing with data structur
    func setInitialStates() {
//        print("(Initial states 1) Time: \(data.event.time). Duration: \(data.event.duration)")
        
        // Time and duration
        startTimeSlider.value = Float(data.event.time / 3600.0)
        durationSlider.value = Float(data.event.duration / 3600.0)
        self.durationLabel.text = self.durationSlider.roundString() + " hours" // Real time rounded value of slider
        var minutesFromMidnight = self.startTimeSlider.roundValue() * 3600.0 // Minutes from midnight
        minutesFromMidnight += -Double(NSTimeZone.local.secondsFromGMT()) // Apply time zone shift
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        self.startTimeLabel.text = dateFormatter.string(from: Date(timeIntervalSince1970: minutesFromMidnight))
        
        // Date
        self.updateDateLabel() // Update frontend
        for (index, date) in dateOptions.enumerated() {
            if (data.event.date.compare(date) == .orderedSame) { // See if you can highlight one in the day picker
                self.quickDayPicker.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: UICollectionViewScrollPosition.left)
            } else {
                self.quickDayPicker.deselectItem(at: IndexPath(item: index, section: 0), animated: false)
            }
        }
        DispatchQueue.main.async { // Update in background
            self.refreshDaysEvents() // Update event list
        }
        
    }
    
    // Location input changed
    @IBAction func locationInputChanged(_ sender: Any) {
        let query: String = self.locationInput.text!
        if (query != "") { // If text exists
            self.updateLocationSearchResults(query: query) // Update autocomplete
        } else { // If no text
            self.locationInput.updateSuggestions(prioritized: data.meta.category.orderedLocations()) // Use previous locations
            self.locationInput.valueChanged() // Force update
        }
        
        data.updateEventLocation(location: query)
    }
    
    // Room input changed
    @IBAction func roomNumberChanged(_ sender: Any) {
        data.event.room = self.roomInput.text!
    }
    
    // User released the slider
    @IBAction func finishedDragging(_ sender: Any) {
        self.durationSlider.released() // Animate to rounded value
    }
    
    // User dragging slider
    @IBAction func dragging(_ sender: Any) {
        self.durationLabel.text = self.durationSlider.roundString() + " hours" // Real time rounded value of slider
        
        data.event.duration = self.durationSlider.roundValue() * 3600.0 // Store round value in seconds
    }
    
    @IBAction func startTimeFinishedDragging(_ sender: Any) {
        self.startTimeSlider.released()
        
        data.event.time = self.startTimeSlider.roundValue() * 3600.0 // Store round value
    }
    
    @IBAction func startTimeDragging(_ sender: Any) {
        self.dismissKeyboard() // Dismiss keyboard if sliding
        
        var minutesFromMidnight = self.startTimeSlider.roundValue() * 3600.0 // Minutes from midnight
        
        data.event.time = minutesFromMidnight // Change global variable
        
        // Compensate for time zone
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
        
        return cell
    }
    
    // Handle cell selection
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        data.event.date = self.dateOptions[index] // Update the event date
        self.updateDateLabel() // Update frontend
        
        print("Selected\(data.event.date)")
        
        self.dismissKeyboard() // Dismiss keyboard if press a day
        
        // Update in background
        DispatchQueue.main.async {
            self.refreshDaysEvents() // Update event list
        }
    }
    
    func styleTextInput() {
        // Just bottom border
        self.eventNameInput.addBottomBorder()
        self.locationInput.addBottomBorder()
        self.roomInput.addBottomBorder()
        self.roomInput.addDoneButtonOnKeyboard()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == self.roomInput) { // On room number
            self.dismissKeyboard() // Hide keyboard
        }
        return true
    }
    
    // MARK - UICollectionViewDelegateFlowLayout
    // Declare size of quick day picker cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = ScreenSize.screen_width / (self.cellsPerSection + 2) // Add 2 for spacing
        return CGSize(width: cellWidth, height: self.cellHeight)
    }
    
    // MARK - UITableView
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
    
    func adjustForScreenSizes() {
        if DeviceTypes.iPhoneSE || DeviceTypes.iPhone7Zoomed {
            // Change constraint constants, etc. here
            self.formItemsLeftConstraint.constant = 0
            self.formItemsRightConstraint.constant = 0
            
            // Fix autocomplete positioning
            self.eventNameInput.padding = 25 // Move event name autocomplete table lower
            self.locationInput.padding = 25 // Move event name autocomplete table lower
            
            view.layoutIfNeeded()
            
        } else {
            
        }
    }
    
    @IBAction func viewCalendar(_ sender: Any) {
        segueToViewCalendar()
    }
    
    func segueToViewCalendar() {
        self.performSegue(withIdentifier: SegueIdentifiers.viewCalendar, sender: self)
    }
}
