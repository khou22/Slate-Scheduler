//
//  CategoryEntry+CoreDataProperties.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/28/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import CoreData


extension CategoryEntry {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CategoryEntry> {
        return NSFetchRequest<CategoryEntry>(entityName: "CategoryEntry");
    }

}
