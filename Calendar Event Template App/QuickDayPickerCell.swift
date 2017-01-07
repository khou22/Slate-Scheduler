//
//  QuickDayPickerCell.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/5/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import UIKit

class QuickDayPickerCell: UICollectionViewCell {
    
    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    override func awakeFromNib() {
        // Initalizer for styling
    }
    
    
    
    // Styling for when option is selected
    func userSelected() {
        self.dayLabel.textColor = Colors.blue
        self.weekdayLabel.textColor = Colors.blue
    }
    
    // Styling for when option is unselected
    func userUnselected() {
        self.dayLabel.textColor = Colors.black
        self.weekdayLabel.textColor = Colors.black
    }
}
