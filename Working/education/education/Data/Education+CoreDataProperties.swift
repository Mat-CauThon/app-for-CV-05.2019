//
//  Education+CoreDataProperties.swift
//  education
//
//  Created by Roman Mishchenko on 4/29/19.
//  Copyright © 2019 Roman Mishchenko. All rights reserved.
//
//

import Foundation
import CoreData


extension Education {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Education> {
        return NSFetchRequest<Education>(entityName: "Education")
    }

    @NSManaged public var organization: String?
    @NSManaged public var startYear: String?
    @NSManaged public var endYear: String?

}
