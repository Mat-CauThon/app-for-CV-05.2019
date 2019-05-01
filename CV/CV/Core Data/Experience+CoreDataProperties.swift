//
//  Experience+CoreDataProperties.swift
//  CV
//
//  Created by Roman Mishchenko on 5/1/19.
//  Copyright © 2019 Roman Mishchenko. All rights reserved.
//
//

import Foundation
import CoreData


extension Experience {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Experience> {
        return NSFetchRequest<Experience>(entityName: "Experience")
    }

    @NSManaged public var xpDesc: String?

}
