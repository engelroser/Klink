//
//  PackItemModel.swift
//  Klink
//
//  Created by Mobile App Dev on 11/11/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit
import SwiftyJSON

class PackItemModel: NSObject {
    var id:Int!
    var quantity:Int!
    var tempQuantity = 0
    var name: String!
    var descr: String!
    var product: ProductModel!
    
    class func initItemsFromJSON(json: JSON) -> [PackItemModel] {
        var temp:[PackItemModel] = []
        for (_,subJson):(String, JSON) in json {
            //            print("key: \(key), value: \(subJson)")
            
            let currentLocale: String = subJson["product"]["current_locale"].string!
            
            let item = PackItemModel()
            
            item.id = subJson["id"].int
            item.quantity = subJson["quantity"].int
            item.tempQuantity = item.quantity
            
            item.descr = subJson["product"]["translations"][currentLocale]["description"].string
            item.name  = subJson["product"]["translations"][currentLocale]["name"].string
            
            item.product = ProductModel.initPackProductFromJSON(subJson["product"])
            temp.append(item)
        }
        
        return temp
    }

}
