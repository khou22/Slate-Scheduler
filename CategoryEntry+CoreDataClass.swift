//
//  CategoryEntry+CoreDataClass.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/28/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import CoreData

@objc(CategoryEntry)
public class CategoryEntry: NSManagedObject {
    @NSManaged public var name: String?
}
