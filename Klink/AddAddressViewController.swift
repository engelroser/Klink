//
//  AddAddressViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 28/10/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit

class AddAddressViewController: UIViewController, UITextFieldDelegate, StatesViewDelegate {
    
    
    @IBOutlet var addressline1TextField: KlinkTextField!
    @IBOutlet var addressline2TextField: KlinkTextField!
    @IBOutlet var cityTextField: KlinkTextField!
    @IBOutlet var stateTextField: KlinkTextField!
    @IBOutlet var zipCodeTextField: KlinkTextField!
    @IBOutlet var addressSwitch: UISwitch!
    @IBOutlet var scrollViewBottomConstraint: NSLayoutConstraint!
    
    var selectedStateCode = ""
    
    init() {
        super.init(nibName: "AddAddressViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        stateTextField.delegate = self
        addressline1TextField.delegate = self
        addressline2TextField.delegate = self
        cityTextField.delegate = self
        zipCodeTextField.delegate = self
        
        navigationItem.setKlinkTitleView("ADD ADDRESS")
        
        let saveItem = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: "save")
        navigationItem.rightBarButtonItem = saveItem
        
        addressSwitch.onTintColor = UIColor.kvfKlinkOrangeColor()
        
        let tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(animated: Bool) {
        registerForKeyboardNotification()
    }
    
    override func viewWillDisappear(animated: Bool) {
        unRegisterForKeyboardNotification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper Methods
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func save() {
        KlinkAlert.sharedInstance.showLoadingWindow()
        
        User.addNewAddress(cityTextField.text!, postalCode: zipCodeTextField.text!, stateCode: selectedStateCode, addressLine1: addressline1TextField.text!, addressLine2: addressline2TextField.text!) { (success, message) -> Void in
            if success {
                KlinkAlert.sharedInstance.hide(.Long, message: message, color: .Success)
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                KlinkAlert.sharedInstance.hide(.Long, message: message, color: .Fail)
            }
        }
    }
    
    
    // MARK: Keyboard Notification

    func registerForKeyboardNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardFrameWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardFrameWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
    }
        
    func unRegisterForKeyboardNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    func keyboardFrameWillHide(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let animationDuration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let keyboardViewEndFrame = view.convertRect(keyboardScreenEndFrame, fromView: view.window)
        
        let keyboardScreenBeginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        let keyboardViewBeginFrame = view.convertRect(keyboardScreenBeginFrame, fromView: view.window)
        
        let delta = keyboardViewEndFrame.origin.y - keyboardViewBeginFrame.origin.y
        scrollViewBottomConstraint.constant -= delta
        UIView.animateWithDuration(animationDuration, delay:0, options:.BeginFromCurrentState, animations: {
            }, completion: nil)
        
    }
    
    func keyboardFrameWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo!
        let animationDuration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let keyboardViewEndFrame = view.convertRect(keyboardScreenEndFrame, fromView: view.window)
        scrollViewBottomConstraint.constant = keyboardViewEndFrame.size.height
        UIView.animateWithDuration(animationDuration, delay:0, options:.BeginFromCurrentState, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
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
        if let name = name {
            stateTextField.text = name
            selectedStateCode = code!
        }
    }

}
