//
//  MapStoreModel.swift
//  Klink
//
//  Created by Mobile App Dev on 10/09/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MapStoreModel {
    
    enum StoreAvailability {
        case Available
        case Unavailable
        case NotHereYet
        case Unknown
    }
    
    class func fetchStores(latitude: Double, longitude: Double, completion:(storeStatus: StoreAvailability?, storesIDs: [Int]?, error:String?) -> Void) -> Request? {
        let parameters:[ String : AnyObject]? = [
            "latitude": latitude,
            "longitude": longitude
        ]
        
        return APIClient.sharedClient.klinkRequest(.GET, URLString: "stores/", parameters: parameters, completionHandler: { (response) -> Void in
            let result = response.result
            switch (result) {
            case .Success(let data):
                let json = JSON(data)
                var storesIDs:[Int] = []
                var storeAvailability:StoreAvailability = StoreAvailability.NotHereYet
    
                if json["available"].array!.count > 0 {
                    let available = json["available"].array
                    if available!.count > 0 {
                        for store in available! {
                            storesIDs.append(store["id"].int!)
                        }
                        storeAvailability = StoreAvailability.Available
                    }
                } else if json["unavailable"].array!.count > 0 {
                    let unavailable = json["unavailable"].array
                    if unavailable!.count > 0 {
                        for store in unavailable! {
                            storesIDs.append(store["id"].int!)
                        }
                        storeAvailability = StoreAvailability.Unavailable
                    }
                }
                
                completion(storeStatus: storeAvailability, storesIDs: storesIDs, error: nil)
                break
            case .Failure(let error):
                if let rawError = error.localizedDescription.dataUsingEncoding(NSUTF8StringEncoding) {
                    let errorLocalized = JSON(data: rawError)
                    completion(storeStatus: nil, storesIDs: nil, error: errorLocalized["message"].stringValue)
                }
                break
            }
        })
    }
    
}
