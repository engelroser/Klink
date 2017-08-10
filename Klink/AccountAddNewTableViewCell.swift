//
//  AccountAddNewTableViewCell.swift
//  Klink
//
//  Created by Mobile App Dev on 23/09/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit

class AccountAddNewTableViewCell: KlinkBaseTableViewCell {

    @IBOutlet var titleLabel: KLLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        accessoryView = UIImageView(image: UIImage(named: "cell-add-icon"), highlightedImage: UIImage(named: "rcell-add-icon"))
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
