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

    public var autocompleteSuggestions: [String] = [] // All possible suggestions
    fileprivate var validSuggestions: [String] = ["Test", "Hello", "World"] // Matches text field's value
    
    fileprivate var autocompleteTableView: UITableView = UITableView()
    
    // Next text field after user presses return
    public var nextTextField: UITextField = UITextField()
    
    // Styling
    public var cellHeight: CGFloat = 40.0
    public var numCellsVisible: Int = 3
    public var padding: CGFloat = 0.0
    
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
        UIView.animate(withDuration: 0.25, animations: {
            self.autocompleteTableView.isHidden = false // Show animation box
        })
    }
    
    // Exit animation for suggestion box
    func hideSuggestions() {
        UIView.animate(withDuration: 0.25, animations: {
            self.autocompleteTableView.isHidden = true // Hide animation box
        })
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
        
        view.addSubview(autocompleteTableView) // Add to view
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.autocompleteTableView.dequeueReusableCell(withIdentifier: CellIdentifiers.autcompleteCell, for: indexPath)
        
        // Styling
        cell.textLabel?.font = cell.textLabel?.font.withSize(12.0) // Set font size
        
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
