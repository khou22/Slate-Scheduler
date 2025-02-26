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
    static let numQuickDays: Int = 24 // Total number available
    static let quickDaysShown: Int = 6 // Number shown initially, no scroll
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
    @IBOutlet weak var allDaySwitch: UISwitch!
    
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
    
    // Map manager
    let placesManager: GooglePlacesManager = GooglePlacesManager()
    
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
        self.startTimeSlider.stepValue = 0.25 // Every quarter hour
        self.startTimeSlider.maximumValue = self.startTimeSlider.maximumValue + data.sliderOffset(raw: Float(self.startTimeSlider.roundValue()))
        
        // Autocomplete setup
        self.eventNameInput.nextTextField = self.locationInput // Setup next input
        self.eventNameInput.updateCompletion = { // Completion handler when text changes
//            print("Updating event name: \(self.eventNameInput.text)")
            data.event.name = self.eventNameInput.text! // Update
        }
        
        self.locationInput.nextTextField = self.roomInput // Next input
//        self.locationInput.filterResults = false // Don't filter out mismatch search queries becaues maps query already does that
        let radius = DataManager.locationServicesEnabled() ? 2.0 : 20000000.0; // If no location service, cover entire world
        placesManager.setLocationBiasing(location: DataManager.getLatestLocation(), radius: radius) // Set location biasing to encompass the continent
        self.locationInput.updateCompletion = { // Completion handler when text changes
//            print("Updating location: \(self.locationInput.text)")
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
        self.startTimeLabel.text = data.formatTimeLabel() // Update
        
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
        allDaySwitch.isOn = data.event.allDay
        self.durationLabel.text = data.formatDurationLabel() // Real time rounded value of slider
        self.startTimeLabel.text = data.formatTimeLabel()
        
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
//        print("Enquing query: \(query)")
        if (query != "") { // If text exists
            _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.filterLocationRequest), userInfo: query, repeats: false)
        } else { // If no text
            self.locationInput.updateSuggestions(prioritized: data.meta.category.orderedLocations()) // Use previous locations
            self.locationInput.valueChanged() // Force update
        }
        
        data.updateEventLocation(location: query)
    }
    
    @objc func filterLocationRequest(_ timer: Timer) {
        let query: String = timer.userInfo as! String
        if (self.locationInput.text == query && self.locationInput.isFirstResponder) { // If the query hasn't changed, user is done typing
//            print("Firing request for: \(query)")
            self.updateLocationSearchResults(query: query) // Update autocomplete
        } else {
//            print("Cancelled request for: \(query)")
        }
    }
    
    @IBAction func roomInputChanged(_ sender: Any) {
        data.updateRoom(room: self.roomInput.text!)
    }
    
    
    // User released the slider
    @IBAction func finishedDragging(_ sender: Any) {
        self.durationSlider.released() // Animate to rounded value
    }
    
    // User dragging slider
    @IBAction func dragging(_ sender: Any) {
        self.allDaySwitch.isOn = false // Set to false
        data.event.allDay = false
        data.event.duration = self.durationSlider.roundValue() * 3600.0 // Store round value in seconds
        self.startTimeLabel.text = data.formatTimeLabel()
        self.durationLabel.text = data.formatDurationLabel() // Real time rounded value of slider
    }
    
    @IBAction func startTimeFinishedDragging(_ sender: Any) {
        self.startTimeSlider.released()
        
        data.event.time = self.startTimeSlider.roundValue() * 3600.0 // Store round value
    }
    
    @IBAction func startTimeDragging(_ sender: Any) {
        self.allDaySwitch.isOn = false // Set to false
        data.event.allDay = false
        self.dismissKeyboard() // Dismiss keyboard if sliding
        
        data.event.time = self.startTimeSlider.roundValue() * 3600.0 // Change global variable
        
        self.startTimeLabel.text = data.formatTimeLabel()
        self.durationLabel.text = data.formatDurationLabel()
    }
    
    // Updated the all day switch
    @IBAction func updatedAllDay(_ sender: Any) {
        data.event.allDay = allDaySwitch.isOn // Update global
        
        // Update labels
        self.startTimeLabel.text = data.formatTimeLabel()
        self.durationLabel.text = data.formatDurationLabel()
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
        
//        print("Selected\(data.event.date)")
        
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
        self.roomInput.addKeyboardBar()
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
        let cellWidth: CGFloat = (ScreenSize.screen_width - 20) / (self.cellsPerSection) // Formatting the width of each cell
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
