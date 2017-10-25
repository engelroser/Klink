//
//  ProductModel.swift
//  Klink
//
//  Created by Mobile App Dev on 04/11/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProductModel: NSObject {
    
    var id:Int!
    var name:String!
    var desc:String!
    var color:String!
    var imagePath:String?
    
    var variants:[ProductVariantModel] = []
    
    class func initProductsFromJSON(json:JSON) -> [ProductModel] {
        var models:[ProductModel] = []
        for (_,subJson):(String, JSON) in json {
            //            print("key: \(key), value: \(subJson)")
            
            let product = ProductModel()
            product.name = subJson["name"].string
            product.desc = subJson["description"].string
            product.color = subJson["color"].string
            product.id = subJson["id"].int
            product.imagePath = subJson["image"].string
            product.variants = ProductVariantModel.initVariantsFromJSON(subJson["variants"])
            
            models.append(product)
        }
        
        return models
    }
    
    class func initPackProductFromJSON(json:JSON) -> ProductModel {
        
        let product = ProductModel()
        
        let currentLocale: String = json["current_locale"].string!
        
        product.name = json["translations"][currentLocale]["name"].string
        product.desc = json["translations"][currentLocale]["description"].string
        product.color = json["color"].string
        product.id = json["id"].int
        product.imagePath = json["variants"][0]["image"].string
        product.variants = ProductVariantModel.initVariantsFromJSON(json["variants"])
        
        return product
    }
    
    
    class func allProductsBy(name:String?, page:Int!, storeID:Int!, completion:(products:[ProductModel]?, page:Int!, total: Int!, error:NSError?) -> Void) {
        
        var parameters:[String:AnyObject] = [
            "stores[]": SessionManager.getCurrentStoreID()!,
            "page": page!
        ]
        
        if let n = name {
            parameters["name"] = n
        }
        
        APIClient.sharedClient.klinkRequest(.GET, URLString: "products/", parameters: parameters) { (response) -> Void in
            let result = response.result
            switch result {
            case .Success(let data):
                let json = JSON(data)
                let products = ProductModel.initProductsFromJSON(json["items"])
                let page = json["page"].int
                let total = json["total"].int
                
                completion(products: products, page: page, total: total, error: nil)
                break
                
            case .Failure(let error):
                completion(products: [], page: 1, total: 0, error: error)
                break
            }
        }
    }
    
    class func allProductsByCategory(category: CategoryModel!, page:Int!, storeID:Int!, completion:(products:[ProductModel]?, page:Int!, total: Int!, error:NSError?) -> Void) {
        
        var parameters:[String:AnyObject] = [
            "stores[]": SessionManager.getCurrentStoreID()!,
            "categories[]" : category.id,
            "page": page!
        ]
        
        var subcategories:[Int] = []
        for c in category.subcategories {
            if c.selectedAsSubcategory {
                subcategories.append(c.id)
            }
        }
        
        var endpoint = "stores[]=\(SessionManager.getCurrentStoreID()!)&page=\(page)"
        
        if subcategories.count > 0 {
            for id in subcategories {
                parameters["categories[]"] = id
                endpoint = "\(endpoint)&categories[]=\(id)"
            }
        } else {
            endpoint = "\(endpoint)&categories[]=\(category.id)"
        }
        
        
        print("PARAMETERS: \(parameters)")
        
        print("END POINT: \(endpoint)")
        APIClient.sharedClient.klinkRequest(.GET, URLString: "products/?\(endpoint)", parameters: nil) { (response) -> Void in
            let result = response.result
            switch result {
            case .Success(let data):
                let json = JSON(data)
                let products = ProductModel.initProductsFromJSON(json["items"])
                let page = json["page"].int
                let total = json["total"].int
                
                completion(products: products, page: page, total: total, error: nil)
                break
                
            case .Failure(let error):
                completion(products: [], page: 1, total: 0, error: error)
                break
            }
        }
    }
}


//{
//    "variants": {
//        "1": {
//            "id": 2,
//            "presentation": "BudLight 12-Pack Cans",
//            "options": [
//            {
//            "name": "Container type",
//            "value": "Can"
//            },
//            {
//            "name": "Pack size",
//            "value": "12"
//            }
//            ],
//            "sku": "budlight12cans",
//            "price": 1000,
//            "on_hold": 0,
//            "available_on_demand": true
//        }
//    },
//    "id": 1,
//    "attributes": [
//    {
//    "name": "Alcohol Percentage",
//    "presentation": "Alcohol Content",
//    "id": 1,
//    "value": "4.3"
//    }
//    ],
//    "masterVariant": {
//        "id": 1,
//        "presentation": "Bud Light",
//        "options": [],
//        "sku": "budlight",
//        "price": 1000,
//        "on_hold": 0,
//        "available_on_demand": true
//    },
//    "name": "Bud Light",
//    "description": "...",
//    "color": "#000000"
//}
