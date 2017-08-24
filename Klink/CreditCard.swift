//
//  CreditCard.swift
//  Klink
//
//  Created by Mobile App Dev on 22/10/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

class CreditCard: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    

    class func addCardToCurrentUser(json:JSON, completion:(success: Bool, card:CreditCard?) -> Void) {
        let card = CreditCard.MR_createEntity()
        card!.id = json["id"].int
        card!.last4digits = json["last4digits"].string!
        card!.brand = json["brand"].string
        card!.isDefault = json["default"].bool
        card!.expiryMonth = json["expiry_month"].string
        card!.expiryYear = json["expiry_year"].string
        card!.cardholderName = json["cardholder_name"].string
        card!.isDefault = json["default"].bool
        let user = SessionManager.currentUser()
        card!.user = user
        var cards = user!.creditCards?.allObjects as! [CreditCard]
        cards.append(card!)
        
        user!.creditCards = NSSet(array: cards)
        
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreWithCompletion { (saved, error) -> Void in
            if saved {
                debugPrint("SAVED card!")
                completion(success: true, card: card)
            } else {
                completion(success: true, card: nil)
            }
        }
    }

    
    class func initCardsFromJSON(user: User!, json: JSON) {
//        "credit_cards": [
//        {
//        "id": 18,
//        "cardholder_name": "Ivan Bozic",
//        "last4digits": 4242,
//        "expiry_month": "1",
//        "expiry_year": "2016",
//        "token": "card_16yijuI30uEeZGtETGlKcvoM",
//        "brand": "Visa",
//        "default": true
//        }
        var cards:[CreditCard] = []
        for (_,subJson):(String, JSON) in json {
            //Do something you want
//            print("key: \(key), value: \(subJson)")
            
            let card = CreditCard.MR_createEntity()
            card!.id = subJson["id"].int
            card!.last4digits = subJson["last4digits"].string!
            card!.brand = subJson["brand"].string
            card!.isDefault = subJson["default"].bool
            card!.expiryMonth = subJson["expiry_month"].string
            card!.expiryYear = subJson["expiry_year"].string
            card!.cardholderName = subJson["cardholder_name"].string
            card!.isDefault = subJson["default"].bool
            print("User id: \(user.id)")
            cards.append(card!)
        }
        user.creditCards = NSSet(array: cards)
//        completion(success: true)
        
    }
}
