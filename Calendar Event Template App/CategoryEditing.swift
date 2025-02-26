//
//  CategoryEditing.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/11/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import UIKit

class CategoryEditing: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var categories: [Category] = [] // Category data
    var lastSelected: Int = 0 // Last selected item
    
    // UI Elements
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var categoryTable: UITableView!
    @IBOutlet weak var categoryLabelSwitch: UISwitch!
    @IBOutlet weak var reminderTimeControl: UISegmentedControl!
    
    @IBAction func closeEditing(_ sender: Any) {
        dismiss(animated: true, completion: nil) // Exit segue back to category selection
    }
    
    @IBAction func pressedEditing(_ sender: Any) {
        self.categoryTable.isEditing = !self.categoryTable.isEditing // Flip
        
        if (!self.categoryTable.isEditing) { // If no longer editing
            // Update labels
            editButton.title = "Edit"
            closeButton.title = "Close"
            
            refreshPersistData() // Update persist data
        } else { // If now editing
            editButton.title = "Done" // Update labels
            closeButton.title = "Cancel"
        }
    }
    
    override func viewDidLoad() {
        self.showCalendarErrorScreen() // Check calendar permission and show error screen if needed
        
        self.categoryTable.allowsMultipleSelection = false // Don't allow multiple selection of cells
        
        // Set initial value of categoyr label switch
        self.categoryLabelSwitch.isOn = DataManager.includeCategoryLabel()
        
        // Set value of event reminder time
        let index: Int = DataManager.reminderTimeState().hashValue
        self.reminderTimeControl.selectedSegmentIndex = index // Set selected
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getCollection() // Get category data
        
        Analytics.setScreenName("Category Management") // Log screen name
    }
    
    @IBAction func updatedCategoryLabelSetting(_ sender: Any) {
        DataManager.setCategoryLabelSetting(value: self.categoryLabelSwitch.isOn)
    }
    
    @IBAction func pressedHelp(_ sender: Any) {
        Analytics.onboardingFromCategoryEditing() // Analytics event
        
        performSegue(withIdentifier: SegueIdentifiers.showOnboarding, sender: self) // Show onboarding
    }
    
    // Update the reminder time
    @IBAction func updatedReminderTime(_ sender: Any) {
        let timeEnum: ReminderTime.values = ReminderTime.orderedValues[self.reminderTimeControl.selectedSegmentIndex] // Get enum value
        DataManager.setReminderTime(time: timeEnum) // Save
    }
    
    func getCollection() {
        // Load data from NSUserDefaults
        self.categories = DataManager.getCategories()
        
        // Refresh table view
        DispatchQueue.main.async {
            self.categoryTable.reloadData()
        }
    }
    
    func refreshPersistData() {
        DataManager.refreshData(with: self.categories) // Refresh entire data set
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == SegueIdentifiers.categoryDetailEdit) { // If going to detail edit screen
            let categoryDetailsEditVC = segue.destination as! CategoryDetailsEdit
            categoryDetailsEditVC.selectedIndex = self.lastSelected // Pass on this specific category data
        }
    }
    
    // MARK - Table View Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Cell for each index
        let cell = categoryTable.dequeueReusableCell(withIdentifier: CellIdentifiers.categoryEditCell, for: indexPath) as! CategoryEditCell
        let index = indexPath.item // Get index
        cell.categoryName.text = self.categories[index].name // Populate name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = categories[sourceIndexPath.row] // Get item to move
        categories.remove(at: sourceIndexPath.row) // Delete at old position
        categories.insert(itemToMove, at: destinationIndexPath.row) // Move to new position
        
        Analytics.modifiedCategoryOrder() // Log GA event
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.item // Get index
        self.lastSelected = index // Store as last selected
        
        self.categoryTable.deselectRow(at: indexPath, animated: true) // Ensure that it not highlighted when return
        
        self.performSegue(withIdentifier: SegueIdentifiers.categoryDetailEdit, sender: self) // Go to detailed edit screen
    }
    
    // Functionality for when editing cells
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // When delete an item
            let index = indexPath.item
            
            Analytics.deletedCategory(name: categories[index].name) // Log GA event
            
            categories.remove(at: index) // Delete item
            self.refreshPersistData() // Refresh persist data
            
            // Refresh table view to show updated category data
            DispatchQueue.main.async {
                self.categoryTable.reloadData()
            }
        }
    }
}
