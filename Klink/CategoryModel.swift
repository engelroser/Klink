//
//  CategoryModel.swift
//  Klink
//
//  Created by Mobile App Dev on 05/11/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit
import SwiftyJSON

class CategoryModel: NSObject {
    
    var id:Int!
    var name:String!
    var subcategories:[CategoryModel] = []
    
    var selectedAsSubcategory = false
    
    class func initCategoriesFromJSON(json:JSON) -> [CategoryModel] {
        var categories:[CategoryModel] = []
        for (_,subJson):(String, JSON) in json {
            let category = CategoryModel()
            category.name = subJson["name"].string
            category.id = subJson["id"].int
            var children:[CategoryModel] = []
            
            for (_,sub):(String, JSON) in subJson["children"] {
                let subcategory = CategoryModel()
                subcategory.name = sub["name"].string
                subcategory.id = sub["id"].int
                children.append(subcategory)
            }
            
            category.subcategories = children
            categories.append(category)
            
        }
        return categories
    }
    
    class func allCategories(storeID:Int!, completion:(categories:[CategoryModel], error:NSError?) -> Void) {
        let parameters:[String:AnyObject] = [
            "stores[]":storeID
        ]
        
        APIClient.sharedClient.klinkRequest(.GET, URLString: "categories/", parameters: parameters) { (response) -> Void in
            let result = response.result
            switch result {
            case .Success(let data):
                let c = CategoryModel.initCategoriesFromJSON(JSON(data))
                completion(categories: c, error:nil)
                break
                
            case .Failure(let error):
                completion(categories: [], error:error)
                break
            }
        }
        
    }

}
