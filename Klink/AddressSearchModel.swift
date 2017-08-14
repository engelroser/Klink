//
//  AddressSearchModel.swift
//  Klink
//
//  Created by Mobile App Dev on 03/09/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AddressSearchModel {
    
    class func addressSugestions(address:String!, completion:(suggestions: [String], error:NSError!) -> Void ) -> Request?{
        let parameters : [ String : AnyObject] = [
            "address": address
        ]

        return APIClient.sharedClient.klinkRequest(.GET, URLString: "address-suggestions/", parameters: parameters, completionHandler: { (response) -> Void in
            let result = response.result
            switch (result) {
            case .Success(let data):
                let json = JSON(data)
                var suggestions:[String] = []
                for (_, subJson): (String, JSON) in json["suggestions"] {
                    suggestions.append(subJson.rawValue as! String)
                }
                print("got suggestions: \(suggestions)")
                completion(suggestions: suggestions, error: nil)
                break
            case .Failure(let error):
                completion(suggestions: [], error: error)
                break
            }
        })

    }
    
    class func geocode(address:String, completion:(lat:Double?, long:Double?, address: String?, error:NSError!) -> Void) {
        
        let aString: String = address
        let newString = aString.stringByReplacingOccurrencesOfString("&", withString: "and")
        
        let escapedString = newString.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        print("escapedString: \(escapedString)")
        
        let parameters : [ String : AnyObject] = [
            "address": newString
        ]
        
        print("geocode paramaters: \(parameters)")
        
        APIClient.sharedClient.klinkRequest(.GET, URLString: "geocode/", parameters: parameters) { (response) -> Void in
            let result = response.result
            
            print("sjfjdfklsaddress; \(response.response?.URL)")
            
            switch (result) {
            case .Success(let data):
                let json = JSON(data)
                
                print("Geocode result: \(json)")
                
                completion(lat: json["latitude"].double!, long: json["longitude"].double!, address: json["value"].string!, error: nil)
                break
            case .Failure(let error):
                
                completion(lat: nil, long: nil, address: nil, error: error)
                break
            }
        }
    }
    
    class func geocodeReverse(lat:Double, long:Double, completion:(address:RecentAddress?, error:NSError?) -> Void) {
        let parameters : [ String : AnyObject] = [
            "latitude": lat,
            "longitude": long
        ]
        
        APIClient.sharedClient.klinkRequest(.GET, URLString: "geocode-reverse/", parameters: parameters) { (response) -> Void in
            let result = response.result
            switch (result) {
            case .Success(let data):
                let json = JSON(data)
                print("Geocode reverse result: \(json)")
//                "street": "Ribnjak ulica 2",
//                "locality": "Zagreb",
//                "postal_code": "10000",
//                "country_code": "HR",
//                "administrative_area": "City of Zagreb"
                let address = RecentAddress.MR_createEntity()
                address!.locality = json["locality"].string
                address!.street = json["street"].string
                address!.postalCode = json["postal_code"].string
                address!.countryCode = json["country_code"].string
                address!.administrativeArea = json["administrative_area"].string
                completion(address: address, error: nil)
                
//                completion(lat: json["latitude"].double!, long: json["longitude"].double!, address: json["value"].string!, error: nil)
                break
            case .Failure(let error):
                completion(address: nil, error: error)
//                completion(lat: nil, long: nil, address: nil, error: error)
                break
            }
        }
        
    }
    
    
}
