//
//  ProductVariantModel.swift
//  Klink
//
//  Created by Mobile App Dev on 04/11/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProductVariantModel: NSObject {

    var id:Int!
    var presentation:String!
    var price:Double!
    var sku:String?
    var imagePath:String?
    var itemsInCart:Int = 0 {
        didSet {
            if itemsInCart < 0 {
                itemsInCart = 0
            }
        }
    }
    var availableOnDemand:Bool!
    
    class func initVariantFromJSON(json:JSON) -> ProductVariantModel {
//        var models:[ProductVariantModel] = []
//        for (_,subJson):(String, JSON) in json {
            //            print("key: \(key), value: \(subJson)")
            
            let variant = ProductVariantModel()
            variant.id = json["id"].int
            variant.presentation = json["presentation"].string
            variant.price = json["price"].double
            variant.availableOnDemand = json["available_on_demand"].bool
            variant.imagePath = json["image"].string
        
        
        for i in (Cart.getCart()?.items)! {
            let item = i as! Item
//            if ((item.local?.boolValue) != nil) {
                if item.variantID == variant.id {
                    variant.itemsInCart += Int(item.quantity!)
                }
//            }
        }
        
        NSNotificationCenter.defaultCenter().addObserver(variant, selector: #selector(ProductVariantModel.cartSynced), name: Cart.CART_SYNCED, object: nil)
//            NSNotificationCenter.defaultCenter().addObserver(variant, selector: "clearItemsinCart", name:CartFullViewController.cartsyncedwithserver, object: nil)
        return variant
//            models.append(variant)
//        }
        
//        return models
    }
    
    class func initVariantsFromJSON(json:JSON) -> [ProductVariantModel] {
        var models:[ProductVariantModel] = []
        for (_,subJson):(String, JSON) in json {
//            print("key: \(key), value: \(subJson)")
            
            let variant = ProductVariantModel()
            variant.id = subJson["id"].int
            variant.presentation = subJson["presentation"].string
            variant.price = subJson["price"].double
            variant.availableOnDemand = subJson["available_on_demand"].bool
            variant.imagePath = subJson["image"].string
            
            for i in (Cart.getCart()?.items)! {
                let item = i as! Item
//                if ((item.local?.boolValue) != nil) {
                    if item.variantID == variant.id {
                        variant.itemsInCart += Int(item.quantity!)
                    }
//                }
//                }
            }
            
            
//            NSNotificationCenter.defaultCenter().addObserver(variant, selector: "clearItemsinCart", name:CartFullViewController.cartsyncedwithserver, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(variant, selector: "cartSynced", name: Cart.CART_SYNCED, object: nil)
            models.append(variant)
        }
        
        return models
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func cartSynced() {
        self.itemsInCart = 0
        for i in (Cart.getCart()?.items)! {
            let item = i as! Item
            //                if ((item.local?.boolValue) != nil) {
            if item.variantID == self.id {
                self.itemsInCart += Int(item.quantity!)
            }
            //                }
            //                }
        }
    }
    
    func clearItemsinCart() {
        print("clear items")
//        self.itemsInCart = 0
    }
    
}
