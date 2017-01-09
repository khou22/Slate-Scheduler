//
//  CustomTextField.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/6/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//
//  Useful functions for a UITextField

import UIKit

extension UITextField {
    
    // Set border to none in Storyboard and then call this function to add just a bottom border
    func addBottomBorder() {
        let bottomBorder = CALayer()
        let width = CGFloat(1.0) // Border width
        bottomBorder.borderColor = Colors.red.cgColor // Border color
        bottomBorder.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height) // Frame
            
        bottomBorder.borderWidth = width // Apply border width
        self.layer.addSublayer(bottomBorder) // Add to text field
        self.layer.masksToBounds = true
    }

}
