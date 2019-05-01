//
//  Education+CoreDataProperties.swift
//  CV
//
//  Created by Roman Mishchenko on 5/1/19.
//  Copyright © 2019 Roman Mishchenko. All rights reserved.
//
//

import Foundation
import CoreData


extension Education {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Education> {
        return NSFetchRequest<Education>(entityName: "Education")
    }

    @NSManaged public var endYear: String?
    @NSManaged public var organization: String?
    @NSManaged public var startYear: String?

}
