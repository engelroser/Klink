//
//  ForgotPasswordViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 23/10/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet var emailTextField: KlinkDarkTextField!
    @IBOutlet var containerView: UIView!
    
    init() {
        super.init(nibName: "ForgotPasswordViewController", bundle: nil)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        self.modalPresentationStyle = .Custom
        self.transitioningDelegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        containerView.layer.cornerRadius = 5.0
        containerView.layer.masksToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tapGesture)
        
        registerForKeyboardNotification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        emailTextField.becomeFirstResponder()
    }
    
    deinit {
        unRegisterForKeyboardNotification()
    }
    
    func dismissKeyboard() {
        if emailTextField.isFirstResponder() {
            view.endEditing(true)
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
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
        var frame = self.view.frame
        frame.size.height += originDelta
        self.view.frame = frame
        UIView.animateWithDuration(animationDuration) { () -> Void in
            
            
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func dismissPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func resetPasswordPressed(sender: AnyObject) {
        KlinkAlert.sharedInstance.showLoadingWindow()
        
        let parameters:[String:AnyObject] = [
            "email" : emailTextField.text!
        ]
        
        APIClient.sharedClient.klinkRequest(.POST, URLString: "user/reset-password/", parameters: parameters) { (response) -> Void in
            let result = response.result
            switch result {
            case .Success(_):
                KlinkAlert.sharedInstance.hide(.Long, message: "Instruction sent to your email address", color: .Success)
                break
            case .Failure(_):
                if response.response?.statusCode == 204 {
                    KlinkAlert.sharedInstance.hide(.Long, message: "Instructions sent to your email address", color: .Success)
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    KlinkAlert.sharedInstance.hide(.Long, message: "Error occured, please try again.", color: .Fail)
                }
            }
        }
    }
    
    // ---- UIViewControllerTransitioningDelegate methods
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        if presented == self {
            return SlideFromBottomPresentationController(presentedViewController: presented, presentingViewController: presenting)
        }
        
        return nil
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if presented == self {
            return SlideFromBottomAnimationController(isPresenting: true)
        }
        else {
            return nil
        }
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if dismissed == self {
            return SlideFromBottomAnimationController(isPresenting: false)
        }
        else {
            return nil
        }
    }
    

}
