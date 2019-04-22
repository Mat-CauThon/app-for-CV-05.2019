//
//  Skill+CoreDataProperties.swift
//  CollectionView
//
//  Created by Roman Mishchenko on 4/15/19.
//  Copyright © 2019 Razeware. All rights reserved.
//
//

import Foundation
import CoreData


extension Skill {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Skill> {
        return NSFetchRequest<Skill>(entityName: "Skill")
    }

    @NSManaged public var skillDiscription: String?
    @NSManaged public var skillName: String?

}
