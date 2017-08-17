//
//  CartMessageTableViewCell.swift
//  Klink
//
//  Created by Mobile App Dev on 18/11/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit

class CartMessageTableViewCell: KlinkBaseTableViewCell {

    @IBOutlet var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
