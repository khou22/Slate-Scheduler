//
//  ViewController.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/4/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import UIKit
import MapKit

class CategorySelection: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // Main collection view
    @IBOutlet weak var categoryCollection: UICollectionView!
    
    // UI Elements
    @IBOutlet var noCategoriesLabels: [UILabel]!
    
    // Constraints to be modified
    @IBOutlet weak var collectionViewLeft: NSLayoutConstraint!
    @IBOutlet weak var collectionViewRight: NSLayoutConstraint!
    
    var categoryData: [Category] = [Constants.emptyCategory]
    var selectedItem: Int = 0
    
    // Cell size styling
    let cellsPerRow: CGFloat = 2.0 // Set the number of cells per row
    let cellInset: CGFloat = ScreenSize.screen_width / 50.0
    let cellHeight: CGFloat = 80.0 // Default cell height
    
    // Location services
    let locationManager: CLLocationManager = CLLocationManager()
    
    // Styling before view appears
    override func viewDidLoad() {
        // Labels when no categories present
        for label in self.noCategoriesLabels {
            label.alpha = 0.0 // Make transparent
        }
        
        if DataManager.locationServicesEnabled() { // If location services enabled
            self.setupLocationService() // Setup and get location once
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Add padding to left and right of collection view
        self.collectionViewLeft.constant = cellInset
        self.collectionViewRight.constant = cellInset
        
        // Load data every time someone enters view
        refreshCollection()
    }
    
    @IBAction func clickedSettings(_ sender: Any) {
        self.performSegue(withIdentifier: SegueIdentifiers.editCategories, sender: self) // Go to edit screen
    }
    
    // Create new category
    @IBAction func newCategory(_ sender: Any) {
        // Create alert controller
        // Source: http://stackoverflow.com/questions/26567413/get-input-value-from-textfield-in-ios-alert-in-swift
        // Answer by: Andy Ibanez
        let newCategoryAlert = UIAlertController(title: "Enter Category Name", message: "You can change the category name at any time by pressing \"Manage\" on the homescreen.", preferredStyle: .alert)
        
        // Add text field item
        newCategoryAlert.addTextField(configurationHandler: { (textField: UITextField) in
            textField.text = "" // No placeholder
            textField.autocapitalizationType = UITextAutocapitalizationType.words // Capitalization rules
        })
        
        // Add cancel action
        newCategoryAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil)) // No action if cancelled
        
        // Add submit action
        newCategoryAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak newCategoryAlert] (_) in
            // Get text field content
            let textField = newCategoryAlert?.textFields![0] // Force unwrapping because we know it exists
            let categoryName: String = (textField?.text)! // Get category name from input
            
            let category: Category = Category(name: categoryName, eventNameFreq: [ : ], locationFreq: [ : ]) // Create new category
            DataManager.newCategory(category: category) // Push to data set
            
            // Refresh collection view
            self.refreshCollection()
        }))
        
        self.present(newCategoryAlert, animated: true, completion: nil) // Present the alert
    }
    
    // New event that's not assigned to a category
    @IBAction func newEventNoCategory(_ sender: Any) {
        // Triggered when category item selection
//        print("New uncategorized event")
        
        // Perform segue and pass on blank category data
        self.performSegue(withIdentifier: SegueIdentifiers.newEventNoCategory, sender: self)
    }
    
    func refreshCollection() {
//        print("Refreshed collection")
        // Load data from NSUserDefaults
        self.categoryData = DataManager.getCategories()
        
        // Check if data is empty
        if (self.categoryData.count == 0) {
            for label in self.noCategoriesLabels {
                label.alpha = 1.0 // Make messages visible
            }
        } else { // If there is data
            for label in self.noCategoriesLabels {
                label.alpha = 0.0 // Make transparent
            }
        }
                
        // Refresh collection view
        DispatchQueue.main.async {
            self.categoryCollection.reloadData()
        }
    }

    // Number of items in the collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryData.count
    }
    
    // Return a cell for each index
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = categoryCollection.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.categoryCell, for: indexPath) as! CategoryCollectionCell
        
        cell.label.text = categoryData[indexPath.item].name // Add label
        
        return cell
    }
    
    // Handle cell selection
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Triggered when category item selection
        self.selectedItem = indexPath.item // Update selected index
//        print("Selected category: " + categoryData[self.selectedItem].name)
        
        // Perform segue and pass on category data
        self.performSegue(withIdentifier: SegueIdentifiers.createEvent, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Creating new event segue
        if (segue.identifier == SegueIdentifiers.createEvent) {
            let eventDetailsVC = segue.destination as! EventDetails
//            print("Performing segue with data: " + self.categoryData[self.selectedItem].name)
            eventDetailsVC.category = self.categoryData[self.selectedItem] // Pass on category data
            
        } else if (segue.identifier == SegueIdentifiers.newEventNoCategory) { // New event no category
            let eventDetailsVC = segue.destination as! EventDetails
            eventDetailsVC.noCategory = true // Signify no category
            eventDetailsVC.categoryIndex = self.selectedItem // Pass on index
            
        }
    }
    
    // MARK - Flow layout
    // Set size of cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (ScreenSize.screen_width - (cellsPerRow * 3 * cellInset)) / cellsPerRow // Set width of cells
        return CGSize(width: cellWidth, height: cellHeight) // Return size of cell
    }
    
    // Set inset of cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        // Set -40 to remove weird top space above collection view
        // Source: http://stackoverflow.com/questions/23786198/uicollectionview-how-can-i-remove-the-space-on-top-first-cells-row
        return UIEdgeInsetsMake(-40, cellInset, 0, cellInset)
    }
    
    func setupLocationService() {
        self.locationManager.delegate = self // Set delegate
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters // Don't need extreme accuracy
        self.locationManager.requestLocation()
    }
}

// Getting current location
extension CategorySelection: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocationCoordinate2D = manager.location!.coordinate // Get coordinates of location
        print("Location = \(location.latitude) \(location.longitude)") // Feedback
        
        DataManager.setLatestLocation(coordinates: location)
    }
    
}
