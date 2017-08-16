//
//  CardInfoViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 24/09/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit
import SwiftyJSON
import MagicalRecord

class CardInfoViewController: UIViewController {
    
    @IBOutlet var scrollViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var cardNumberTextField: KlinkTextField!
    @IBOutlet var cardDateExpiryTextField: KlinkTextField!
    @IBOutlet var cardCCVTextField: KlinkTextField!
    @IBOutlet var defaultSwitch: UISwitch!
    @IBOutlet var switchHolder: UIView!
    @IBOutlet var defaultCardInfo: UIButton!
    
    var card:CreditCard!
    
    init(card: CreditCard) {
        super.init(nibName: "CardInfoViewController", bundle: nil)
        self.card = card
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.setKlinkTitleView("CARD INFO")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tapGesture)
        
        registerForKeyboardNotification()
        
        cardNumberTextField.text = "Last 4 digits: \(card.last4digits)"
        cardDateExpiryTextField.text = "Expiry date: \(card.expiryMonth)/\(card.expiryYear)"
        
        if card.isDefault.boolValue {
            defaultCardInfo.hidden = false
            switchHolder.hidden = true
        } else {
            defaultCardInfo.hidden = true
            switchHolder.hidden = false
        }
        
        defaultSwitch.onTintColor = UIColor.kvfKlinkOrangeColor()
        defaultSwitch.setOn(false, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        unRegisterForKeyboardNotification()
    }

    // MARK: - Helper Methods
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func deleteCard() {
        KlinkAlert.sharedInstance.showLoadingWindow()
        print("delete card id: \(self.card.id!)")
        User.deleteCard(card) { (success, message) -> Void in
            if success {
                KlinkAlert.sharedInstance.hide(.Long, message: message, color: .Success)
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                KlinkAlert.sharedInstance.hide(.Long, message: message, color: .Fail)
            }
        }
    }
    
    func registerForKeyboardNotification() {
        //        println("Register keyboard notifications")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillChange:"), name:UIKeyboardWillChangeFrameNotification, object: nil);
    }
    
    func unRegisterForKeyboardNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    func keyboardWillChange(notification:NSNotification) {
        let userInfo = notification.userInfo!
        let animationDuration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let keyboardScreenBeginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        let keyboardViewBeginFrame = view.convertRect(keyboardScreenBeginFrame, fromView: view.window)
        let keyboardViewEndFrame = view.convertRect(keyboardScreenEndFrame, fromView: view.window)
        let originDelta = keyboardViewEndFrame.origin.y - keyboardViewBeginFrame.origin.y
        
        scrollViewBottomConstraint.constant -= originDelta
        UIView.animateWithDuration(animationDuration) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func deleteCardPressed(sender: AnyObject) {
        let alertVC = UIAlertController(title: "", message: "Delete this payment method?", preferredStyle: .Alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .Destructive) { (action) -> Void in
            self.deleteCard()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
            alertVC.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertVC.addAction(deleteAction)
        alertVC.addAction(cancelAction)
        
        self.presentViewController(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func switchChanged(sender: AnyObject) {
        defaultSwitch.enabled = false
        print("switch changed")
        
        KlinkAlert.sharedInstance.showLoadingWindow()
        
        APIClient.sharedClient.klinkRequest(.POST, URLString: "user/credit-cards/default/", parameters: ["cardId": card.id!], authorized: true) { (response) -> Void in
            self.switchHolder.hidden = true
            self.defaultCardInfo.hidden = false
            let result = response.result
            switch result {
            case .Success(_):
                
                print("Success default")
                
                let oldDefault = CreditCard.MR_findFirstByAttribute("isDefault", withValue: NSNumber(bool:true))
                oldDefault!.isDefault = NSNumber(bool:false)
                
                self.card.isDefault = NSNumber(bool: true)
                KlinkAlert.sharedInstance.hide(.Long, message: "This card has been set as your default.", color: .Success)
                self.navigationController?.popViewControllerAnimated(true)

                break
            case .Failure(let error):
                if response.response?.statusCode == 204 {
                    print("success")
                    let oldDefault = CreditCard.MR_findFirstByAttribute("isDefault", withValue: NSNumber(bool:true))
                    oldDefault!.isDefault = NSNumber(bool:false)
                    self.card.isDefault = NSNumber(bool: true)
                    KlinkAlert.sharedInstance.hide(.Long, message: "This card has been set as your default.", color: .Success)
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    if let rawError = error.localizedDescription.dataUsingEncoding(NSUTF8StringEncoding) {
                        let errorLocalized = JSON(data: rawError)
                        KlinkAlert.sharedInstance.hide(.Long, message: errorLocalized["message"].stringValue, color: .Fail)
                    }
                    print("error setting default card:\(error.localizedDescription)")
                }
                break
            }
            
        }
    }
    

}
