//
//  InputValidator.swift
//  Klink
//
//  Created by Mobile App Dev on 09/09/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit

class InputValidator: NSObject {
    
    class func isValidEmail(email:String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(email)
    }
    
    class func isEmpty (text:String) -> Bool {
        
        if text == "" {
            return true
        }
        
        
        return false
    }
    
    
    class func trimWhitespaces(text:String) -> String {
        return text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
    
    class func validName(name: String) -> Bool {
        
        let trimmed = InputValidator.trimWhitespaces(name)
        
        let words = trimmed.componentsSeparatedByString(" ")
        
        print("Words: \(words.count)")
        
        if words.count > 1 {
            return true
        }
        
        return false
    }
    
    
    class func validPassword(pass1: String!, pass2: String!) -> (valid: Bool, message: String) {
        
        if pass1 == pass2 && pass1.characters.count > 5 {
            return (true, "")
        }
    
        var mess = ""
        if pass1 != pass2 {
            mess = "Passwords do not match."
        } else {
            mess = "Password should contain at least 6 characters."
        }
    
        return (false, mess)
    }
    
}
