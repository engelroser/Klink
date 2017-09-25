//
//  NSDecimalNumber+extension.swift
//  Klink
//
//  Created by Mobile App Dev on 09/11/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit

extension NSDecimalNumber {
    
    func prettyPriceInDollars() -> String {
//    [NSString stringWithFormat:@"%.2f", [[NSDecimalNumber decimalNumberWithDecimal:myDecimal] doubleValue]]
//        return String(format: "%.2f", arguments: self.doubleValue)
        let b:String = String(format:"%.2f", self.doubleValue/100)
        return b
    }
}
