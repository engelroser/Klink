//
//  MenuTableViewCell.swift
//  Klink
//
//  Created by Mobile App Dev on 25/08/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit

class MenuTableViewCell: KlinkBaseTableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        self.backgroundColor = UIColor ( red: 0.1059, green: 0.1137, blue: 0.1137, alpha: 1.0 )
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
//        println("Label: \(titleLabel.text) is \(selected)")
        
//        if selected {
//            self.titleLabel.textColor = UIColor.whiteColor()
//        } else {
//            self.titleLabel.textColor = UIColor ( red: 0.6588, green: 0.6588, blue: 0.6588, alpha: 1.0 )
//        }
    }
    
}
