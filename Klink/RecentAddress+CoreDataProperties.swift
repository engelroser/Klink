//
//  RecentAddress+CoreDataProperties.swift
//  Klink
//
//  Created by Mobile App Dev on 05/11/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension RecentAddress {

    @NSManaged var administrativeArea: String?
    @NSManaged var countryCode: String?
    @NSManaged var locality: String?
    @NSManaged var postalCode: String?
    @NSManaged var street: String?
    @NSManaged var stateName: String?
    @NSManaged var current: NSNumber?

}
