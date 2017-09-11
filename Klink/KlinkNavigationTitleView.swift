//
//  KlinkNavigationTitle.swift
//  Klink
//
//  Created by Mobile App Dev on 26/08/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit

class KlinkNavigationTitleView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
//    init(text: String){
//        
//        let screenSize: CGRect = UIScreen.mainScreen().bounds
//        let screenWidth = screenSize.width
//        let screenHeight = screenSize.height
//        
//        super.init(frame: CGRectMake(0, 0, screenWidth, <#height: CGFloat#>))
//    }
//
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    class func klinkTitleLabel(title: String) -> UILabel {
        
        print("KlinkNavigationTitleView title: \(title)")
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        let titleLabel = KLLabel(frame: CGRectMake(0, 0, screenWidth, 44))
       
        
        let attributedString = NSMutableAttributedString(string: title)
        let range = NSMakeRange(0, title.characters.count)
        attributedString.addAttribute(NSKernAttributeName, value: -0.4, range: range)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "Gotham-Medium", size: 11.0)!, range: range)
        titleLabel.attributedText = attributedString
        titleLabel.textAlignment = NSTextAlignment.Center
        
        return titleLabel
    }
    

}
