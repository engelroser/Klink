//
//  KLLabel.swift
//  Klink
//
//  Created by Mobile App Dev on 24/08/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit

class KLLabel: UILabel {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.setup()
    }
    override init(frame:CGRect) {
        super.init(frame:frame)
        self.setup()
    }
    override  func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    func setup() {
        self.text = self.text
        self.textColor = self.textColor
        setText()
        self.layer.display()
    }
    
    func setText() {
        
        if let _ = self.text {
            let attributedString = NSMutableAttributedString(string: self.text!)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 0
            paragraphStyle.alignment = self.textAlignment
            
            attributedString.addAttribute(NSKernAttributeName, value: -0.4, range: NSMakeRange(0, attributedString.length))
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range: NSMakeRange(0, attributedString.length))
            self.attributedText = attributedString

        }
        
        //        println("set up text")
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        self.preferredMaxLayoutWidth = CGRectGetWidth(self.bounds)
//        super.layoutSubviews()
//    }
    
    
}
