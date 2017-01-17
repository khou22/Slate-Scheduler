//
//  AutcompleteTextField.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/17/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//
//  Autcomplete table view

import UIKit

class AutcompleteTextField: UITextField {

    public var autocompleteSuggestions: [String] = [] // All possible suggestions
    private var validSuggestsions: [String] = [] // Matches text field's value
    
    private var tableView: UITableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame) // Initialize text field
        
        
    }
    
    // Required?
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Setup autcomplete table view
    private func setupTableView() {
    
    }

}
