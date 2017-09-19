//
//  MenuHeaderView.swift
//  Klink
//
//  Created by Mobile App Dev on 24/09/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit

class MenuHeaderView: UIView {

    @IBOutlet var editAddressButton: UIButton!
    @IBOutlet var showHideHoursButton: UIButton!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
        
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }

    func commonInit() {
        let nibView = NSBundle.mainBundle().loadNibNamed("MenuHeaderView", owner: self, options: nil)[0] as! UIView
        nibView.frame = self.bounds;
//        self.bounds = nibView.frame
        self.addSubview(nibView)
        
        let attrDict = [
            NSFontAttributeName : UIFont(name: "Gotham-Book", size: 12.0)!,
            NSForegroundColorAttributeName : UIColor.whiteColor().colorWithAlphaComponent(0.5)
        ]
        
       let editButtonTitle = NSMutableAttributedString(string: "Edit Address", attributes: attrDict)
        editButtonTitle.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(0, editButtonTitle.length))
        
        editAddressButton.setAttributedTitle(editButtonTitle, forState: .Normal)
        
        setShowStoreHoursString()
    }
    
    func setShowStoreHoursString() {
        let attrDict = [
            NSFontAttributeName : UIFont(name: "Gotham-Book", size: 12.0)!,
            NSForegroundColorAttributeName : UIColor.whiteColor().colorWithAlphaComponent(0.5)
        ]
        let showHoursTitle = NSMutableAttributedString(string: "Show Store Hours", attributes: attrDict)
        showHoursTitle.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(0, showHoursTitle.length))
        
        showHideHoursButton.setAttributedTitle(showHoursTitle, forState: .Normal)
    }
    
    func setHideSoreHoursString() {
        let attrDict = [
            NSFontAttributeName : UIFont(name: "Gotham-Book", size: 12.0)!,
            NSForegroundColorAttributeName : UIColor.whiteColor()
        ]
        let showHoursTitle = NSMutableAttributedString(string: "Hide Store Hours", attributes: attrDict)
        showHoursTitle.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(0, showHoursTitle.length))
        
        showHideHoursButton.setAttributedTitle(showHoursTitle, forState: .Normal)
    }

}
