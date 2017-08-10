//
//  AccountTitleSubtitleTableViewCell.swift
//  Klink
//
//  Created by Mobile App Dev on 23/09/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit

class AccountTitleSubtitleTableViewCell: KlinkBaseTableViewCell {

    @IBOutlet var titleLabel: KLLabel!
    @IBOutlet var subtitlelabel: KLLabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCreditCardView(card: CreditCard) {
        titleLabel.text = card.brand
        subtitlelabel.text = "**** \(card.last4digits)"
    }
    
    func setupAddressView(address: Address) {
        titleLabel.text = address.city
        subtitlelabel.text = address.addressLine1
    }
    
}
