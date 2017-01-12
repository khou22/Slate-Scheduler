//
//  CategoryDetailsEdit.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/11/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import UIKit

class CategoryDetailsEdit: UIViewController {
    
    var categories: [Category] = [] // Storing all categories
    var selectedIndex: Int = 0 // The index of the category you are editing
    
    override func viewDidLoad() {
        // Stylistic changes
        if let backButton = self.navigationItem.backBarButtonItem { // Change color of back button
            print("Styling to toolbar")
            backButton.tintColor = Colors.red
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Load data from NSUserDefaults
        self.categories = DataManager.getCategories()
        print("Selected index: \(self.categories[self.selectedIndex].name)")
    }
}
