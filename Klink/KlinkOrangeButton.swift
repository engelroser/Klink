//
//  KlinkOrangeButton.swift
//  Klink
//
//  Created by Mobile App Dev on 21/10/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit

class KlinkOrangeButton: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commontInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commontInit()
    }
    
    
    func commontInit() {
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
        
        self.titleLabel!.font =  UIFont(name: "Gotham-Book", size: 14)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        
        contentEdgeInsets = UIEdgeInsetsMake(10, 15, 10, 15)
        sizeToFit()
        
        self.setBackgroundImage(UIImage.imageWithColor(UIColor.kvfKlinkOrangeColor()), forState: UIControlState.Normal)
        self.setBackgroundImage(UIImage.imageWithColor(UIColor.kvfKlinkOrangeColor().colorWithAlphaComponent(0.8)), forState: UIControlState.Highlighted)
    }

}
