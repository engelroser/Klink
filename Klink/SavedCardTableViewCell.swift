//
//  SavedCardTableViewCell.swift
//  Klink
//
//  Created by Mobile App Dev on 05/10/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit

class SavedCardTableViewCell: KlinkBaseTableViewCell {

    @IBOutlet var selectCircleView: UIView!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        layoutMargins = UIEdgeInsetsZero
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            fillCircleView()
        } else {
            emptyCircleView()
        }
        
        // Configure the view for the selected state
    }
    

    
    func setupView(card: CreditCard) {
        nameLabel.text = card.brand
        numberLabel.text = "**** \(card.last4digits)"
    }
    
    func fillCircleView() {
        selectCircleView.backgroundColor = UIColor.kvfKlinkOrangeColor()
        selectCircleView.layer.borderColor = UIColor.kvfKlinkOrangeColor().CGColor
    }
    
    func emptyCircleView() {
        selectCircleView.backgroundColor = UIColor.clearColor()
        selectCircleView.layer.cornerRadius = selectCircleView.frame.size.width / 2
        selectCircleView.layer.masksToBounds = true
        selectCircleView.layer.borderWidth = 1.0
        selectCircleView.layer.borderColor = UIColor(red: 181/255.0, green: 181/255.0, blue: 181/255.0, alpha: 1).CGColor
    }
    
}
