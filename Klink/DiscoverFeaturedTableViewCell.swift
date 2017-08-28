//
//  DiscoverFeaturedTableViewCell.swift
//  Klink
//
//  Created by Mobile App Dev on 11/09/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit

class DiscoverFeaturedTableViewCell: KlinkBaseTableViewCell {

    @IBOutlet var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet var backgroundImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backgroundImageView.clipsToBounds = true
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        //imageHeightConstraint.constant = screenWidth / 2.15
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func didMoveToSuperview() {
        self.layoutIfNeeded()
    }
    
}
