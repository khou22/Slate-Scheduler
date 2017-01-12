//
//  CategoryEditing.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/11/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import UIKit

class CategoryEditing: UIViewController {
    
    @IBAction func closeEditing(_ sender: Any) {
        dismiss(animated: true, completion: nil) // Exit segue back to category selection
    }
    
    @IBAction func pressedEditing(_ sender: Any) {
        print("Pressed editing")
    }
}
