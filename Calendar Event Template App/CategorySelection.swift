//
//  ViewController.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/4/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import UIKit

class CategorySelection: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var categoryCollection: UICollectionView!
    
    // Constraints to be modified
    @IBOutlet weak var collectionViewLeft: NSLayoutConstraint!
    @IBOutlet weak var collectionViewRight: NSLayoutConstraint!
    
    var categoryData: [Category] = [Category(name: "NA")]
    var selectedItem: Int = 0
    
    // Cell size styling
    let cellsPerRow: CGFloat = 2.0 // Set the number of cells per row
    let cellInset: CGFloat = ScreenSize.screen_width / 50.0
    let cellHeight: CGFloat = 80.0 // Default cell height
    
    override func viewDidLoad() {
        // Load data
        refreshCollection()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Add padding to left and right of collection view
        self.collectionViewLeft.constant = cellInset
        self.collectionViewRight.constant = cellInset
    }
    
    @IBAction func clickedSettings(_ sender: Any) {
        DataManager.deleteAllCategories() // Reset categories
        self.refreshCollection()
    }
    
    // Create new category
    @IBAction func newCategory(_ sender: Any) {
        // Create alert controller
        // Source: http://stackoverflow.com/questions/26567413/get-input-value-from-textfield-in-ios-alert-in-swift
        // Answer by: Andy Ibanez
        let newCategoryAlert = UIAlertController(title: "Enter Category", message: "Enter category name", preferredStyle: .alert)
        
        // Add text field item
        newCategoryAlert.addTextField { (textField) in
            textField.text = "" // No placeholder
        }
        
        // Add action
        newCategoryAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak newCategoryAlert] (_) in
            // Get text field content
            let textField = newCategoryAlert?.textFields![0] // Force unwrapping because we know it exists
            let categoryName: String = (textField?.text)! // Get category name from input
            
            DataManager.newCategory(category: Category(name: categoryName)) // Create new category and push to data set
            
            // Refresh collection view
            self.refreshCollection()
        }))
        
        self.present(newCategoryAlert, animated: true, completion: nil) // Present the alert
    }
    
    func refreshCollection() {
        // Load data from NSUserDefaults
        self.categoryData = DataManager.getCategories()
        
        // Print for debugging
        print("Retrieved category data")
        print(self.categoryData)
        
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
        print("Selected category: " + categoryData[self.selectedItem].name)
        
        // Perform segue and pass on category data
        self.performSegue(withIdentifier: SegueIdentifiers.createEvent, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Creating new event segue
        if(segue.identifier == SegueIdentifiers.createEvent) {
            let eventDetailsVC = segue.destination as! EventDetails
            eventDetailsVC.category = self.categoryData[self.selectedItem] // Pass on category data
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
    

}

