//
//  CreditCard+CoreDataProperties.swift
//  Klink
//
//  Created by Mobile App Dev on 22/10/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CreditCard {

    @NSManaged var id: NSNumber?
    @NSManaged var cardholderName: String?
    @NSManaged var last4digits: String!
    @NSManaged var expiryMonth: String!
    @NSManaged var expiryYear: String!
    @NSManaged var brand: String?
    @NSManaged var isDefault: NSNumber!
    @NSManaged var user: User?
}
