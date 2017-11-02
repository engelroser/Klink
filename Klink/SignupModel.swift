//
//  SignupModel.swift
//  Klink
//
//  Created by Mobile App Dev on 02/09/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//



import Foundation
import Alamofire
import SwiftyJSON

class SignupModel {
//     User Register response //
//    {
//        "email": "tomo+5@arsfutura.co",
//        "email_canonical": "tomo+5@arsfutura.co",
//        "id": 58,
//        "username": "tomo+5@arsfutura.co",
//        "username_canonical": "tomo+5@arsfutura.co",
//        "enabled": true,
//        "roles": [
//        "ROLE_USER"
//        ],
//        "birthday": "2015-10-12T00:00:00+0000",
//        "full_name": "Tomislav",
//        "preferences": [],
//        "credit_cards": [],
//        "addresses": []
    
    /**
    User registration
    
    - parameter fullName:        User full name
    - parameter email:           User email
    - parameter password:        User password
    - parameter confirmPassword: User confirm password
    - parameter dob:             User date of birth
    - parameter completion:      Completion handler, returns info as String
    */
    func signup(fullName: String!, email: String!, password: String!, confirmPassword: String!, dob: NSDate!, completion: (result: String!, error: ErrorType!) -> Void) {
        
        let dtFormatter = NSDateFormatter()
        dtFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateOfBirth:String = dtFormatter.stringFromDate(dob)
        let parameters : [ String : AnyObject] = [
            "fullName" : fullName,
            "email" : email,
            "plainPassword" : [
                "first": password,
                "second": confirmPassword
                ],
            "birthday" : dateOfBirth
        ]

        print("Parameters: \(parameters)")
        
//        
//        Alamofire.request(.POST, "\(APIClient.apiEndPoint)/user/register/", parameters: parameters, encoding: .JSON, headers: nil).response { (request, response, data, error) -> Void in
//            
////            if response.s
//            
//            
//            print("JUHUUUUUU \(JSON(data!)), \(request?.URL)")
//        
//        }
        
        
        let _ = APIClient.sharedClient.klinkRequest(.POST, URLString: "user/register/", parameters: parameters) { (response) -> Void in
            let result = response.result
            switch (result) {
            case .Success(let data):
                
                let json = JSON(data)
                
                User.initWithJSON(json, completion: { (createdUser) -> Void in
                    LoginModel.loginWithEmail(createdUser!.email, password: password, completion: { (result, error) -> Void in
                        if !(error != nil) {
                            completion(result: "Hi \(createdUser!.fullName), welcome to Klink.", error: nil)
                        }
                    })
                })
                
                break
            case .Failure(let error):
                if let rawError = error.localizedDescription.dataUsingEncoding(NSUTF8StringEncoding) {
                    let errorLocalized = JSON(data: rawError)
                    
                    var errorValues = [String]()
                    
                    for (_, value) in errorLocalized["errors"].dictionaryValue.enumerate() {
                        errorValues.append("\(value.1[0])")
                    }
                    
                    if errorValues.count == 0 {
                        completion(result: errorLocalized["message"].stringValue, error: error)
                    } else {
                        completion(result: errorValues[0], error: error)
                    }
                }
                break
            }
        }
    }
    
    
}
