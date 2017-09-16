//
//  MapGradientView.swift
//  Klink
//
//  Created by Mobile App Dev on 26/08/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit

@IBDesignable
class MapGradientView: UIView {

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.colors = [UIColor ( red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0 ).CGColor, UIColor ( red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6 ).CGColor]
        gradient.locations = [0.0 , 1.0]
        
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        
        self.layer.insertSublayer(gradient, atIndex: 0)
        
    }
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        return false
    }


}
