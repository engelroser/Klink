//
//  CheckoutFinishedViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 12/11/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit
import MessageUI

protocol CheckoutFinishedViewDelegate: NSObjectProtocol {
    func continueBrowsingPressed()
}

class CheckoutFinishedViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet var onTheWayLabel: UILabel!
    @IBOutlet var headerView: UIView!
    @IBOutlet var helpPhoneButton: UIButton!
    @IBOutlet var helpMailButton: UIButton!
    @IBOutlet weak var parachutesTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var parachuteHeightConstraint: NSLayoutConstraint!
    
    weak var delegate:CheckoutFinishedViewDelegate?
    
    init() {
        super.init(nibName: "CheckoutFinishedViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        headerView.backgroundColor = UIColor.kvfKlinkOrangeColor()
        
        let onTheWayLabelStyle = NSMutableParagraphStyle()
        onTheWayLabelStyle.lineSpacing = 10
        onTheWayLabelStyle.alignment = NSTextAlignment.Center
        
        let onTheWayLabelAttributedText = NSMutableAttributedString(string: "YOUR DRINKS ARE ON THE WAY!")
        onTheWayLabelAttributedText.addAttribute(NSParagraphStyleAttributeName, value:onTheWayLabelStyle, range:NSMakeRange(0, onTheWayLabelAttributedText.length))
        
        self.onTheWayLabel.attributedText = onTheWayLabelAttributedText
        self.onTheWayLabel.sizeToFit()
        
        let attrDict = [
            NSFontAttributeName : UIFont(name: "Gotham-Book", size: 14.0)!,
            NSForegroundColorAttributeName : UIColor.whiteColor()
        ]
        
        let helpPhoneText = NSMutableAttributedString(string: "(877) 236-4041", attributes: attrDict)
        helpPhoneText.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(0, helpPhoneText.length))
        
        helpPhoneButton.setAttributedTitle(helpPhoneText, forState: .Normal)
        
        let helpMailText = NSMutableAttributedString(string: "hello@klinkdelivery.com", attributes: attrDict)
        helpMailText.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(0, helpMailText.length))
        
        helpMailButton.setAttributedTitle(helpMailText, forState: .Normal)
        
        Cart.syncCart()
        
        if DeviceType.IS_IPHONE_4_OR_LESS {
            parachutesTopConstraint.constant = 80
            parachuteHeightConstraint.constant = 93
            self.view.updateConstraintsIfNeeded()
            self.view.layoutIfNeeded()
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func helpPhoneButtonPressed(sender: AnyObject) {
        let phoneArray = Constants.klinkPhone.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet)
        let phone = phoneArray.joinWithSeparator("")
        print("PHONE: \(phone)")
        UIApplication.sharedApplication().openURL(NSURL(string: "telprompt://\(phone)")!)
    }
    
    @IBAction func helpMailButtonPressed(sender: AnyObject) {
        let toRecipents = [Constants.klinkEmail]
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setToRecipients(toRecipents)
        mc.navigationBar.titleTextAttributes = UINavigationBar.appearance().titleTextAttributes
        mc.navigationBar.tintColor = UIColor.whiteColor()
        self.presentViewController(mc, animated: true, completion: { () -> Void in
            UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
        })
    }
    
    @IBAction func continueBrowsingPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        delegate?.continueBrowsingPressed()
    }
    
    func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError?) {
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            print("Mail cancelled")
        case MFMailComposeResultSaved.rawValue:
            print("Mail saved")
        case MFMailComposeResultSent.rawValue:
            print("Mail sent")
        case MFMailComposeResultFailed.rawValue:
            print("Mail sent failure: %@", [error!.localizedDescription])
        default:
            break
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
