//
//  Item+CoreDataProperties.swift
//  Klink
//
//  Created by Mobile App Dev on 09/11/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Item {

    @NSManaged var id: NSNumber?
    @NSManaged var variantID: NSNumber?
    @NSManaged var name: String?
    @NSManaged var image: String?
    @NSManaged var quantity: NSNumber?
    @NSManaged var serverQuantity: NSNumber?
    @NSManaged var unitPrice: NSDecimalNumber?
    @NSManaged var total: NSDecimalNumber?
    @NSManaged var cart: NSManagedObject?
    @NSManaged var local: NSNumber?

}
