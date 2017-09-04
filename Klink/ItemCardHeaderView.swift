//
//  ItemCardHeaderView.swift
//  Klink
//
//  Created by Mobile App Dev on 14/09/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit

@objc protocol ItemCardHeaderViewDelegate {
    optional func itemCardHeaderClosePressed()
}

class ItemCardHeaderView: UIView {

    @IBOutlet var bottomBorder: UIView!
    @IBOutlet var plusButton: UIButton!
    
    var delegate:ItemCardHeaderViewDelegate?
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: ([UIRectCorner.TopLeft, UIRectCorner.TopRight]), cornerRadii: CGSizeMake(8, 8))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.CGPath
        self.layer.mask = maskLayer
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        let nibView = NSBundle.mainBundle().loadNibNamed("ItemCardHeaderView", owner: self, options: nil)[0] as! UIView
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.width, nibView.bounds.size.height)
        nibView.frame = self.bounds;
        
        self.addSubview(nibView)
        
//        self.addConstraint(NSLayoutConstraint(item: nibView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0))
//        
//        self.addConstraint(NSLayoutConstraint(item: nibView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0))
//        
//        self.addConstraint(NSLayoutConstraint(item: nibView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 0))
//        
//        self.addConstraint(NSLayoutConstraint(item: nibView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 0))
        
        setUpButtons()
    }

    func setUpButtons() {
        plusButton.layer.cornerRadius = plusButton.frame.size.width/2
        plusButton.layer.borderWidth = 1.0
        plusButton.layer.borderColor = UIColor.grayColor().CGColor
    }
    
    @IBAction func closePressed(sender: AnyObject) {
        delegate?.itemCardHeaderClosePressed!()
    }
    
    func stretchToSuperView(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
    }
}
