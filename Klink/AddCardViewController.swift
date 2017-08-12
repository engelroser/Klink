//
//  AddCardViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 23/09/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit
//import CardIO
import Stripe

class AddCardViewController: UIViewController, CardIOPaymentViewControllerDelegate, UITextFieldDelegate, MonthYearPickerDelegate {
    
    @IBOutlet var defaultCardSwitch: UISwitch!
    
    @IBOutlet var cardNumberTextField: KlinkTextField!
    @IBOutlet var expirationDateTextField: KlinkTextField!
    @IBOutlet var ccvTextField: KlinkTextField!
    @IBOutlet var zipCodeTextField: KlinkTextField!
    @IBOutlet var cardNameTextField: KlinkTextField!
    
    @IBOutlet var scrollViewBottomConstraint: NSLayoutConstraint!
    init() {
        super.init(nibName: "AddCardViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.setKlinkTitleView("ADD CARD")
        
        let saveButton = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: "saveTapped")
        
        registerForKeyboardNotification()
        navigationItem.rightBarButtonItem = saveButton
        
        defaultCardSwitch.onTintColor = UIColor.kvfKlinkOrangeColor()
        
        expirationDateTextField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        CardIOUtilities.preload()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        unRegisterForKeyboardNotification()
    }
    // MARK: - UIBarButton Actions
    
    func saveTapped() {
        KlinkAlert.sharedInstance.showLoadingWindow()
        
        let card = STPCardParams()
        card.number = cardNumberTextField.text
        
        let expirationDate = expirationDateTextField.text!.componentsSeparatedByString("/")
        
        if expirationDate.count == 2 {
            card.expMonth = UInt(Int(expirationDate[0])!)
            card.expYear = UInt(Int(expirationDate[1])!)
        }

        card.name = cardNameTextField.text
        
        if card.name == "" {
            card.name = SessionManager.currentUser()?.fullName
        }
        
        card.cvc = ccvTextField.text

        
        STPAPIClient.sharedClient().createTokenWithCard(card) { (token, error) -> Void in
            if error == nil {
                User.addCreditCard(token!, completion: { (success, card, message) -> Void in
                    if success {
                        KlinkAlert.sharedInstance.hide(.Long, message: message, color: .Success)
                        self.navigationController?.popViewControllerAnimated(true)
                    } else {
                        KlinkAlert.sharedInstance.hide(.Long, message: message, color: .Fail)
                    }
                })
            } else {
                KlinkAlert.sharedInstance.hide(.Long, message: error?.localizedDescription, color: .Fail)
            }
            
            
        }
        

    }
    
    // MARK: - Keyboard Notification

    func registerForKeyboardNotification() {
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
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == expirationDateTextField {
            view.endEditing(true)
            let vc = MonthYearPickerViewController()
            vc.delegate = self
            presentViewController(vc, animated: true, completion:nil)
            return false
        }
        
        return true
    }

    // MARK: - MonthYearPickerDelegate
    
    func monthYearPicker(controller: MonthYearPickerViewController, didSelectDate date: String?) {
        expirationDateTextField.text = date
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Button Actions

    @IBAction func scanCardPressed(sender: AnyObject) {
        Permissions.cameraPermissions(self) { (approved) -> Void in
            if approved {
                let scanVC = CardIOPaymentViewController(paymentDelegate: self)
                self.presentViewController(scanVC, animated: true, completion: nil)
            } else {
                Permissions.alertPermissionNotAllowed(self, message: "Please enable camera in settings.")
            }
        }
    }
    
    // MARK: - CardIOPaymentViewControllerDelegate
    
    func userDidProvideCreditCardInfo(cardInfo: CardIOCreditCardInfo!, inPaymentViewController paymentViewController: CardIOPaymentViewController!) {
        
        paymentViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func userDidCancelPaymentViewController(paymentViewController: CardIOPaymentViewController!) {
        paymentViewController.dismissViewControllerAnimated(true, completion: nil)
    }


}
