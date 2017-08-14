//
//  AddressSearchTableViewCell.swift
//  Klink
//
//  Created by Mobile App Dev on 31/08/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit

class AddressSearchTableViewCell: KlinkBaseTableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var bottomBorder: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
