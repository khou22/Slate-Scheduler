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
    fileprivate var validSuggestsions: [String] = ["Test", "Hello", "World"] // Matches text field's value
    
    fileprivate var autocompleteTableView: UITableView = UITableView()
    
    // Next text field after user presses return
    public var nextTextField: UITextField = UITextField()
    
    // Styling
    public var tableHeight: CGFloat = 100.0
    public var padding: CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame) // Initialize text field
        
        print(frame)
        
    }
    
    // Required?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
//        print("Init")
        
        self.delegate = self
    }
    
    // Setup autcomplete table view
    public func setupTableView(view: UIView) {
        // Starts below text input, same width
        print("Setting up table view")
        let lowerLeftCorner: CGPoint = CGPoint(x: self.frame.origin.x, y: self.frame.maxY)
        let transformedOrigin: CGPoint = (self.superview?.convert(lowerLeftCorner, to: view))!
        let frame = CGRect(x: transformedOrigin.x, y: transformedOrigin.y + self.padding, width: self.frame.width, height: self.tableHeight)
        self.autocompleteTableView = UITableView(frame: frame)
        
        // Set data source and delegate
        self.autocompleteTableView.delegate = self
        self.autocompleteTableView.dataSource = self
        
        view.addSubview(autocompleteTableView)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.nextTextField.becomeFirstResponder() // Next responder
        return true
    }

}

extension AutocompleteTextField: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Cell for each index
//        var cell = self.autocompleteTableView.dequeueReusableCell(withIdentifier: CellIdentifiers.autcompleteCell, for: indexPath)
        let cell = UITableViewCell(style: .default, reuseIdentifier: CellIdentifiers.autcompleteCell)
        
        let index = indexPath.item
        
        cell.detailTextLabel?.text = "Yo"
        cell.textLabel?.text = self.validSuggestsions[index] // Populate suggestion label
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.autocompleteSuggestions.count
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected autocomplete suggestion at row \(indexPath.item)")
    }
}
