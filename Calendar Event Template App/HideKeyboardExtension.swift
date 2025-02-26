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
    
    func hideKeyboardOnSwipe() {
        // When UIViewController (not keyboard) is swiped down, dismiss keyboard
        let swipeDown: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        swipeDown.direction = .down // Swipe down
        swipeDown.cancelsTouchesInView = false // Won't override UICollection/UITableView View selection
        
        let swipeRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        swipeRight.direction = .right
        swipeRight.cancelsTouchesInView = false
        
        let swipeLeft: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        swipeLeft.direction = .left
        swipeLeft.cancelsTouchesInView = false
        
        // When double tapping hide keyboard
        let doubleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        doubleTap.numberOfTapsRequired = 2
        
        view.addGestureRecognizer(swipeDown) // Add gesture to view
        view.addGestureRecognizer(swipeRight)
        view.addGestureRecognizer(swipeLeft)
        view.addGestureRecognizer(doubleTap) // Add touble tap to view
    }
    
    // Dismiss keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true) // End keyboarding editing
    }
}
