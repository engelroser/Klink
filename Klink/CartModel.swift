//
//  CartModel.swift
//  Klink
//
//  Created by Mobile App Dev on 06/11/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit

protocol CartModelDelegate {
    func cartTotalChanged()
}

class CartModel: NSObject {

    static let sharedInstance = CartModel()
    
    var delegate:CartModelDelegate?
    
    var itemsTotal:Int = 0
    var taxTotal: NSDecimalNumber?
    var tipTotal: NSDecimalNumber?
    var shippingTotal: NSDecimalNumber?
    var total: Double = 0.0 {
        didSet {
            delegate?.cartTotalChanged()
        }
    }
    var promotionTotal: NSDecimalNumber?
    var cartItems: NSSet?

//    func addItem(product: ProductVariantModel!) {
//        
//        if product.itemsInCart == 0 {
//            print("nope in cart: \(product.itemsInCart)")
//            return
//        }
//        print("Items in cart: \(product.itemsInCart)")
//        let parameters:[String:AnyObject] = [
//            "channel" : SessionManager.getCurrentStoreID()!,
//            "quantity" : product.itemsInCart,
//            "product" : product.id
//        ]
//        
//        total += Double(product.itemsInCart) * product.price
//        
//        APIClient.sharedClient.klinkRequest(.POST, URLString: "cart/", parameters: parameters, authorized: true) { (response) -> Void in
//            let result = response.result
//            switch result {
//            case .Success(let data):
//                
//                break
//                
//            case .Failure(let error):
//                
//                break
//            }
//        }
//    }
//    
//    func removeItem(product: ProductVariantModel!) {
////        let parameters:[String:AnyObject] = [
////            "channel" : SessionManager.getCurrentStoreID()!,
////            "quantity" : 1,
////            "product" : product.id
////        ]
////        
//        APIClient.sharedClient.klinkRequest(.DELETE, URLString: "cart/item/\(product.id)", parameters: nil, authorized: true) { (response) -> Void in
//            let result = response.result
//            switch result {
//            case .Success(let data):
//                
//                break
//                
//            case .Failure(let error):
//                
//                break
//            }
//        }
//    }
}
