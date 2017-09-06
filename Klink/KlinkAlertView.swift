//
//  KlinkAlertView.swift
//  Klink
//
//  Created by Mobile App Dev on 02/09/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit

class KlinkAlertView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var messageLabel: KLLabel!
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        let nibView = NSBundle.mainBundle().loadNibNamed("KlinkAlertView", owner: self, options: nil)[0] as! UIView
        nibView.frame = self.bounds;
        self.addSubview(nibView)
    }
    
    func setMessage(message: String) {
        let alertMessageStyle = NSMutableParagraphStyle()
        alertMessageStyle.lineSpacing = 4
        alertMessageStyle.alignment = NSTextAlignment.Center
        
        let attrString = NSMutableAttributedString(string: message)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:alertMessageStyle, range:NSMakeRange(0, attrString.length))
        
        messageLabel.attributedText = attrString
    }



}
