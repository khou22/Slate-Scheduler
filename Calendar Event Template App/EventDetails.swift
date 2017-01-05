//
//  EventDetails.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/4/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import UIKit

class EventDetails: UIViewController {
    
    var category: Category = Category(name: "NA")
    
    override func viewDidLoad() {
        print("Creating event with category: " + self.category.name)
    }
}
