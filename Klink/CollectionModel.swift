//
//  CollectionModel.swift
//  Klink
//
//  Created by Mobile App Dev on 30/10/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class CollectionModel: NSObject {

    var id:Int!
    var name:String!
    var color:String!
    var desc:String?
    var image:String?
    
    class func initCollectionsFromJSON(json:JSON) -> [CollectionModel ] {
        var temp:[CollectionModel] = []
        for (_,subJson):(String, JSON) in json {
//            print("key: \(key), value: \(subJson)")
            
            let collection = CollectionModel()
            collection.name = subJson["name"].string
            collection.id = subJson["id"].int
            collection.color = subJson["color"].string
            collection.desc = subJson["description"].string
            collection.image = subJson["image"].string
            temp.append(collection)
        }

        return temp
    }
    
    class func getCollectionsByStore(id:Int, completion:(collections:[CollectionModel]?, error:NSError?) -> Void) -> Request? {
        
        let parameters:[String : AnyObject]? = [
            "stores[]" : SessionManager.getCurrentStoreID()!
        ]
        
        return APIClient.sharedClient.klinkRequest(.GET, URLString: "collections/", parameters: parameters, authorized: true) { (response) -> Void in
            let result = response.result
            switch result {
            case .Success(let data):
                let json = JSON(data)
                let c = CollectionModel.initCollectionsFromJSON(json)
                completion(collections: c, error: nil)
                break
            case .Failure(let error):
                completion(collections: nil, error: error)
                break
            }
        }
    }
    
}
