//
//  CategoryCellCollectionViewCell.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/4/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import UIKit

class CategoryCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        // Initiate cell
        
        // Styling that applies to all cells
        self.backgroundColor = Colors.red.withAlphaComponent(0.10) // 10% transparency
        self.layer.borderColor = Colors.red.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5.0
    }
}
