//
//  AccountSectionHeaderView.swift
//  Klink
//
//  Created by Mobile App Dev on 23/09/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit

class AccountSectionHeaderView: UIView {

    @IBOutlet var titleLabel: KLLabel!
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
        let nibView = NSBundle.mainBundle().loadNibNamed("AccountSectionHeaderView", owner: self, options: nil)[0] as! UIView
        nibView.frame = self.bounds;
        self.addSubview(nibView)
    }


}
