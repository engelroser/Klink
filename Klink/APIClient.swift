//
//  APIClient.swift
//  Klink
//
//  Created by Mobile App Dev on 31/08/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum KlinkError: ErrorType {
    case NetworkError
}

public class APIClient : Manager {
    static let sharedClient = APIClient()
    
    static let apiEndPoint: String = Constants.getAPIEndpoint()
    
    public typealias NetworkSuccessHandler = (AnyObject?) -> Void
    public typealias NetworkFailureHandler = (NSHTTPURLResponse?, AnyObject?, NSError) -> Void
    
    typealias SuccessHandler = (data: AnyObject?) -> Void
    typealias FailureHandler = (errorType: ErrorType?) -> Void
    typealias CompletionHandler = (response: Response<AnyObject, NSError>) -> Void
    
    private typealias CachedTask = (NSHTTPURLResponse?, Response<AnyObject, NSError>?) -> Void
    
    private var cachedTasks = Array<CachedTask>()
    private var isRefreshing = false
    
    func klinkRequest(
        method: Alamofire.Method,
        URLString: URLStringConvertible,
        parameters: [ String: AnyObject ]?,
//        encoding: ParameterEncoding,
        completionHandler: CompletionHandler!
        ) -> Request? {
            let url = "\(APIClient.apiEndPoint)/\(URLString)"
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            
            let request = Alamofire.request(method, url, parameters: parameters, encoding: .URL, headers: nil).validate().responseKlink { (response) -> Void in
                let result = response.result

                UIApplication.sharedApplication().networkActivityIndicatorVisible = false

                switch response.result {
                case .Success:
                    print("response KLINK: \(response)")
                    completionHandler(response: response)
                    break
                case .Failure(let error):
                    print("Response: \(response)")
                    print("Response url: \(response.response?.URL)")
                    print("Failed KLINK: \(error.localizedDescription)")
                    print("Data error: \(result.value)")

                    completionHandler(response: response)
                    
                    break
                }
            }
    
    
            
            return request
    }
    
    func klinkRequest(
        method: Alamofire.Method,
        URLString: URLStringConvertible,
        parameters: [ String: AnyObject ]?,
        authorized: Bool,
        completionHandler: CompletionHandler!
        ) -> Request? {
            let url = "\(APIClient.apiEndPoint)/\(URLString)"
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            
            let cachedTask: CachedTask = { [weak self] URLResponse, response in
                if let _ = self {
                    let result = response!.result
                    
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    
                    switch result {
                    case .Failure(_):
                        completionHandler(response: response!)
                        break
                    case .Success(_):
                        print("Repeat:")
                        APIClient.sharedClient.klinkRequest(
                            method,
                            URLString: URLString,
                            parameters: parameters,
                            authorized: authorized,
                            completionHandler: completionHandler)
                        break
                    }
                }
                
            }

            if self.isRefreshing {
                self.cachedTasks.append(cachedTask)
                return nil
            }
            print("URL: \(url)")
            var headers = [
                "Accept": "application/json"
            ]
            
            if authorized {
                if let accessToken = SessionManager.getAccessToken() {
                    headers.updateValue("Bearer \(accessToken)", forKey: "Authorization")
                }
            }
            
            let request = Alamofire.request(method, url, parameters: parameters, encoding: .URL, headers: headers).validate().responseKlink { (response) -> Void in
                let result = response.result
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                switch result {
                case .Success:
                    print("response: \(response)")
                    completionHandler(response: response)
                    break
                    
                case .Failure(let error):
                    print("Failed KLINK: \(error.localizedDescription)")
                    
                    if response.response?.statusCode == 403 {
                        let strongSelf = self
                        strongSelf.cachedTasks.append(cachedTask)
                        
                        if !self.isRefreshing {
                            strongSelf.renewToken()
                            print("RENEWING TOKEN FROM klinkRequestAuthorized")
                        }
                        
                        return
                    }
                    completionHandler(response: response)
                    
                    break
                }
            }
            return request
    }
    
    func klinkRequest2(
        method: Alamofire.Method,
        URLString: URLStringConvertible,
        parameters: [ String: AnyObject ]?,
        authorized: Bool,
        completionHandler: CompletionHandler!
        ) -> Request? {
            let url = "\(APIClient.apiEndPoint)/\(URLString)"
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            
            let cachedTask: CachedTask = { [weak self] URLResponse, response in
                if let _ = self {
                    let result = response!.result
                    
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    
                    switch result {
                    case .Failure(_):
                        completionHandler(response: response!)
                        break
                    case .Success(_):
                        print("Repeat:")
                        APIClient.sharedClient.klinkRequest(
                            method,
                            URLString: URLString,
                            parameters: parameters,
                            authorized: authorized,
                            completionHandler: completionHandler)
                        break
                    }
                }
            }
            
            if self.isRefreshing {
                self.cachedTasks.append(cachedTask)
                return nil
            }
            print("URL: \(url)")
            var headers = [
                "Content-type": "application/json"
            ]
            
            if authorized {
                if let accessToken = SessionManager.getAccessToken() {
                    headers.updateValue("Bearer \(accessToken)", forKey: "Authorization")
                }
            }
            
            
            let request = Alamofire.request(method, url, parameters: parameters, encoding: .JSON, headers: headers).validate().responseKlink { (response) -> Void in
                let result = response.result
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
                switch response.result {
                case .Success:
                    print("response: \(response)")
                    completionHandler(response: response)
                    break
                    
                case .Failure(let error):
                    print("Failed KLINK: \(error.localizedDescription)")
                    
                    if response.response?.statusCode == 403 {
                        let strongSelf = self
                        strongSelf.cachedTasks.append(cachedTask)
                        
                        if !self.isRefreshing {
                            strongSelf.renewToken()
                            print("RENEWING TOKEN FROM klinkRequest2")
                        }
                        
                        return
                    }
                    completionHandler(response: response)
                    
                    break
                }
            }
            
            return request
    }
    
    func renewToken() {
        
        guard let refreshToken = SessionManager.getRefreshToken() else {
            SessionManager.logout({ (finished) -> Void in
            })
            
            return
        }
        
        self.isRefreshing = true

        let parameters:[String: AnyObject]? = [
            "client_id" : Constants.getAPIClientId(),
            "client_secret" : Constants.getAPIClientSecret(),
            "grant_type" : "refresh_token",
            "refresh_token" : refreshToken
        ]
        
        APIClient.sharedClient.klinkRequest(.POST, URLString: "authentication/", parameters: parameters) { (response) -> Void in
            let result = response.result
            switch result {
            case .Success(let data):
                
                self.isRefreshing = false
                let json = JSON(data)
                let accessToken = json["access_token"].string
                let refreshToken = json["refresh_token"].string
                
                SessionManager.setTokens(accessToken, refreshToken: refreshToken)
                let cachedTaskCopy = self.cachedTasks
                
                debugPrint("Cashed tasks: \(cachedTaskCopy.count)")
                
                self.cachedTasks.removeAll()
                _ = cachedTaskCopy.map { $0(nil, response) }
                
                debugPrint("Token Refreshed!")
                
                break
            case .Failure(let error):
                debugPrint("Error: \(error)")
                debugPrint("Refresh token failed!")
                
                let cachedTaskCopy = self.cachedTasks
                
                SessionManager.logout({ (finished) -> Void in
                    
                })
                
                debugPrint("Cashed tasks: \(cachedTaskCopy.count)")
                
                
                break
            }
        }
    }
}