//
//  HideKeyboardExtension.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/5/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//
//  Add to view controllers by adding:
//      self.hideKeyboardOnTap()
//  to the viewDidLoad() function

import Foundation
import UIKit

// Extends all UIViewControllers
extension UIViewController {
    
    func hideKeyboardOnTap() {
        // When UIViewController (not keyboard) is tapped, dismiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false // Won't override UICollection View selection
        view.addGestureRecognizer(tap) // Add gesture to view
    }
    
    // Dismiss keyboard
    func dismissKeyboard() {
        view.endEditing(true) // End keyboarding editing
    }
}
