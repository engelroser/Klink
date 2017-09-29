//
//  PackContentheaderTableViewCell.swift
//  Klink
//
//  Created by Mobile App Dev on 27/10/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit

protocol PackContentHeaderDelegate {
    func didPressClose()
}

class PackContentheaderTableViewCell: KlinkBaseTableViewCell {
    
    var delegate:PackContentHeaderDelegate?
    @IBOutlet var packTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let screenWidth = UIScreen.mainScreen().bounds.width - 40
        let maskPath = UIBezierPath(roundedRect: CGRectMake(self.frame.origin.x, self.frame.origin.y, screenWidth, self.frame.size.height), byRoundingCorners: [UIRectCorner.TopRight, .TopLeft], cornerRadii: CGSizeMake(5, 5))
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, screenWidth, self.frame.size.height)
        maskLayer.path = maskPath.CGPath
        layer.mask = maskLayer
        layer.masksToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView(pack:PackModel!) {
        packTitleLabel.text = pack.name.uppercaseString
    }
    
    @IBAction func closePressed(sender: AnyObject) {
        delegate?.didPressClose()
    }
    
}
