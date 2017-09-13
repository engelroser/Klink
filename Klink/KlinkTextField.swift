//
//  KlinkTextField.swift
//  Klink
//
//  Created by Mobile App Dev on 03/09/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit

class KlinkTextField: UITextField {

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
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
//        println("Custom textfield init")
        
        self.backgroundColor = UIColor.clearColor()
        self.borderStyle = UITextBorderStyle.None
        self.tintColor = UIColor.whiteColor()
        
        if let placeholder = self.placeholder {
            let attString = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor().colorWithAlphaComponent(0.4)])
            self.attributedPlaceholder = attString
        }
        
        
        self.font = UIFont(name: "Gotham-Book", size: 16.0)
        self.textColor = UIColor.whiteColor()
    }




}
