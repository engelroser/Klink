//
//  CartCollapsibleItemView.swift
//  Klink
//
//  Created by Mobile App Dev on 24/09/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit
import PureLayout

class CartCollapsibleItemView: UIView {

    @IBOutlet var priceLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
        
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }

    func commonInit() {
        let nibView = NSBundle.mainBundle().loadNibNamed("CartCollapsibleItemView", owner: self, options: nil)[0] as! UIView
        nibView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nibView)
        nibView.autoPinEdgesToSuperviewEdgesWithInsets(UIEdgeInsetsMake(0, 0, 0, 0))
        
        nibView.setNeedsLayout()
        nibView.layoutIfNeeded()

        var frame = self.frame
        frame.size.height = priceLabel.frame.size.height + priceLabel.frame.origin.y + 8
        self.frame = frame
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }



}
