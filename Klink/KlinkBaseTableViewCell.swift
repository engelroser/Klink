//
//  KlinkBaseTableViewCell.swift
//  Klink
//
//  Created by Mobile App Dev on 25/08/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit

class KlinkBaseTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
}
