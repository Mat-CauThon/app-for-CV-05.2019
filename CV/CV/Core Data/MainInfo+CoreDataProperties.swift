//
//  MainInfo+CoreDataProperties.swift
//  CV
//
//  Created by Roman Mishchenko on 5/1/19.
//  Copyright © 2019 Roman Mishchenko. All rights reserved.
//
//

import Foundation
import CoreData


extension MainInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MainInfo> {
        return NSFetchRequest<MainInfo>(entityName: "MainInfo")
    }

    @NSManaged public var name: String?
    @NSManaged public var surname: String?
    @NSManaged public var number: String?
    @NSManaged public var eMail: String?
    @NSManaged public var dob: NSDate?
    @NSManaged public var photo: NSData?

}
