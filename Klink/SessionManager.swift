//
//  SessionManager.swift
//  Klink
//
//  Created by Mobile App Dev on 13/10/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit
import KeychainSwift

private struct Keys {
    static let ACCESS_TOKEN = "ACCESS_TOKEN"
    static let REFRESH_TOKEN = "REFRESH_TOKEN"
    static let DELIVERING_ADDRESS = "DELIVERING_ADDRESS"
    static let STORE_ID = "STORE_ID"
    static let FIRST_RUNNED = "FIRST_RUNNED"
}

class SessionManager: NSObject {
    
    static let DELIVERY_ADDRESS_CHANGED = "DELIVERY_ADDRESS_CHANGED"
    static let USER_LOGGED_OUT = "USER_LOGGED_OUT"
    
    class func firstTimeRun() -> Bool? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.objectForKey(Keys.FIRST_RUNNED) as? Bool
    }
    
    class func setFirstTimeRun() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(true, forKey: Keys.FIRST_RUNNED)
        defaults.synchronize()
    }
    
    class func setTokens(accessToken: String!, refreshToken: String!) {
        let keychain = KeychainSwift()
        keychain.set(accessToken, forKey: Keys.ACCESS_TOKEN)
        keychain.set(refreshToken, forKey: Keys.REFRESH_TOKEN)
        
        debugPrint("Tokens saved!")
    }
    
    class func getAccessToken() -> String? {
        let keychain = KeychainSwift()
        return keychain.get(Keys.ACCESS_TOKEN)
    }

    class func getRefreshToken() -> String? {
        let keychain = KeychainSwift()
        return keychain.get(Keys.REFRESH_TOKEN)
    }
    
    class func userLoggedIn() -> Bool {
        
        if let _ = getAccessToken() {
            return true
        }
        return false
    }
    
    class func setCurrentStore(id: Int) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(id, forKey: Keys.STORE_ID)
        defaults.synchronize()
        NSNotificationCenter.defaultCenter().postNotificationName(DELIVERY_ADDRESS_CHANGED, object: nil)
    }
    
    class func getCurrentStoreID() -> Int? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.objectForKey(Keys.STORE_ID) as? Int
    }
    
    
    class func logout(completion:(finished: Bool) -> Void) {
        KeychainSwift().clear()
        User.MR_truncateAll()
        Cart.MR_truncateAll()
        Cart.createLocalCart()
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreWithCompletion { (saved, error) -> Void in
            completion(finished: true)
            NSNotificationCenter.defaultCenter().postNotificationName(USER_LOGGED_OUT, object: nil)
        }
    }
    
    class func currentUser() -> User? {
        if let user = User.MR_findFirst() {
            return user
        }
        SessionManager.logout { (finished) -> Void in
            
        }
        return nil
    }
    
    class func currentDeliveryAddress() -> RecentAddress? {
        return RecentAddress.currentDeliveryAddress()
    }
    
}
