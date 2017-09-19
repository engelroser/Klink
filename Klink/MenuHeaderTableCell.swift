//
//  MenuHeaderTableCell.swift
//  Klink
//
//  Created by Mobile App Dev on 30/09/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit

protocol MenuHeaderDelegate {
    func didPressEditAddress()
    func didPressShowStoreHours()
}

class MenuHeaderTableCell: KlinkBaseTableViewCell {
    
    @IBOutlet var editAddressButton: UIButton!
    @IBOutlet var storeHoursButton: UIButton!
    
    @IBOutlet var deliveringTitleLabel: KLLabel!
    @IBOutlet var deliveringAddressLabel: KLLabel!
    var delegate:MenuHeaderDelegate?

    @IBOutlet var deliveringToHeightConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        let attrDict = [
//            NSFontAttributeName : UIFont(name: "Gotham-Book", size: 12.0)!,
//            NSForegroundColorAttributeName : UIColor.whiteColor().colorWithAlphaComponent(0.5)
//        ]
//        
//        let editButtonTitle = NSMutableAttributedString(string: "Edit Address", attributes: attrDict)
//        editButtonTitle.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(0, editButtonTitle.length))
//        
//        editAddressButton.setAttributedTitle(editButtonTitle, forState: .Normal)
//        setShowStoreHoursString()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView() {
//        storeHoursButton.hidden = true
        
        if let address = SessionManager.currentDeliveryAddress() {
//            deliveringAddressLabel.hidden = false
//            deliveringToHeightConstraint.constant = 15
            deliveringTitleLabel.text = "DELIVERING TO"
//            storeHoursButton.hidden = false
            editAddressButton.hidden = false
            editAddressButton.setTitle("Edit Address", forState: .Normal)
            deliveringAddressLabel.text = "\(address.street!), \(address.postalCode!), \(address.locality!), \(address.stateName!)"
            let attrDict = [
                NSFontAttributeName : UIFont(name: "Gotham-Book", size: 12.0)!,
                NSForegroundColorAttributeName : UIColor.whiteColor().colorWithAlphaComponent(0.5)
            ]
            
            let editButtonTitle = NSMutableAttributedString(string: "Edit Address", attributes: attrDict)
            editButtonTitle.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(0, editButtonTitle.length))
            
            editAddressButton.setAttributedTitle(editButtonTitle, forState: .Normal)

            
            
        } else {
//            deliveringToHeightConstraint.constant = 0
            deliveringTitleLabel.text = "NO DELIVERY ADDRESS"
            editAddressButton.setTitle("Add Address", forState: .Normal)
//            deliveringTitleLabel.hidden = true
//            storeHoursButton.hidden = true
            deliveringAddressLabel.text = ""
            
            let attrDict = [
                NSFontAttributeName : UIFont(name: "Gotham-Book", size: 12.0)!,
                NSForegroundColorAttributeName : UIColor.whiteColor().colorWithAlphaComponent(0.5)
            ]
            
            let editButtonTitle = NSMutableAttributedString(string: "Add Address", attributes: attrDict)
            editButtonTitle.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(0, editButtonTitle.length))
            
            editAddressButton.setAttributedTitle(editButtonTitle, forState: .Normal)

        }
    }
    
    func setShowStoreHoursString() {
//        let attrDict = [
//            NSFontAttributeName : UIFont(name: "Gotham-Book", size: 12.0)!,
//            NSForegroundColorAttributeName : UIColor.whiteColor().colorWithAlphaComponent(0.5)
//        ]
//        let showHoursTitle = NSMutableAttributedString(string: "Show Store Hours", attributes: attrDict)
//        showHoursTitle.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(0, showHoursTitle.length))
//        
//        storeHoursButton.setAttributedTitle(showHoursTitle, forState: .Normal)
    }
    
    func setHideSoreHoursString() {
//        let attrDict = [
//            NSFontAttributeName : UIFont(name: "Gotham-Book", size: 12.0)!,
//            NSForegroundColorAttributeName : UIColor.whiteColor()
//        ]
//        let showHoursTitle = NSMutableAttributedString(string: "Hide Store Hours", attributes: attrDict)
//        showHoursTitle.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(0, showHoursTitle.length))
//        
//        storeHoursButton.setAttributedTitle(showHoursTitle, forState: .Normal)
    }
    
    // MARK: - button Actions
    
    @IBAction func editAddressPressed(sender: AnyObject) {
        delegate?.didPressEditAddress()
    }

    @IBAction func showStoreHoursPressed(sender: AnyObject) {
        delegate?.didPressShowStoreHours()
    }
}
