//
//  Address.swift
//  Klink
//
//  Created by Mobile App Dev on 29/10/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

class Address: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    class func addAddressToCurrentUser(json:JSON, completion:(success: Bool) -> Void) {
        let address = Address.MR_createEntity()
        address!.addressLine1 = json["address_line1"].string
        address!.addressLine2 = json["address_line2"].string
        address!.stateCode = json["administrative_area"].string
        address!.countryCode = "US"
        address!.city = json["locality"].string
        address!.zipCode = json["postal_code"].string
        address!.id = json["id"].int
        address!.isDefault = NSNumber(bool:false)
        
        let user = SessionManager.currentUser()
        address!.user = user
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreWithCompletion { (saved, error) -> Void in
            if saved {
                completion(success: true)
            } else {
                completion(success: false)
            }
        }
    }
    
    class func initAddressesFromJSON(user: User!, json: JSON) {
        var addresses:[Address] = []
        //        var addresses = NSMutableSet(set: user.addresses!)
        for (_,subJson):(String, JSON) in json {
            
            let address = Address.MR_createEntity()
            address!.addressLine1 = subJson["address_line1"].string
            address!.addressLine2 = subJson["address_line2"].string
            address!.stateCode = subJson["administrative_area"].string
            address!.countryCode = "US"
            address!.city = subJson["locality"].string
            address!.zipCode = subJson["postal_code"].string
            address!.id = subJson["id"].int
            address!.user = user
            address!.isDefault = NSNumber(bool:false)
            addresses.append(address!)
        }
//        completion(success: true)
        
    }
    

}
