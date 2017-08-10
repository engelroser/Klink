//
//  AccountUserInfoTableViewCell.swift
//  Klink
//
//  Created by Mobile App Dev on 23/09/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit

class AccountUserInfoTableViewCell: KlinkBaseTableViewCell {

    @IBOutlet var fullNameLabel: KLLabel!
    @IBOutlet var birthdayLabel: KLLabel!
    @IBOutlet var emailLabel: KLLabel!
    @IBOutlet var phoneNumberLabel: KLLabel!
    @IBOutlet var phoneNumberBottomConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        layoutMargins = UIEdgeInsetsZero
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView(user: User) {
        fullNameLabel.text = user.fullName
        emailLabel.text = user.email
        
        if let b = user.birthday {
            let df = NSDateFormatter()
            df.dateStyle = .MediumStyle
            birthdayLabel.text = df.stringFromDate(b)
        }
        
        if let phone = user.phoneNumber {
            phoneNumberLabel.hidden = false
            phoneNumberLabel.text = phone
            phoneNumberBottomConstraint.constant = 10
        } else {
            phoneNumberLabel.hidden = true
            phoneNumberLabel.text = ""
            phoneNumberBottomConstraint.constant = 6
        }
        
        self.layoutIfNeeded()
        
    }
    
}
