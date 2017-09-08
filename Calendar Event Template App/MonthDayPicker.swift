//
//  MonthDayPicker.swift
//  Calendar-Component-Library
//
//  Created by Kevin Hou on 8/24/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import UIKit
import EventKit

@objc protocol MonthDayPickerDelegate: class {
    @objc optional func dateChange(date: Date)
}

class MonthDayPicker: UIView, DayTileDelegate {
    
    // Options
    private let sensitivity: CGFloat = 8.0 // X events a day is the peak color
    private let highlightColor = UIColor(colorLiteralRed: 226.0/255.0, green: 111.0/255.0, blue: 80.0/255.0, alpha: 1.0)
    private let colorScheme = UIColor(red: 225.0/255.0, green: 145.0/255.0, blue: 124.0/255.0, alpha: 1.0)
    
    // Colors
    private let lightGrey = UIColor(red: 221.0/255.0, green: 221.0/255.0, blue: 221.0/255.0, alpha: 1.0)
    private let grey = UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 239.0/255.0, alpha: 1.0)
    private let darkGrey = UIColor(red: 60.0/255.0, green: 60.0/255.0, blue: 60.0/255.0, alpha: 1.0)
    
    // Delegate to make sure parent conforms
    weak var delegate: MonthDayPickerDelegate?
    
    // Helper to retrieve calendar events
    private let calendarManager: CalendarManager = CalendarManager()
    
    // Current parameters
    private var selectedIndex: Int = 0
    private var selectedDate: Date = Date().dateWithoutTime() // Default is today
    private var monthAchor: Date = Date().dateWithoutTime() // Anchors the month/year
    
    // Today
    private let currentDate: Date = Date().dateWithoutTime()
    
    // UI Components that will be created on render
    private var leftMonth: UIButton = UIButton()
    private var rightMonth: UIButton = UIButton()
    private var headerLabel: UILabel = UILabel()
    private var tileContainer: UIView = UIView()
    private var tiles: [DayTile] = []
    
    override func draw(_ rect: CGRect) {
        self.backgroundColor = UIColor.white
        
        // Headers
        let header: UIView = createHeader(parent: rect);
        let weekdayHeader: UIView = createWeekdayHeader(frame: CGRect(x: rect.minX, y: header.frame.maxY, width: rect.width, height: 30))
        
        // Construct the container that will house all the tiles
        let headerHeights: CGFloat = header.frame.height + weekdayHeader.frame.height
        let containerFrame: CGRect = CGRect(x: rect.minX, y: rect.minY + headerHeights, width: rect.width, height: rect.height - headerHeights)
        let container: UIView = UIView(frame: containerFrame)
        container.backgroundColor = UIColor.white
        self.tileContainer = container // Set instance variable
        
        self.addSubview(header) // Add header
        self.addSubview(weekdayHeader)
        self.addSubview(container)
        
        // Add swiping gesture functionality
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.previousMonth(sender:)))
        swipeRight.direction = .right
        swipeRight.cancelsTouchesInView = false
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.nextMonth(sender:)))
        swipeLeft.direction = .left
        swipeLeft.cancelsTouchesInView = false
        self.addGestureRecognizer(swipeRight)
        self.addGestureRecognizer(swipeLeft)
        
        // Add the tiles to the container view
        drawDaySquares()
    }
    
    private func createHeader(parent: CGRect) -> UIView {
        // Create the header
        let headerFrame: CGRect = CGRect(x: parent.minX, y: parent.minY, width: parent.width, height: 50)
        let header: UIView = UIView(frame: headerFrame)
        header.backgroundColor = UIColor.white
        
        // Create left/right buttons
        let buttonWidth: CGFloat = 40.0
        let leftFrame = CGRect(x: parent.minX, y: parent.minY, width: buttonWidth, height: headerFrame.height)
        let rightFrame = CGRect(x: parent.maxX - buttonWidth, y: parent.minY, width: buttonWidth, height: headerFrame.height)
        let leftButton: UIButton = UIButton(frame: leftFrame)
        let rightButton: UIButton = UIButton(frame: rightFrame)
        
        leftButton.setTitle("<", for: .normal)
        leftButton.setTitleColor(self.darkGrey, for: .normal)
        leftButton.addTarget(self, action: #selector(self.previousMonth(sender:)), for: .touchUpInside)
        rightButton.setTitle(">", for: .normal)
        rightButton.setTitleColor(self.darkGrey, for: .normal)
        rightButton.addTarget(self, action: #selector(self.nextMonth(sender:)), for: .touchUpInside)
        
        self.leftMonth = leftButton
        self.rightMonth = rightButton
        
        // Create month/year label
        let headerLabelFrame = CGRect(x: leftFrame.maxX, y: parent.minY, width: parent.width - (2 * buttonWidth), height: headerFrame.height)
        let headerLabel: UILabel = UILabel(frame: headerLabelFrame)
        headerLabel.textAlignment = .center
        headerLabel.textColor = self.darkGrey
        headerLabel.font.withSize(22.0) // Larger font size
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM y"
        headerLabel.text = formatter.string(from: self.currentDate)
        
        self.headerLabel = headerLabel
        
        // Add to parent
        header.addSubview(leftButton)
        header.addSubview(rightButton)
        header.addSubview(headerLabel)
        
        return header
    }
    
    private func createWeekdayHeader(frame: CGRect) -> UIView {
        let header = UIView(frame: frame)
        header.backgroundColor = UIColor.white
        
        let labels = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        
        let baseWidth: CGFloat = frame.width / 7.0
        for weekday in 0..<7 { // All 7 days of the week
            let dayFrame = CGRect(x: CGFloat(weekday) * baseWidth, y: 0, width: baseWidth, height: frame.height)
            let tile: UIView = UIView(frame: dayFrame)
            
            let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: dayFrame.width, height: dayFrame.height)) // Cover entire tile
            label.textAlignment = .center
            label.text = labels[weekday]
            
            if (weekday % 2 == 1) { // Odd number
                tile.backgroundColor = self.lightGrey
            } else {
                tile.backgroundColor = self.grey
            }
            
            tile.addSubview(label)
            
            header.addSubview(tile) // Add to parent
        }
        
        return header
    }
    
    private func drawDaySquares() {
        let firstDayOfMonth: Date = self.monthAchor.firstDayInMonth()
        let startingWeekday: Int = firstDayOfMonth.getWeekday()
        let lengthOfMonth: Int = firstDayOfMonth.lengthOfMonth()
        let numberOfRows: CGFloat = CGFloat(ceil(Double(startingWeekday + lengthOfMonth) / 7.0)) // Number of rows needed
        
        // Base sizing
        let baseWidth = self.tileContainer.frame.width / 7.0
        var baseHeight = self.tileContainer.frame.height / numberOfRows
        
        baseHeight = baseHeight > baseWidth ? baseWidth : baseHeight // Should never be taller than it is wide
        
        // Store instance of each day in global array
        self.tiles = [] // Reset
        
        // For each day of the month
        for i in 0..<lengthOfMonth {
            let dateForTile: Date = firstDayOfMonth.addingTimeInterval(Double(i) * 24.0 * 60.0 * 60.0) // Add i number of days
            let gridIndex = startingWeekday + i // The position in "grid"
            
            // Get the x and y coordinates
            let xIndex = gridIndex % 7
            let yIndex = floor(Double(gridIndex) / 7.0)
            
            // Calculate background color
            var opacity: CGFloat = CGFloat(calendarManager.getEvents(day: dateForTile).count) / self.sensitivity
            if (opacity >= 1.0) { opacity = 1.0 } // Max full opacity
            let backgroundColor: UIColor = self.colorScheme.withAlphaComponent(opacity)
            
            let tileFrame: CGRect = CGRect(x: CGFloat(xIndex) * baseWidth, y: CGFloat(yIndex) * baseHeight, width: baseWidth, height: baseHeight)
            let tile: DayTile = DayTile(id: i, frame: tileFrame, label: String(i + 1), highlight: self.highlightColor, background: backgroundColor, forDate: dateForTile)
            
            // If it's selected
            if (dateForTile.dateWithoutTime().compare(self.selectedDate.dateWithoutTime()) == .orderedSame) {
                tile.select()
                self.selectedIndex = i // Update selected index
            }
            
            tile.addToView(parent: self.tileContainer) // Add to the tile container
            tile.delegate = self
            self.tiles.append(tile)
        }
    }
    
    // MARK - User Interaction Actions
    
    // Set the date
    public func setDate(date: Date) {
        self.monthAchor = date.firstDayInMonth() // Set the correct month
        repopulate()
        
        // Get the new ID
        let newId: Int = date.getDay() // Get index
        selected(id: newId, date: date) // Select the date
    }
    
    // Move to the next month
    @objc private func nextMonth(sender: UIButton!) {
        let daysAhead = Double(self.monthAchor.lengthOfMonth()) + 15.0 // Go to middle of next month
        let midNextMonth: Date = self.monthAchor.addingTimeInterval(daysAhead * 24.0 * 60.0 * 60.0)
        self.monthAchor = midNextMonth.firstDayInMonth() // Advance to first day of next month
        
        repopulate()
    }
    
    // Move to the previous month
    @objc private func previousMonth(sender: UIButton!) {
        let midPreviousMonth: Date = self.monthAchor.addingTimeInterval(-15 * 24.0 * 60.0 * 60.0)
        self.monthAchor = midPreviousMonth.firstDayInMonth() // Advance to first day of previous month
        
        repopulate()
    }
    
    // Redraw neccessary assets
    private func repopulate() {
        
        // Update header
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM y"
        self.headerLabel.text = formatter.string(from: self.monthAchor)
        
        // Remove all views from tile container
        for view in self.tileContainer.subviews {
            view.removeFromSuperview()
        }
        
        drawDaySquares() // Redraw the tiles
    }
    
    // When a date is selected
    func selected(id: Int, date: Date) {
        self.tiles[self.selectedIndex].deselect()
        self.tiles[id].select()
        
        // Update which is selected
        self.selectedIndex = id
        self.selectedDate = date
        
        // Send protocol action
        delegate?.dateChange!(date: date)
    }
}


//
//  DayTile.swift
//  Calendar-Component-Library
//
//  Created by Kevin Hou on 9/3/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import UIKit

@objc protocol DayTileDelegate: class {
    @objc optional func selected(id: Int, date: Date)
}


class DayTile {
    
    // Delegate to make sure parent conforms
    weak var delegate: DayTileDelegate?
    
    // Instance variables
    private var view: UIView
    private var label: UILabel
    private var id: Int
    private var backgroundColor: UIColor
    private var highlightColor: UIColor
    private var selected: Bool = false // Default is false
    private var selectedMarker: UIView
    private var date: Date // Which date it's referencing
    
    init(id: Int, frame: CGRect, label: String, highlight: UIColor, background: UIColor, forDate: Date) {
        // Set instance variables
        self.id = id
        self.label = UILabel(frame: frame)
        self.backgroundColor = background
        self.highlightColor = highlight
        self.view = UIView(frame: frame) // Create tile from frame
        self.label = DayTile.createLabel(frame: frame, label: label) // Create UI label
        self.selectedMarker = DayTile.createHighlightMarker(parent: frame, highlightColor: highlight)
        self.date = forDate
        
        drawSquare()
    }
    
    private func drawSquare() {
        // Set meta data
        self.view.tag = self.id
        
        // Style tile
        self.view.backgroundColor = self.backgroundColor
        
        // User interaction
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapTile(sender:)))
        self.view.addGestureRecognizer(tap)
        
        // Add content to view
        self.view.addSubview(self.label)
        self.view.insertSubview(self.selectedMarker, belowSubview: self.label)
    }
    
    public func addToView(parent: UIView) {
        parent.addSubview(self.view) // Add the tile to the subview
    }
    
    private static func createLabel(frame: CGRect, label: String) -> UILabel {
        let dateLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height)) // Create label
        dateLabel.text = label // Set text
        dateLabel.textAlignment = .center // Center aligned
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.font.withSize(10.0)
        dateLabel.textColor = UIColor.black
        
        return dateLabel
    }
    
    private static func createHighlightMarker(parent: CGRect, highlightColor: UIColor) -> UIView {
        let scale: CGFloat = 0.825 // Percent scaled down
        let minLength: CGFloat = min(parent.width, parent.height)
        
        let padding: CGFloat = minLength * ((1 - scale) / 2) // Calculate the padding
        let markerFrame: CGRect = CGRect(x: padding, y: padding, width: parent.width - (2 * padding), height: parent.height - (2 * padding))
        let marker: UIView = UIView(frame: markerFrame)
        marker.backgroundColor = highlightColor
        
        // Make into a circle
        let minRadius = min(markerFrame.width, markerFrame.height)
        marker.layer.cornerRadius = minRadius / 2
        marker.layer.masksToBounds = true
        marker.layer.isHidden = true // Hide all initially
        
        return marker
    }
    
    @objc private func tapTile(sender: UITapGestureRecognizer) {
        delegate?.selected!(id: self.id, date: self.date) // Send ID and date to parent
    }
    
    public func select() {
        self.selectedMarker.layer.isHidden = false // Make highlight marker visible
        self.label.textColor = UIColor.white // Make text white
        self.label.font.withSize(14.0)
        self.animateHighlight() // Animate the highlight interaction
    }
    
    public func deselect() {
        self.selectedMarker.layer.isHidden = true // Make highlight marker invisible
        self.label.textColor = UIColor.black // Make text black again
        self.label.font.withSize(10.0)
    }
    
    private func animateHighlight() {
        self.selectedMarker.transform = CGAffineTransform(scaleX: 1.2, y: 1.2) // Animate large to normal
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseInOut, animations: {
            self.selectedMarker.transform = .identity // Make normal size
        }, completion: nil)
    }
}

extension Date {
    func getWeekday() -> Int {
        let calendar = NSCalendar(calendarIdentifier: .gregorian)
        let components: DateComponents = calendar!.components(.weekday, from: self) // Get day of the week
        return components.weekday! - 1 // Return weekday
    }
    
    func daysAhead(_ days: Int) -> Date {
        let timeAgo: TimeInterval = TimeInterval(days * 24 * 60 * 60) // 24 hours, 60 minutes, 60 seconds
        let newDate: Date = Date(timeInterval: timeAgo, since: self)
        return newDate // Return the date
    }
    
    func getDay() -> Int {
        let calendar = NSCalendar(calendarIdentifier: .gregorian)
        let components: DateComponents = calendar!.components(.day, from: self)
        return components.day!
    }
    
    func getMonth() -> Int {
        let calendar = Calendar.current
        return calendar.component(.month, from: self)
    }
    
    func getYear() -> Int {
        let calendar = NSCalendar(calendarIdentifier: .gregorian)
        let components: DateComponents = calendar!.components(.day, from: self)
        return components.year!
    }
    
    func firstDayInMonth() -> Date {
        let calendar = NSCalendar(calendarIdentifier: .gregorian)
        let components: DateComponents = calendar!.components([.year, .month], from: self)
        return calendar!.date(from: components)!
    }
    
    func lengthOfMonth() -> Int {
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: .gregorian)!
        let daysInMonth = calendar.range(of: .day, in: .month, for: self)
        return daysInMonth.length
    }
}
