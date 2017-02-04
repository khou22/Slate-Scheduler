//
//  CategoryDetailsEdit.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/11/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import UIKit

class CategoryDetailsEdit: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var categories: [Category] = [] // Storing all categories
    var currentCategory: Category = Constants.emptyCategory // Initially empty category
    var eventKeys: [String] = []
    var locationKeys: [String] = []
    var selectedIndex: Int = 0 // The index of the category you are editing
    
    // UI Elements
    @IBOutlet weak var categoryNameInput: UITextField!
    @IBOutlet weak var predictedNameTable: UITableView!
    @IBOutlet weak var predictedLocationTable: UITableView!
    @IBOutlet weak var resetPredictionsButton: UIButton!
    
    // Manually add an event name prediction
    @IBAction func addEventNamePrediction(_ sender: Any) {
        // Create text modal for adding an event name prediction
        let newCategoryAlert = UIAlertController(title: "Enter Event Name", message: "Manually add an event name suggestion", preferredStyle: .alert)
        
        // Add text field item
        newCategoryAlert.addTextField { (textField) in
            textField.text = "" // No placeholder
            textField.autocapitalizationType = UITextAutocapitalizationType.words // Capitalization rules
        }
        
        // Add cancel action
        newCategoryAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil)) // No action if cancelled
        
        // Add submit action
        newCategoryAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak newCategoryAlert] (_) in
            // Get text field content
            let textField = newCategoryAlert?.textFields![0] // Force unwrapping because we know it exists
           
            self.currentCategory.eventNameFreq[(textField?.text)!] = 0 // New event name frequency entry with frequency of 0
            
            // Update category data with new markov model
            DataManager.updateOneCategory(with: self.currentCategory, index: self.selectedIndex)
            
            // Refresh the table view on this page
            self.refreshData()
        }))
        
        self.present(newCategoryAlert, animated: true, completion: nil) // Present the alert
    }
    
    // Manually add location prediction
    @IBAction func addLocationPrediction(_ sender: Any) {
        // Create text modal for adding an event name prediction
        let newCategoryAlert = UIAlertController(title: "Enter Location", message: "Manually add a location suggestion", preferredStyle: .alert)
        
        // Add text field item
        newCategoryAlert.addTextField { (textField) in
            textField.text = "" // No placeholder
            textField.autocapitalizationType = UITextAutocapitalizationType.words // Capitalization rules
        }
        
        // Add cancel action
        newCategoryAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil)) // No action if cancelled
        
        // Add submit action
        newCategoryAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak newCategoryAlert] (_) in
            // Get text field content
            let textField = newCategoryAlert?.textFields![0] // Force unwrapping because we know it exists
            
            self.currentCategory.locationFreq[(textField?.text)!] = 0 // New event name frequency entry with frequency of 0
            
            // Update category data with new markov model
            DataManager.updateOneCategory(with: self.currentCategory, index: self.selectedIndex)
            
            // Refresh the table view on this page
            self.refreshData()
        }))
        
        self.present(newCategoryAlert, animated: true, completion: nil) // Present the alert
    }
    
    override func viewDidLoad() {
        self.showCalendarErrorScreen() // Check calendar permission and show error screen if needed
        
        self.resetPredictionsButton.layer.cornerRadius = 4 // Round button corners
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.refreshData() // Update data
        let categoryName = self.currentCategory.name
//        print("Selected index: \(categoryName)")
        
        // Title changes
        self.navigationItem.title = categoryName
        
        // Styling changes
        self.categoryNameInput.addBottomBorder()
        
        // Add keyboard hide gesture
        self.hideKeyboardOnSwipe()
        
        // Populate category name input
        self.categoryNameInput.text = categoryName
        
        // Automatic row height
        self.predictedNameTable.rowHeight = UITableViewAutomaticDimension
        self.predictedLocationTable.rowHeight = UITableViewAutomaticDimension
        
        Analytics.setScreenName("Category Edit Details") // Log screen name
    }
    
    // Retrieve and prepare data
    func refreshData() {
        // Load data from NSUserDefaults
        self.categories = DataManager.getCategories()
        
        // Set current category
        self.currentCategory = self.categories[self.selectedIndex]
        
        // Reset keys
        self.eventKeys.removeAll()
        self.locationKeys.removeAll()
        
        // Set keys
        for (eventName, _) in self.currentCategory.eventNameFreq {
            self.eventKeys.append(eventName) // Add keys
        }
        for (location, _) in self.currentCategory.locationFreq {
            self.locationKeys.append(location) // Add location key
        }
        
        // Refresh table view
        DispatchQueue.main.async {
            self.predictedNameTable.reloadData()
            self.predictedLocationTable.reloadData()
        }
    }
    
    // Prompt user if they want to delete all predictions
    @IBAction func resetAllPredictions(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Reset Predictions", message: "Are you sure you want to reset predictions? This cannot be undone.", preferredStyle: .actionSheet) // Create alert action sheet
        
        // Create actions
        let resetAction: UIAlertAction = UIAlertAction(title: "Reset Predictions", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            // User pressed reset all predictions
//            print("Reseting predictions")
            self.currentCategory = Category(name: self.currentCategory.name, eventNameFreq: [ : ], locationFreq: [ : ]) // Reset predictions data
            DataManager.updateOneCategory(with: self.currentCategory, index: self.selectedIndex) // Update data
            
            self.refreshData() // Refresh frontend data
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
            // User pressed cancel
        })
        
        // Add actions
        actionSheet.addAction(resetAction)
        actionSheet.addAction(cancelAction)
        
        self.present(actionSheet, animated: true, completion: nil) // Present action sheet to user
    }
    
    // When pressed done on category name input
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField == self.categoryNameInput) { // Pressed save
            // Update and save the category name
            currentCategory.name = self.categoryNameInput.text! // Save new name
            self.navigationItem.title = self.categoryNameInput.text! // Update screen title
            
            DataManager.updateOneCategory(with: self.currentCategory, index: self.selectedIndex) // Update persist data
            
            self.refreshData()
            self.dismissKeyboard() // Hide keyboard
        }
        
        return true
    }
    
    // MARK - Table View Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == self.predictedNameTable) { // Names
            return self.currentCategory.eventNameFreq.count
        } else { // Locations
            return self.currentCategory.locationFreq.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == self.predictedNameTable) { // Names
            // Cell for each index
            let cell = self.predictedNameTable.dequeueReusableCell(withIdentifier: CellIdentifiers.nameLocationCell, for: indexPath) as! NameLocationFrequencyCell
            let index = indexPath.item // Get index
            let key = self.eventKeys[index] // Get key for dictionary
            
            // Populate cell
            if let eventNameFreq = self.currentCategory.eventNameFreq[key] {
                //            print("Event name: \(key) with frequency: \(eventNameFreq)")
                cell.eventName.text = key // Event name
                cell.eventNameFreq.text = String(eventNameFreq)
            }
            
            return cell
        } else { // Locations
            // Cell for each index
            let cell = self.predictedLocationTable.dequeueReusableCell(withIdentifier: CellIdentifiers.locationListCell, for: indexPath) as! LocationListCell
            let index = indexPath.item // Get index
            let key = self.locationKeys[index] // Get key for dictionary
            
            // Populate cell
            if let locationFreq = self.currentCategory.locationFreq[key] {
                cell.locationLabel.text = key // Event name
                cell.frequencyLabel.text = String(locationFreq)
            }
            
            return cell
        }
    }
    
    // Functionality for when editing cells
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // When delete an item
            let index = indexPath.item
            
            if (tableView == self.predictedNameTable) { // Event names
                self.currentCategory.eventNameFreq.removeValue(forKey: self.eventKeys[index]) // Remove frequency data for specific event name
                
                DataManager.updateOneCategory(with: self.currentCategory, index: self.selectedIndex) // Refresh category data
                
                // Refresh table view to show updated category data
                DispatchQueue.main.async {
                    self.predictedNameTable.reloadData()
                }
            } else { // Locations
                self.currentCategory.locationFreq.removeValue(forKey: self.locationKeys[index]) // Remove frequency data for specific event name
                
                DataManager.updateOneCategory(with: self.currentCategory, index: self.selectedIndex) // Refresh category data
                
                // Refresh table view to show updated category data
                DispatchQueue.main.async {
                    self.predictedLocationTable.reloadData()
                }
            }
        }
    }
}
