//
//  KlinkNavigationBar.swift
//  Klink
//
//  Created by Mobile App Dev on 18/09/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit

class KlinkNavigationBar: UINavigationBar {
    
    var viewsToIgnoreTouchesFor:[UIScrollView] = []
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        var pointInSide = super.pointInside(point, withEvent: event)
        
        for view in viewsToIgnoreTouchesFor {
            let convertedPoint = view.convertPoint(point, toView: self)
            
            if CGRectContainsPoint(CGRectMake(view.frame.origin.x + 40, view.frame.origin.y, view.frame.size.width - 80, view.frame.size.height), point) {
                pointInSide = false
            }
            
//            if view.pointInside(convertedPoint, withEvent: event) {
//                pointInSide = false
//            }
        }
        
//        println("Point inside: \(pointInSide)")
        return pointInSide
    }
}
