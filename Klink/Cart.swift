
//
//  Cart.swift
//  Klink
//
//  Created by Mobile App Dev on 09/11/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON
import MagicalRecord

protocol CartDelegate {
    func cartTotalChanged()
}

class Cart: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    static let CART_SYNCED = "CART_SYNCED"
    
    class func getCart() -> Cart? {
        return Cart.MR_findFirst()
    }
    
    class func syncCart() {
        APIClient.sharedClient.klinkRequest(.GET, URLString: "cart/", parameters: nil, authorized: true) { (response) -> Void in
            let result = response.result
            switch result {
            case .Success(let data):
                let json = JSON(data)
                
                let cart = Cart.createCartFromJSON(json)
                Item.createItemsFromJSON(json["items"], forCart: cart)

                Cart.getCart()?.updateCart()
                break
            case .Failure(let error):
                print("cart sync error: \(error.localizedDescription)")
                break
            }
        }
    }
    
    class func syncCart(completion:(success:Bool, message:String) -> Void) {
        APIClient.sharedClient.klinkRequest(.GET, URLString: "cart/", parameters: nil, authorized: true) { (response) -> Void in
            let result = response.result
            switch result {
            case .Success(let data):
                let json = JSON(data)
                
                let cart = Cart.createCartFromJSON(json)
                Item.createItemsFromJSON(json["items"], forCart: cart)
                
                Cart.getCart()?.updateCart()
                completion(success: true, message: "")
                break
            case .Failure(let error):
                if let rawError = error.localizedDescription.dataUsingEncoding(NSUTF8StringEncoding) {
                    let errorLocalized = JSON(data: rawError)
                    completion(success: false, message: errorLocalized["message"].stringValue)
                }
                break
            }
        }
    }
    
    class func createLocalCart() {
        
        if let _ = Cart.MR_findFirst() {
            
        } else {
            let cart = Cart.MR_createEntity()
            cart!.total = NSDecimalNumber(double: 0)
            cart!.tipTotal = NSDecimalNumber(double: 0)
            cart!.taxTotal = NSDecimalNumber(double: 0)
            cart!.itemsTotal = NSDecimalNumber(double: 0)
            cart!.shippingTotal = NSDecimalNumber(double: 0)
            cart!.promotionTotal = NSDecimalNumber(double: 0)
            cart!.canCheckout = NSNumber(bool: false)
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(CART_SYNCED, object: nil)
    }
    
    class func createCartFromJSON(json:JSON) -> Cart {
        
        var temps:[Item] = [ ]
        
        if let oldCart = Cart.MR_findFirst() {
            for i in oldCart.items! {
                let item = i as! Item
                
                if item.local == nil && item.quantity == item.serverQuantity {
                    item.MR_deleteEntity()
                } else {
                    temps.append(item)
                }
            }
        }
        
        Cart.MR_truncateAll()
        let cart = Cart.MR_createEntity()
        cart!.total = NSDecimalNumber(double: json["total"].double!)
        cart!.tipTotal = NSDecimalNumber(double: json["tip_total"].double!)
        cart!.taxTotal = NSDecimalNumber(double: json["tax_total"].double!)
        cart!.itemsTotal = NSDecimalNumber(double: json["items_total"].double!)
        cart!.shippingTotal = NSDecimalNumber(double: json["shipping_total"].double!)
        cart!.promotionTotal = NSDecimalNumber(double: json["promotion_total"].double!)
        cart!.canCheckout = json["can_checkout"].bool
        cart!.checkoutMessage = json["checkout_message"].string

        for i in temps {
            if i.quantity?.integerValue > 0 {
                i.cart = cart
            } else {
                i.cart = nil
                i.MR_deleteEntity()
            }
        }
        
        
        return cart!
    }
    
    func addItem(product: ProductVariantModel, quantity: Int) {
        var updated:Bool = false
        for i in (Cart.getCart()?.items)! {
            let item = i as! Item
//            if ((item.local?.boolValue) != nil) {
                if item.variantID == product.id {
                    item.quantity = Int(item.quantity!) + quantity
                    updated = true
                    print("quantity changed: \(item.quantity)")
                    product.itemsInCart = (item.quantity?.integerValue)!
                }
//            }
        }
        
        if !updated {
            let item = Item.createItemFromProductVariant(product, forCart: self)
            item.local = NSNumber(bool: true)
        }
        
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreWithCompletion { (saved, error) -> Void in
        }
        
        updateCart()
    }
    
    func removeItem(product: ProductVariantModel) {
        
        if let item = Item.MR_findFirstByAttribute("variantID", withValue: product.id) {
            print("item updated...")
            
            item.quantity = Int(item.quantity!) - 1
            
            if Int(item.quantity!) == 0 && item.local != nil {
                item.cart = nil
                item.MR_deleteEntity()
            }
            print("NEW QUANTITY: \(item.quantity)")
        }
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreWithCompletion { (saved, error) -> Void in
        }
        
        updateCart()
    }
    
    func updateItem(product: ProductVariantModel) {
        if let item = Item.MR_findFirstByAttribute("id", withValue: product.id) {
            print("item updated...")
            item.quantity = product.itemsInCart + Int(item.quantity!)
        } else {
            let item = Item.createItemFromProductVariant(product, forCart: self)
            print("item created...price: \(item.unitPrice)")
        }
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreWithCompletion { (saved, error) -> Void in
        }
        updateCart()
    }
    
    
    func updateCart() {
        
        let cart = self
        
        var total:Double = 0
        for i in (cart.items)! {
            let item = (i as! Item)
            total += Double(item.unitPrice!) * Double(item.quantity!)
            print("Item: \(item.name), price: \(item.unitPrice), quantity: \(item.quantity)")
        }
        
        cart.itemsTotal = NSDecimalNumber(double: total)
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreWithCompletion { (saved, error) -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName(Cart.CART_SYNCED, object: nil)
        }
        
    }
    
    class func getOrderedItems() {
//        Item.
    }
    
//    {
//    "total": 45000,
//    "items_total": 45000,
//    "tax_total": 0,
//    "tip_total": 0,
//    "shipping_total": 0,
//    "promotion_total": 0,
//    "items": [
//    {
//    "id": 25,
//    "name": "BudLight 12-Pack Bottles",
//    "quantity": 4,
//    "unit_price": 5000,
//    "total": 20000
//    },
}