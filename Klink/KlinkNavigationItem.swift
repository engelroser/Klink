//
//  KlinkNavigationItem.swift
//  Klink
//
//  Created by Mobile App Dev on 26/08/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit

extension UINavigationItem {

    func setKlinkTitleView(title: String) {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        
//        let width = titleView?.frame.size.width
//        let height = titleView?.frame.size.height
        let titleLabel = KLLabel()
        titleLabel.text = "Test label text" // sample label text
        let labelTextWidth = titleLabel.intrinsicContentSize().width
        let labelTextHeight = titleLabel.intrinsicContentSize().height
        
        titleLabel.frame = CGRectMake(0, 0, labelTextWidth, 44)
        
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        titleLabel.textAlignment = NSTextAlignment.Center
        
        let attributedString = NSMutableAttributedString(string: title)
        let range = NSMakeRange(0, title.characters.count)
        attributedString.addAttribute(NSKernAttributeName, value: -0.4, range: range)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "Gotham-Medium", size: 16.0)!, range: range)
        titleLabel.attributedText = attributedString
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.textColor = UIColor.whiteColor()
        
        titleView?.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleRightMargin]
        titleView?.autoresizesSubviews = true
        
        titleLabel.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleRightMargin]
        
        titleView = titleLabel
    }
}


//// Set the width of the views according to the text size
//CGFloat desiredWidth = [self.title sizeWithFont:titleLabel.font
//    constrainedToSize:CGSizeMake([[UIScreen mainScreen] applicationFrame].size.width, titleLabel.frame.size.height)
//    lineBreakMode:UILineBreakModeCharacterWrap].width;
//
//CGRect frame;
//
//frame = titleLabel.frame;
//frame.size.height = titleHeight;
//frame.size.width = desiredWidth;
//titleLabel.frame = frame;
//
//frame = titleView.frame;
//frame.size.height = titleHeight;
//frame.size.width = desiredWidth;
//titleView.frame = frame;
//
//// Ensure text is on one line, centered and truncates if the bounds are restricted
//titleLabel.numberOfLines = 1;
//titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
//titleLabel.textAlignment = UITextAlignmentCenter;
//
//// Use autoresizing to restrict the bounds to the area that the titleview allows
//titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
//titleView.autoresizesSubviews = YES;
//titleLabel.autoresizingMask = titleView.autoresizingMask;
//
//// Set the text
//titleLabel.text = self.title;
//
//// Add as the nav bar's titleview
//[titleView addSubview:titleLabel];
//self.navigationItem.titleView = titleView;