//
//  Item.swift
//  Klink
//
//  Created by Mobile App Dev on 09/11/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

class Item: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    class func createItemFromProductVariant(product: ProductVariantModel, forCart cart:Cart!) -> Item {
        let item = Item.MR_createEntity()
        item!.id = product.id
        item!.name = product.presentation
        item!.image = product.imagePath
        item!.unitPrice = NSDecimalNumber(double: product.price)
        item!.total = NSDecimalNumber(double: product.price * Double(product.itemsInCart))
        item!.quantity = product.itemsInCart
        item!.variantID = product.id
        item!.serverQuantity = item!.quantity
        item!.cart = cart
        
        return item!
    }
    
    class func createItemsFromJSON(json: JSON, forCart cart: Cart!) {
        var items:[Item] = []
        for (_,subJson):(String, JSON) in json {
            var updated:Bool = false
            for i in (Cart.getCart()?.items)! {
                let item = i as! Item
                //            if ((item.local?.boolValue) != nil) {
                if item.variantID == subJson["variant_id"].int {
                    item.serverQuantity = subJson["quantity"].int
                    updated = true
                    print("quantity changed: \(item.quantity)")
//                    product.itemsInCart = (item.quantity?.integerValue)!
                }
                //            }
            }
            
            if !updated {
                let item = Item.MR_createEntity()
                item!.id = subJson["id"].int
                item!.name = subJson["name"].string
                item!.image = subJson["image"].string
                item!.unitPrice = NSDecimalNumber(double: subJson["unit_price"].double!)
                item!.total = NSDecimalNumber(double: subJson["total"].double!)
                item!.quantity = subJson["quantity"].int
                item!.serverQuantity = item!.quantity
                item!.variantID = subJson["variant_id"].int
                item!.cart = cart

            }
            
            
//            for i in (Cart.getCart()?.items)! {
//                let itemLocal = i as! Item
////                print("HELLooooooo ;\(itemLocal.serverQuantity)")
//                if itemLocal.variantID == item.variantID {
////                    print("HELLooooooo ;\(itemLocal.quantity)")
//                    if itemLocal.quantity! > itemLocal.serverQuantity! {
//                        item.quantity = item.quantity!.integerValue + itemLocal.quantity!.integerValue - itemLocal.serverQuantity!.integerValue
//                    } else if itemLocal.quantity! < itemLocal.serverQuantity! {
//                        item.quantity = item.quantity!.integerValue - itemLocal.serverQuantity!.integerValue - itemLocal.quantity!.integerValue
//                    }
//                }
//                itemLocal.cart = nil
//                itemLocal.MR_deleteEntity()
//            }
//            items.append(item)
        }
    }
    
    class func seedItems() -> [Item] {
        let item1 = Item.MR_createEntity()
        item1!.name = "test name 1"
        
        let item2 = Item.MR_createEntity()
        item2!.name = "test name 2"
        
        return [item1!, item2!]
    }
}
