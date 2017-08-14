//
//  Address+CoreDataProperties.swift
//  Klink
//
//  Created by Mobile App Dev on 29/10/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Address {

    @NSManaged var addressLine1: String?
    @NSManaged var addressLine2: String?
    @NSManaged var city: String?
    @NSManaged var countryCode: String?
    @NSManaged var id: NSNumber?
    @NSManaged var isDefault: NSNumber?
    @NSManaged var name: String?
    @NSManaged var stateCode: String?
    @NSManaged var zipCode: String?
    @NSManaged var user: User?
    
}
