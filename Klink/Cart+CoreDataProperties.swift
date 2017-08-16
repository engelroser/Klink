//
//  Cart+CoreDataProperties.swift
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

extension Cart {

    @NSManaged var total: NSDecimalNumber?
    @NSManaged var shippingTotal: NSDecimalNumber?
    @NSManaged var taxTotal: NSDecimalNumber?
    @NSManaged var tipTotal: NSDecimalNumber?
    @NSManaged var promotionTotal: NSDecimalNumber?
    @NSManaged var itemsTotal: NSDecimalNumber?
    @NSManaged var items: NSSet?
    @NSManaged var canCheckout: NSNumber?
    @NSManaged var checkoutMessage: String?
}
