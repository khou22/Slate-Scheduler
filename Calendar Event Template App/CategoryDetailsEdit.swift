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
    
    // UI Elements
    @IBOutlet weak var categoryNameInput: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        // Load data from NSUserDefaults
        self.categories = DataManager.getCategories()
        let categoryName = self.categories[self.selectedIndex].name
        print("Selected index: \(categoryName)")
        
        // Title changes
        self.navigationItem.title = categoryName
        
        // Styling changes
        self.categoryNameInput.addBottomBorder()
        
        // Populate category name input
        self.categoryNameInput.text = categoryName
    }
}
