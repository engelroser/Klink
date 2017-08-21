//
//  CheckoutDeliveryInfoViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 10/11/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit

class CheckoutDeliveryInfoViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, StatesViewDelegate {
    
    @IBOutlet var messageTextView: UITextView!
    @IBOutlet var messageTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var scrollBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var fullNameTextField: KlinkTextField!
    @IBOutlet var phoneNumberTextField: KlinkTextField!
    @IBOutlet var addressLine1TextField: KlinkTextField!
    @IBOutlet var addressline2TextField: KlinkTextField!
    @IBOutlet var cityTextField: KlinkTextField!
    @IBOutlet var stateTextField: KlinkTextField!
    @IBOutlet var zipCodeTextField: KlinkTextField!
    
    private var address:ShippingModel!
    
    var selectedCode:String = ""
    
    let messageTextViewPlaceholderText = "Enter special instructions here (i.e. gate code, we're around back …)"
    
    init() {
        super.init(nibName: "CheckoutDeliveryInfoViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        fullNameTextField.delegate = self
        phoneNumberTextField.delegate = self
        addressLine1TextField.delegate = self
        addressline2TextField.delegate = self
        cityTextField.delegate = self
        stateTextField.delegate = self
        zipCodeTextField.delegate = self
        
        messageTextView.delegate = self
        
        messageTextView.text = messageTextViewPlaceholderText
        messageTextView.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.4)
        
        let address = SessionManager.currentDeliveryAddress()
        addressLine1TextField.text = address?.street
        addressline2TextField.text = ""
        cityTextField.text = address?.locality
        stateTextField.text = StateAddress.stateForCode(address?.administrativeArea)
        
        selectedCode = (address?.administrativeArea)!
        
        zipCodeTextField.text = address?.postalCode
        
        print("Selected code: \(selectedCode)")
        
        let user = SessionManager.currentUser()
        
        fullNameTextField.text = user?.fullName
        
        if let phone = user?.phoneNumber {
            phoneNumberTextField.text = phone
        }
        
        self.navigationItem.setKlinkTitleView("DELIVERY INFO")
        
        let nextButton = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: "nextPressed")
        navigationItem.rightBarButtonItem = nextButton
        
        let backItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        registerForKeyboardNotification()
    }
    
    override func viewDidDisappear(animated: Bool) {
        unRegisterForKeyboardNotification()
    }
    
    // MARK: - Helper Methods
    
    func nextPressed() -> Bool{
        
        KlinkAlert.sharedInstance.showLoadingWindow()
        KlinkAlert.sharedInstance.hide(.Long, message: "Phone field can't be empty.", color: .Fail)
        
        if InputValidator.isEmpty(fullNameTextField.text!) {
            KlinkAlert.sharedInstance.hide(.Long, message: "Full name field can't be empty.", color: .Fail)
            return false
        } else {
            let fullNameArray = fullNameTextField.text!.characters.split{$0 == " "}.map(String.init)
            
            if fullNameArray.count < 2 {
                KlinkAlert.sharedInstance.hide(.Long, message: "You have to enter a first and last name.", color: KlinkAlert.AlertColor.Fail)
                return false
            }
        }
        
        if InputValidator.isEmpty(phoneNumberTextField.text!) {
            KlinkAlert.sharedInstance.hide(.Long, message: "Phone field can't be empty.", color: .Fail)
            return false
        }
        
        if InputValidator.isEmpty(addressLine1TextField.text!) {
            KlinkAlert.sharedInstance.hide(.Long, message: "Address Line 1 field can't be empty.", color: .Fail)
            return false
        }
        
        if InputValidator.isEmpty(cityTextField.text!) {
            KlinkAlert.sharedInstance.hide(.Long, message: "City field can't be empty.", color: .Fail)
            return false
        }
        
        if InputValidator.isEmpty(stateTextField.text!) {
            KlinkAlert.sharedInstance.hide(.Long, message: "State field can't be empty.", color: .Fail)
            return false
        }
        
        if InputValidator.isEmpty(zipCodeTextField.text!) {
            KlinkAlert.sharedInstance.hide(.Long, message: "Zip field can't be empty.", color: .Fail)
            return false
        }
        
        var instructions = messageTextView.text
        if instructions == messageTextViewPlaceholderText {
            instructions = ""
        }
        
        let shippingAddress:[String:AnyObject] = [
            "full_name" : fullNameTextField.text!,
            "country_code": "US",
            "locality": cityTextField.text!,
            "postal_code": zipCodeTextField.text!,
            "administrative_area": "US-\(selectedCode)",
            "address_line1": addressLine1TextField.text!,
            "address_line2": addressline2TextField.text!
        ]
        
        let parameters:[String:AnyObject] = [
            "shippingAddress" : shippingAddress,
            "additional_information" : instructions,
            "phone_number" : phoneNumberTextField.text!
        ]
        
        address = ShippingModel(phone: phoneNumberTextField.text, address1: addressLine1TextField.text, address2: addressline2TextField.text, state: stateTextField.text, zip: zipCodeTextField.text, city: cityTextField.text, stateCode: selectedCode, name: fullNameTextField.text, instructions: instructions)
        
        KlinkAlert.sharedInstance.hide(0, message: "", color: .Neutral)
        
        self.navigationController?.pushViewController(CheckoutPaymentViewController(address: address), animated: true)
        
        //        Here we have disclaimer check
        //        if self.shouldShowDisclaimer() {
        //            self.showDisclaimer()
        //        } else {
        //            self.goToNextScreen()
        //        }
        
        //        print("Parameters: \(parameters)")
        //
        //        APIClient.sharedClient.klinkRequest2(.PUT, URLString: "cart/checkout/", parameters: parameters, authorized: true) { (response) -> Void in
        //            let result = response.result
        //            switch result {
        //            case .Success(_):
        //                print("success, go to next step")
        //                break
        //
        //            case .Failure(let error):
        //                print("failed: \(error.localizedDescription)")
        //                break
        //            }
        //
        //            KlinkAlert.sharedInstance.hide(0, message: "", color: .Neutral)
        //        }
        
        return true
        
    }
    
    private func shouldShowDisclaimer () -> Bool {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let disclaimerHidden: Int = userDefaults.integerForKey("DisclaimerHidden")
        if disclaimerHidden == 1 {
            return false
        } else {
            return true
        }
    }
    
    private func showDisclaimer() {
        let vc = CartDisclaimerViewController()
        vc.delegate = self
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    private func goToNextScreen() {
        self.navigationController?.pushViewController(CheckoutPaymentViewController(address: address), animated: true)
    }
    
    // MARK: Keyboard Notification
    
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
        
        scrollBottomConstraint.constant -= originDelta
        
        UIView.animateWithDuration(animationDuration) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == stateTextField {
            view.endEditing(true)
            let vc = StatesViewController()
            vc.delegate = self
            self.presentViewController(vc, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        //Fixes iOS 9 text bounce glitch
        textField.layoutIfNeeded()
    }
    
    // MARK: - StatesViewDelegate
    
    func didSelectState(name: String?, code: String?) {
        print("selected \(name), \(code)")
        if let c = code {
            stateTextField.text = name
            selectedCode = c
        }
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidBeginEditing(textView: UITextView) {
        if messageTextView.textColor == UIColor.whiteColor().colorWithAlphaComponent(0.4) {
            textView.text = ""
            textView.textColor = UIColor.whiteColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.characters.count == 0{
            textView.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.4)
            textView.text = messageTextViewPlaceholderText
        } else {
            textView.textColor = UIColor.whiteColor()
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        var height = messageTextView.sizeThatFits(CGSizeMake(messageTextView.frame.size.width, CGFloat.max)).height
        
        if height < 72 {
            height = 72
        }
        messageTextViewHeightConstraint.constant = height
    }
    
}

extension CheckoutDeliveryInfoViewController: CartDisclaimerViewControllerDelegate {
    func didPressedNext() {
        self.goToNextScreen()
    }
}
