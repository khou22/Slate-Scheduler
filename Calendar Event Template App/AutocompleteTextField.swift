//
//  AutocompleteTextField.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/17/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//
//  Autocomplete table view

import UIKit

class AutocompleteTextField: UITextField {

    public var autocompleteSuggestions: [String] = [] // All possible suggestions
    fileprivate var validSuggestsions: [String] = ["Test", "Hello", "World"] // Matches text field's value
    
    fileprivate var autocompleteTableView: UITableView = UITableView()
    
    // Styling
    public var tableHeight: CGFloat = 100.0
    
    override init(frame: CGRect) {
        super.init(frame: frame) // Initialize text field
        
        print(frame)
        
    }
    
    // Required?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        print("Init")
    }
    
    // Setup autcomplete table view
    public func setupTableView(view: UIView) {
        // Starts below text input, same width
        print("Setting up table view")
        print(self.frame.origin.y)
        print(self.frame.height)
        print(self.frame.maxY)
        let frame = CGRect(x: self.frame.minX, y: self.frame.maxY, width: self.frame.width, height: self.tableHeight)
        self.autocompleteTableView = UITableView(frame: frame)
        
        // Set data source and delegate
        self.autocompleteTableView.delegate = self
        self.autocompleteTableView.dataSource = self
        
        view.addSubview(autocompleteTableView)
        
    }

}

extension AutocompleteTextField: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Cell for each index
        let cell = self.autocompleteTableView.dequeueReusableCell(withIdentifier: CellIdentifiers.autcompleteCell, for: indexPath)
        
        let index = indexPath.item
        
        cell.textLabel?.text = self.validSuggestsions[index] // Populate suggestion label
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.autocompleteSuggestions.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected autocomplete suggestion at row \(indexPath.item)")
    }
}
