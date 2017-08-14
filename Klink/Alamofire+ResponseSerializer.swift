//
//  Alamofire+ResponseSerializer.swift
//  Klink
//
//  Created by Mobile App Dev on 17/11/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

extension Alamofire.Request{
    public static func KlinkResponseSerializer(options options: NSJSONReadingOptions = .AllowFragments) -> ResponseSerializer<AnyObject, NSError> {
        return ResponseSerializer { request, response, data, error in
            
            if response?.statusCode == 400 {
                guard let validData = data else {
                    let failureReason = "Data could not be serialized. Input data was nil."
                    let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
                    return .Failure(error)
                }
                do {
                    
                    let JSON = try NSJSONSerialization.JSONObjectWithData(validData, options: options)
                    let tempData = try NSJSONSerialization.dataWithJSONObject(JSON, options: NSJSONWritingOptions.PrettyPrinted)
                    
                    let jsonString = NSString(data: tempData, encoding: NSUTF8StringEncoding) as! String
                    
                    print("Custom serializer.......\(JSON)")
                    
                    let userInfo = [
                        NSLocalizedDescriptionKey : jsonString,
                        NSLocalizedFailureReasonErrorKey : "Bad request",
                        NSLocalizedRecoverySuggestionErrorKey : "Change request parameters"
                    ]
                    
                    let error = NSError(domain: "com.klinkdelivery", code: -10, userInfo: userInfo)
                    
                    return Result.Failure(error)
                } catch {
                    return .Failure(error as NSError)
                }
            }
            
            guard error == nil else { return Result.Failure(error!) }
           
            
            guard let validData = data else {
                let failureReason = "Data could not be serialized. Input data was nil."
                let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
                return .Failure(error)
            }
            
            do {
                if response?.statusCode == 204 {
                    let emptyResponse = "".dataUsingEncoding(NSUTF8StringEncoding)
                    return Result.Success(emptyResponse!)
                } else {
                    let JSON = try NSJSONSerialization.JSONObjectWithData(validData, options: options)
                    return Result.Success(JSON)
                }
            } catch {
                return .Failure(error as NSError)
            }
        }
    }
    
    public func responseKlink(completionHandler: Response<AnyObject, NSError> -> Void) -> Self {
        return response(responseSerializer: Request.KlinkResponseSerializer(), completionHandler: completionHandler)
    }
}
