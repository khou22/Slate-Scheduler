//
//  AutocompleteTextField.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/17/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//
//  Autocomplete table view

import UIKit

class AutocompleteTextField: UITextField, UITextFieldDelegate {
    
    // Relevant data
    fileprivate var autocompleteSuggestions: [String] = [] // All possible suggestions in order of priority
    fileprivate var validSuggestions: [String] = [] // Matches textfield's value
    
    fileprivate var autocompleteTableView: UITableView = UITableView()
    
    // Next text field after user presses return
    public var nextTextField: UITextField = UITextField()
    
    // Styling
    public var cellHeight: CGFloat = 40.0
    public var numCellsVisible: Int = 3
    public var padding: CGFloat = 7.0
    
    // Not sure what this does
    override init(frame: CGRect) {
        super.init(frame: frame) // Initialize text field?
    }
    
    // Initializer
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.nextTextField.becomeFirstResponder() // Next responder
        return true
    }
    
    // Entrance animation for suggestion box
    func showSuggestions() {
        print("Displaying autocomplete suggestions")
        let tableHeight: CGFloat = self.cellHeight * CGFloat(self.numCellsVisible) // Calculate height
        let oldFrame = self.autocompleteTableView.frame // Store old frame
        UIView.animate(withDuration: 0.2, animations: {
            self.autocompleteTableView.alpha = 1.0 // Show animation box
            self.autocompleteTableView.frame = CGRect(x: oldFrame.minX, y: oldFrame.minY, width: oldFrame.width, height: tableHeight) // Animate expand
        })
    }
    
    // Exit animation for suggestion box
    func hideSuggestions() {
        print("Hiding autocomplete suggestions")
        let oldFrame = self.autocompleteTableView.frame // Store old frame
        UIView.animate(withDuration: 0.2, animations: {
            self.autocompleteTableView.alpha = 0.25 // Doesn't have to be 0
            self.autocompleteTableView.frame = CGRect(x: oldFrame.minX, y: oldFrame.minY, width: oldFrame.width, height: 0.0) // Animate shrink
        })
    }
    
    // Update possible suggestions
    func updateSuggestions(prioritized suggestions: [String]) {
        self.autocompleteSuggestions = suggestions // Update data source
    }
    
    // Update the valid/matching suggestions
    func updateValid() {
        let currentQuery: String = self.text!
        
        if (currentQuery == "") { // If the textbox is empty
            print("Displaying all")
            self.validSuggestions = self.autocompleteSuggestions // Load all as potentially valid
        } else { // If the user has typed something into the text box
            self.validSuggestions.removeAll() // Clear array
            // Cycle through all possible and search for matches
            for potential in self.autocompleteSuggestions {
                if (potential.contains(currentQuery)) { // If contains that substring
                    self.validSuggestions.append(potential) // Add to the secondary array
                }
            }

        }
        
        // Refresh table view
        DispatchQueue.main.async {
            self.autocompleteTableView.reloadData()
        }
    }

}


// Everything relating to the suggestion table view frontend
extension AutocompleteTextField: UITableViewDelegate, UITableViewDataSource {
    
    // Setup autcomplete table view
    public func setupTableView(view: UIView) {
        // Starts below text input, same width
        let tableHeight: CGFloat = self.cellHeight * CGFloat(self.numCellsVisible) // Calculate height
        
        let lowerLeftCorner: CGPoint = CGPoint(x: self.frame.minX, y: self.frame.maxY) // Get coordinate of text input
        let transformedOrigin: CGPoint = (self.superview?.convert(lowerLeftCorner, to: view))! // Transform point into view frame
        let frame = CGRect(x: transformedOrigin.x, y: transformedOrigin.y + self.padding, width: self.frame.width, height: tableHeight)
        self.autocompleteTableView = UITableView(frame: frame)
        
        // Set data source and delegate
        self.autocompleteTableView.delegate = self
        self.autocompleteTableView.dataSource = self
        
        // Register cell
        self.autocompleteTableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifiers.autcompleteCell)
        
        // Styling and options
        self.autocompleteTableView.rowHeight = self.cellHeight // Row height
        self.autocompleteTableView.isScrollEnabled = true // Allow scrolling
        self.autocompleteTableView.alpha = 0.0 // Start transparent when initialized (must be 0)
        self.autocompleteTableView.separatorColor = Colors.lightGrey // Seperator color
        self.autocompleteTableView.separatorInset = .zero // No seperator line inset
        
        // Set border
        self.autocompleteTableView.layer.borderWidth = 1 // Set border
        self.autocompleteTableView.layer.cornerRadius = 5 // Set border radius
        self.autocompleteTableView.layer.borderColor = Colors.grey.cgColor // Border color
        
        view.addSubview(autocompleteTableView) // Add to view
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.autocompleteTableView.dequeueReusableCell(withIdentifier: CellIdentifiers.autcompleteCell, for: indexPath)
        
        // Styling
        cell.textLabel?.font = cell.textLabel?.font.withSize(12.0) // Set font size
        cell.textLabel?.textColor = Colors.black
        
        // Populate information
        cell.textLabel?.text = self.validSuggestions[indexPath.item] // Populate cell label
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.validSuggestions.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected autocomplete suggestion at row \(indexPath.item)")
    }
}
