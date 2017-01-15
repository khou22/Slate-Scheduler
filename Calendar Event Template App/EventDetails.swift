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
    static let numQuickDays: Int = 10 // Total number available
    static let quickDaysShown: Int = 5 // Number shown initially, no scroll
}

class EventDetails: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
    
    // Navigation buttons
    @IBOutlet weak var saveButton: UIButton!
    
    // Form inputs
    @IBOutlet weak var eventNameInput: UITextField!
    @IBOutlet weak var locationInput: UITextField!
    @IBOutlet weak var durationSlider: StepSlider!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var startTimeSlider: StepSlider!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // Form data
    var eventDate: Date = Date().dateWithoutTime() // Today, but no time
    var eventTime: Double = 11 * 3600.0 // Minutes from midnight
    
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
    
    // Card view
    @IBOutlet weak var summaryCard: UIView!
    @IBOutlet weak var summaryTitle: UILabel!
    @IBOutlet weak var summaryLocation: UILabel!
    @IBOutlet weak var summaryDateTime: UILabel!
    @IBOutlet weak var summaryCardTopConstraint: NSLayoutConstraint!
    var blackFade: UIView = UIView(frame: CGRect(x: 0, y: 0, width: ScreenSize.screen_width, height: ScreenSize.screen_height)) // Covers full screen
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    // Other UI Elements
    @IBOutlet weak var submitConfirmation: UIImageView!
    @IBOutlet weak var submitConfirmationWidth: NSLayoutConstraint!
    @IBOutlet weak var submitConfirmationHeight: NSLayoutConstraint!
    @IBOutlet weak var submitStatusLabel: UILabel!
    
    // Category data
    var category: Category = Category(name: StringIdentifiers.noCategory)
    
    // Instance of calendar manager
    let calendarManager: CalendarManager = CalendarManager()
    
    override func viewDidLoad() {
        self.refreshQuickDay() // Calculate labels
        self.hideKeyboardOnTap() // Initialize hide keyboard when tapped away
        
        // Setup horizontal scrolling
        let horizontalScroll = UICollectionViewFlowLayout() // Initialize
        horizontalScroll.scrollDirection = .horizontal // Horizontal
        self.quickDayPicker.collectionViewLayout = horizontalScroll // Apply to view
        
        // Set initial selection for quick day picker view
        self.updateDateLabel() // Update for initial frontend
        self.quickDayPicker.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: UICollectionViewScrollPosition.left)
        // Refresh collection view
        DispatchQueue.main.async {
            self.quickDayPicker.reloadData()
        }
        
        // Setup start time slider
        self.startTimeSlider.stepValue = 0.5 // Every half hour
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Setup summary card view
        self.setupSummaryCard()
        
        // Auto focus on event name input
        self.eventNameInput.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        self.styleTextInput() // Must be called after autolayout complete
    }
    
    @IBAction func cancelEvent(_ sender: Any) {
        dismiss(animated: true, completion: nil) // Exit segue back to category selection
    }
    
    @IBAction func saveEvent(_ sender: Any) {
        let validInputs: Bool = self.validateParameters() // Ensure that form was filled out correctly
        
        if !validInputs { // If not filled out correctly
            let alert = UIAlertController(title: "Form Incomplete", message: "Please enter an event name", preferredStyle: .alert) // Create alert message
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.eventNameInput.becomeFirstResponder() // Programmably launch keyboard to edit event name
            })) // Add button to dismiss
            self.present(alert, animated: true, completion: nil) // Present alert
        } else {
            // If neccessary inputs filled out correctly
            self.generateCard() // Begin process to add event to calendar
        }
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
        
        return cell
    }
    
    // Handle cell selection
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        self.eventDate = self.dateOptions[index] // Update the event date
        self.refreshDaysEvents() // Update event list
        self.updateDateLabel() // Update frontend
    }
    
    func styleTextInput() {
        // Just bottom border
        self.eventNameInput.addBottomBorder()
        self.locationInput.addBottomBorder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == self.eventNameInput) { // Pressed next
            self.locationInput.becomeFirstResponder() // Move to next input
        } else if (textField == self.locationInput) { // Pressed done
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
    
}
