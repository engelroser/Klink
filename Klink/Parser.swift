//
//  Parser.swift
//  Klink
//
//  Created by Mobile App Developer on 13/10/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit
import SwiftyJSON

class Parser: NSObject {
    
    
    class func failureResponseToJSON(data: NSData?) -> JSON? {
        let s = NSString(data: data!, encoding: NSUTF8StringEncoding)
        if let dataFromString = s!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            let json = JSON(data: dataFromString)
            return json
        }
        return nil
    }

}
