//
//  ViewController.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/4/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import UIKit

class CategorySelection: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var categoryCollection: UICollectionView!
    
    var categoryData = ["COS 126", "MAT 104", "PHY 103", "FRS 127", "Other"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Number of items in the collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryData.count
    }
    
    // Return a cell for each index
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = categoryCollection.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.categoryCell, for: indexPath) as! CategoryCollectionCell
        
        cell.backgroundColor = Colors.blue
        cell.label.text = categoryData[indexPath.item] // Add label
        
        return cell
    }
    
    // Handle cell selection
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Triggered when category item selection
    }
    

}

