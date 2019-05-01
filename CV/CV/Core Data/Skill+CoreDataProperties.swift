//
//  Skill+CoreDataProperties.swift
//  CV
//
//  Created by Roman Mishchenko on 5/1/19.
//  Copyright © 2019 Roman Mishchenko. All rights reserved.
//
//

import Foundation
import CoreData


extension Skill {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Skill> {
        return NSFetchRequest<Skill>(entityName: "Skill")
    }

    @NSManaged public var category: String?
    @NSManaged public var skillDesc: String?
    @NSManaged public var skillName: String?

}
