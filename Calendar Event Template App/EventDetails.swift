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
    
    @IBOutlet weak var saveButton: UIButton!
    
    var category: Category = Category(name: "NA")
    
    override func viewDidLoad() {
        print("Creating event with category: " + self.category.name)
        
        // Styling
        saveButton.backgroundColor = Colors.blue
    }
    
    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
        print("Unwinding")
    }
    
    
    @IBAction func saveEvent(_ sender: Any) {
        print("Saving event")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Preparing for segue")
    }
}
