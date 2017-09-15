//
//  LoginModel.swift
//  Klink
//
//  Created by Mobile App Dev on 08/09/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

 /// Response example:
    // ** Success ** //
    //{
    //    "access_token": "MzY3ZDdlMTYyMTUyYjI2ZjU0YWM5YmRlM2ZmNTZkNDQxZmUyY2Q4Yjc3NmQzZjA3NTgzY2Q5NjFmYzc1OGMxYw",
    //    "expires_in": 3600,
    //    "token_type": "bearer",
    //    "scope": null,
    //    "refresh_token": "YTgzNjE0NjU5YWYzOThlZWI1ZGRmMjI1M2Y4ZjFlMjlkOWM5NmVhNTc5OWE3ODdiMjYzOWQ1NzQ3MTc3MDA0ZQ"
    //}

    // ** Fail ** //
    //{
    //    "error": "invalid_grant",
    //    "error_description": "Invalid username and password combination"
    //}


import UIKit
import Alamofire
import SwiftyJSON

class LoginModel: NSObject {
    
    class func loginWithEmail(email: String, password: String, completion: (result: String!, error: ErrorType!) -> Void) {
        
        let parameters:[ String : AnyObject ]? = [
            "username" : email,
            "password": password,
            "grant_type" : "password",
            "client_id" : Constants.getAPIClientId(),
            "client_secret" : Constants.getAPIClientSecret()
        ]

        debugPrint("parameters: \(parameters)")
        
        APIClient.sharedClient.klinkRequest(.POST, URLString: "authentication/", parameters: parameters) { (response) -> Void in
            let result = response.result
            switch result {
            case .Success(let data):
                let json = JSON(data)
                SessionManager.setTokens(json["access_token"].string!, refreshToken: json["refresh_token"].string!)
                User.getUserProfile({ (success) -> Void in
                    
                })
                completion(result: "Successfully logged in.", error: nil)
                break
            case .Failure(let error):
                if let rawError = error.localizedDescription.dataUsingEncoding(NSUTF8StringEncoding) {
                    let errorLocalized = JSON(data: rawError)
                    completion(result: errorLocalized["message"].stringValue, error: error)
                }
                break
            }
        }
        
    }
   
}
