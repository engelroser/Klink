//
//  BorderedButton.swift
//  Klink
//
//  Created by Mobile App Dev on 24/08/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit

class BorderedButton: UIButton {

    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code

        self.backgroundColor = UIColor.clearColor()
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.whiteColor().CGColor
        
        self.titleLabel!.font =  UIFont(name: "Gotham-Bold", size: 16)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.setBackgroundImage(UIImage.imageWithColor(UIColor.whiteColor().colorWithAlphaComponent(0.2)), forState: UIControlState.Highlighted)

//        for(NSString* family in [UIFont familyNames]) {
//            NSLog(@"%@", family);
//            for(NSString* name in [UIFont fontNamesForFamilyName: family]) {
//                NSLog(@"  %@", name);
//            }
//        }
        
//        for family in UIFont.familyNames() {
//            println("Family: \(family)")
//            for name in UIFont.fontNamesForFamilyName(family as! String) {
//                println("Name: \(name)")
//            }
//        }
//        
        if let titleString = self.titleLabel?.text {
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 0
            self.titleLabel?.attributedText =
                NSAttributedString(
                    string: titleString,
                    attributes:
                    [
                        NSKernAttributeName: -0.4,
                        NSParagraphStyleAttributeName: paragraphStyle
                    ])
            self.titleLabel!.baselineAdjustment = UIBaselineAdjustment.AlignCenters
        }
        
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5)
        self.titleLabel?.textAlignment = .Center
        
        contentVerticalAlignment = .Center
    }
}

