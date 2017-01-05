//
//  EventDetails.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/4/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import UIKit

class EventDetails: UIViewController {
    
    // Navigation buttons
    @IBOutlet weak var saveButton: UIButton!
    
    // Form inputs
    @IBOutlet weak var eventNameInput: AutoCompleteTextField!
    
    var category: Category = Category(name: "NA")
    
    override func viewDidLoad() {
        print("Creating event with category: " + self.category.name)
        
        // Setting up autocomplete
        
        
        // Styling
        saveButton.backgroundColor = Colors.blue
    }
    
    @IBAction func cancelEvent(_ sender: Any) {
        dismiss(animated: true, completion: nil) // Exit segue back to category selection
    }
    
    @IBAction func saveEvent(_ sender: Any) {
        print("Saving event")
    }
}
