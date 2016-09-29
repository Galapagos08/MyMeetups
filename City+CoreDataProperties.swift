//
//  City+CoreDataProperties.swift
//  MyMeetups
//
//  Created by Dan Esrey on 2016/28/09.
//  Copyright © 2016 Dan Esrey. All rights reserved.
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City");
    }

    @NSManaged public var name: String?
    @NSManaged public var state: String?

}
