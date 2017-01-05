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
        self.backgroundColor = Colors.lightGrey
        self.layer.borderColor = Colors.grey.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5.0
    }
}
