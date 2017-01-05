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
    
    // Cell size styling
    let cellsPerRow: CGFloat = 2.0 // Set the number of cells per row
    let cellInset: CGFloat = ScreenSize.screen_width / 50.0
    let cellHeight: CGFloat = 80.0 // Default cell height
    
    override func viewDidLoad() {
        // Load data from NSUserDefaults
        self.categoryData = DataManager.getCategories()
        print(self.categoryData)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Add padding to left and right of collection view
        self.collectionViewLeft.constant = cellInset
        self.collectionViewRight.constant = cellInset
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
        print("Selected category: " + categoryData[indexPath.item].name)
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

