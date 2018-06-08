//
//  Sample+CoreDataProperties.swift
//  
//
//  Created by iOS Developer2 on 5/18/18.
//
//

import Foundation
import CoreData


extension Sample {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sample> {
        return NSFetchRequest<Sample>(entityName: "Sample")
    }

    @NSManaged public var value: [NSNumber]?

}
