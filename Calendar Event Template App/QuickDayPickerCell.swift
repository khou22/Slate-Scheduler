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
    
    // Called when the value isSelected is changed
    // Source: http://stackoverflow.com/questions/31329972/trying-to-override-selected-in-uicollectionviewcell-swift-for-custom-selection
    override var isSelected: Bool {
        get {
            return super.isSelected
        }
        set {
            if newValue {
                super.isSelected = true
                self.userSelected()
//                print("Selected")
            } else if newValue == false {
                super.isSelected = false
                self.userUnselected()
//                print("Unselected")
            }
        }
    }
}
