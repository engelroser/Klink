//
//  PackModel.swift
//  Klink
//
//  Created by Mobile App Dev on 03/11/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class PackModel: NSObject {

    var id:Int!
    var name:String!
    var packDescription: String?
    var imagePath:String?
    var thumbnail:String?
    var packItems:[PackItemModel] = []
    
    class func initPacksFromJSON(json:JSON) -> [PackModel ] {
        var temp:[PackModel] = []
        for (_,subJson):(String, JSON) in json {
//            print("key: \(key), value: \(subJson)")
            
            let pack = PackModel()
            pack.name = subJson["name"].string
            pack.packDescription = subJson["description"].string
            pack.id = subJson["id"].int
            pack.imagePath = subJson["image"].string
            pack.thumbnail = subJson["thumbnail"].string
            temp.append(pack)
        }
        
        return temp
    }
    
    class func initPackFromJSON(json: JSON) -> PackModel {
        let pack = PackModel()
        pack.name = json["name"].string
        pack.packDescription = json["description"].string
        pack.id = json["id"].int
        pack.imagePath = json["image"].string
        
        return pack
    }
    

    class func getPackages(storeID:Int, collectionID:Int, page:Int, completion:(packs:[PackModel]?, error:NSError?) -> Void) -> Request?{
        
        let parameters:[String:AnyObject] = [
            "stores[]": SessionManager.getCurrentStoreID()!,
            "collections[]" : collectionID
        ]
        
        return APIClient.sharedClient.klinkRequest(.GET, URLString: "packages/", parameters: parameters, completionHandler: { (response) -> Void in
            let result = response.result
            switch result {
            case .Success(let data):
                let json = JSON(data)
                let c = PackModel.initPacksFromJSON(json)
                print("csdcds; \(c)")
                completion(packs: c, error: nil)
                break
            case .Failure(let error):
                completion(packs: nil, error: error)
                break
            }
            
        })
    }
    
    class func getPackage(id: Int!, completion:(pack:PackModel?, error:NSError?) -> Void) {
        
        APIClient.sharedClient.klinkRequest(.GET, URLString: "packages/\(id)/?stores[]=\(SessionManager.getCurrentStoreID()!)", parameters: nil) { (response) -> Void in
            let result = response.result
            switch result {
            case .Success(let data):
                let json = JSON(data)
                
                let pack = PackModel.initPackFromJSON(json)
                pack.packItems = PackItemModel.initItemsFromJSON(json["package_items"])
                
                completion(pack:pack, error: nil)
                break
                
            case .Failure(let error):
                
                completion(pack:nil, error: error)
                break
            }
        }
        
        
    }
}
