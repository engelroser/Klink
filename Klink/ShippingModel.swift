//
//  ShippingModel.swift
//  Klink
//
//  Created by Mobile App Dev on 12/11/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit

class ShippingModel: NSObject {
    var phone:String!
    var address1:String!
    var address2:String!
    var state:String!
    var zip:String!
    var city:String!
    var stateCode:String!
    var name:String!
    var instructions:String!
    
    init(phone:String!, address1:String!, address2:String!, state:String!, zip:String!, city:String!, stateCode:String!, name:String!, instructions:String!) {
        super.init()
        self.phone = phone
        self.address1 = address1
        self.address2 = address2
        self.state = state
        self.zip = zip
        self.city = city
        self.stateCode = stateCode
        self.name = name
        self.instructions = instructions
    }

}
