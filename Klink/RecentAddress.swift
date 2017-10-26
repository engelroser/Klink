//
//  RecentAddress.swift
//  Klink
//
//  Created by Mobile App Dev on 05/11/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import Foundation
import CoreData
import MagicalRecord

class RecentAddress: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    class func currentDeliveryAddress() -> RecentAddress? {
        let addresses = RecentAddress.MR_findAll() as! [RecentAddress]
        
        for a in addresses {
            if let current = a.current {
                let b = current as Bool
                if b {
                    return a
                }
            }
        }
        
        return nil
    }

    class func setAsCurrent(address: RecentAddress!) {
        let addresses = RecentAddress.MR_findAll() as! [RecentAddress]
        
        for a in addresses {
            a.current = false
        }
        
        address.current = true
        
    }
    
}
