//
//  CategoryDetailsEdit.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/11/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import UIKit

class CategoryDetailsEdit: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var categories: [Category] = [] // Storing all categories
    var currentCategory: Category = Category(name: StringIdentifiers.noCategory, eventNameFreq: [ : ]) // Initially empty category
    var eventKeys: [String] = []
    var selectedIndex: Int = 0 // The index of the category you are editing
    
    // UI Elements
    @IBOutlet weak var categoryNameInput: UITextField!
    @IBOutlet weak var predictedNameLocationTable: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        self.refreshData() // Update data
        let categoryName = self.currentCategory.name
        print("Selected index: \(categoryName)")
        
        // Title changes
        self.navigationItem.title = categoryName
        
        // Styling changes
        self.categoryNameInput.addBottomBorder()
        
        // Populate category name input
        self.categoryNameInput.text = categoryName
        
        // Automatic row height
        self.predictedNameLocationTable.rowHeight = UITableViewAutomaticDimension
    }
    
    // Retrieve and prepare data
    func refreshData() {
        // Load data from NSUserDefaults
        self.categories = DataManager.getCategories()
        
        // Set current category
        self.currentCategory = self.categories[self.selectedIndex]
        
        // Set keys
        print(self.currentCategory.eventNameFreq.count)
        for (eventName, _) in self.currentCategory.eventNameFreq {
            self.eventKeys.append(eventName) // Add keys
        }
        
        // Refresh table view
        DispatchQueue.main.async {
            self.predictedNameLocationTable.reloadData()
        }
    }
    
    // MARK - Table View Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentCategory.eventNameFreq.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Cell for each index
        let cell = self.predictedNameLocationTable.dequeueReusableCell(withIdentifier: CellIdentifiers.nameLocationCell, for: indexPath) as! NameLocationFrequencyCell
        let index = indexPath.item // Get index
        let key = self.eventKeys[index] // Get key for dictionary
        
        // Populate cell
        print("Populating cell")
        if let eventNameFreq = self.currentCategory.eventNameFreq[key] {
            print("Event name: \(key) with frequency: \(eventNameFreq)")
            cell.eventName.text = key // Event name
            cell.eventNameFreq.text = String(eventNameFreq)
        }
        
        return cell
    }
}
