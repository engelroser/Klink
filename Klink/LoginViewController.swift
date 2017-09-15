//
//  LoginViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 31/08/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit
import TTTAttributedLabel

protocol LoginViewDelegate {
    func userDidSignedUp()
    func userDidLoggedIn()
}

class LoginViewController: UIViewController, TTTAttributedLabelDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, UIPopoverPresentationControllerDelegate, PopDateViewDelegate {
    
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var fullNameTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    @IBOutlet var dobTextField: KlinkTextField!
    
    @IBOutlet var doneButton: BorderedButton!
    @IBOutlet var firstDividerView: UIView!
    
    @IBOutlet var fifthDividerView: UIView!
    @IBOutlet var sixthDividerView: UIView!
    
    @IBOutlet var forgotButton: UIButton!
    
    @IBOutlet var termsUseLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet var dobTextFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet var fullNameTextFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet var confirmPasswordTextFieldHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var forgotButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    @IBOutlet var scrollViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var termsUseLabel: TTTAttributedLabel!
    
    @IBOutlet var facebookButton: BorderedButton!
    
    var delegate:LoginViewDelegate?
    
    let loginSegmentIndex:Int = 0
    let signupSegmentIndex:Int = 1
    
    
    init() {
        super.init(nibName: "LoginViewController", bundle: nil)
//        showLogin(false)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpTextFields()
        setTermsOfUseLabel()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardFrameWillHide:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardFrameWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Done, target: self, action: "dismissViewController")
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.extendedLayoutIncludesOpaqueBars = true
        
        let tapRec = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tapRec.delegate = self
        view.addGestureRecognizer(tapRec)
        
        forgotButton.addTarget(self, action: "forgotPassPressed", forControlEvents: .TouchUpInside)
    }
    
    override func viewWillAppear(animated: Bool) {
        showLogin(false)
        debugPrint("View will appear")
    }
    
    override func viewDidAppear(animated: Bool) {
        emailTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.view.endEditing(true)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Gesture Recognizer
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if let v = touch.view {
            if v.isKindOfClass(TTTAttributedLabel.self)  {
                return false
            }
            if v.isKindOfClass(UITableViewCell.self) {
                return false
            }
            if let view = v.superview {
                if view.isKindOfClass(UITableViewCell.self)  {
                    return false
                }
            }
        }
        
        return true
    }
    
    // MARK: - Keyboard Notification
    
    func keyboardFrameWillHide(notification: NSNotification) {
//        debugPrint("Keyboard will change frame")
        let userInfo = notification.userInfo!
        let animationDuration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let keyboardViewEndFrame = view.convertRect(keyboardScreenEndFrame, fromView: view.window)
        
        let keyboardScreenBeginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        let keyboardViewBeginFrame = view.convertRect(keyboardScreenBeginFrame, fromView: view.window)
        
        let delta = keyboardViewEndFrame.origin.y - keyboardViewBeginFrame.origin.y
//        debugPrint("Delta: \(delta)")
        scrollViewBottomConstraint.constant -= delta
        UIView.animateWithDuration(animationDuration, delay:0, options:.BeginFromCurrentState, animations: {
//            self.view.layoutIfNeeded()
            }, completion: nil)
        
    }
    
    func keyboardFrameWillShow(notification: NSNotification) {
//        debugPrint("Keyboard will show frame")
        let userInfo = notification.userInfo!
        let animationDuration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let keyboardViewEndFrame = view.convertRect(keyboardScreenEndFrame, fromView: view.window)
//        let keyboardScreenBeginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
//        let keyboardViewBeginFrame = view.convertRect(keyboardScreenBeginFrame, fromView: view.window)
//        
//        let delta = keyboardViewEndFrame.origin.y - keyboardViewBeginFrame.origin.y
//        debugPrint("Delta: \(delta)")
        scrollViewBottomConstraint.constant = keyboardViewEndFrame.size.height
        UIView.animateWithDuration(animationDuration, delay:0, options:.BeginFromCurrentState, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
    
    // MARK: - Helper Methods
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func dismissViewController() {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setTermsOfUseLabel() {
        let termsLabelString:String! = "To Klink you must be 21 or older and agree to the terms of use."
        let substring: String! = "terms of use"
        termsUseLabel.delegate = self
        termsUseLabel.text = termsLabelString
        let start:Int! = ((termsLabelString!).characters.count - (substring!).characters.count )
        let length:Int! = (substring!).characters.count
        
        let range = NSMakeRange(start - 1, length)
        
        let url = NSURL(string: "https://klinkdelivery.com/tou")!
        let subscriptionNoticeActiveLinkAttributes = [
            NSForegroundColorAttributeName: UIColor.blueColor().colorWithAlphaComponent(0.80),
            NSUnderlineStyleAttributeName: NSNumber(bool:true),
        ]
        
        termsUseLabel.linkAttributes = [NSForegroundColorAttributeName : termsUseLabel.textColor!, NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
        termsUseLabel.activeLinkAttributes = subscriptionNoticeActiveLinkAttributes
        termsUseLabel.addLinkToURL(url, withRange: range)
        termsUseLabel.userInteractionEnabled = true
    }
    
    func setUpTextFields() {
        fullNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        dobTextField.delegate = self
        
        confirmPasswordTextField.returnKeyType = UIReturnKeyType.Next
    }
    
    func showLogin(animate: Bool) {
        fullNameTextFieldHeightConstraint.constant = 0.0;
        confirmPasswordTextFieldHeightConstraint.constant = 0.0
        dobTextFieldHeightConstraint.constant = 0.0
        firstDividerView.alpha = 0.0
        fifthDividerView.alpha = 0.0
        sixthDividerView.alpha = 0.0
        forgotButtonWidthConstraint.constant = 57.0
        
        if animate {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.view.layoutIfNeeded()
                self.emailTextField.becomeFirstResponder()
                self.navigationItem.title = "LOG IN"
                self.doneButton.setTitle("LOG IN", forState: .Normal)
                self.facebookButton.setImage(UIImage(named: "facebook-button-login"), forState: .Normal)
            })
        }
    }
    
    func showSignup(animate: Bool) {
        fullNameTextFieldHeightConstraint.constant = 49.0
        confirmPasswordTextFieldHeightConstraint.constant = 49.0
        dobTextFieldHeightConstraint.constant = 49.0
//        fullNameTextField.enabled = true
//        confirmPasswordTextField.enabled = true
        firstDividerView.alpha = 1.0
        fifthDividerView.alpha = 1.0
        sixthDividerView.alpha = 1.0
        forgotButtonWidthConstraint.constant = 0.0
        
        if animate {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.view.layoutIfNeeded()
                self.fullNameTextField.becomeFirstResponder()
                self.doneButton.setTitle("SIGN UP", forState: .Normal)
                self.navigationItem.title = "SIGN UP"
                self.facebookButton.setImage(UIImage(named: "facebook-button-signup"), forState: .Normal)
            })
        }
    }
    
    func signUp() {
        KlinkAlert.sharedInstance.showLoadingWindow()
        
        if InputValidator.isEmpty(fullNameTextField.text!) {
            KlinkAlert.sharedInstance.hide(.Long, message: "Please enter your full name.", color: KlinkAlert.AlertColor.Fail)
            return
        } else {
            let fullNameArray = fullNameTextField.text!.characters.split{$0 == " "}.map(String.init)
            
            if fullNameArray.count < 2 {
                KlinkAlert.sharedInstance.hide(.Long, message: "You have to enter a first and last name.", color: KlinkAlert.AlertColor.Fail)
                return
            }
        }
        
        if !InputValidator.isValidEmail(emailTextField.text!) {
            KlinkAlert.sharedInstance.hide(.Long, message: "Please enter a valid email address.", color: KlinkAlert.AlertColor.Fail)
            return
        }
        
        let passwordValidator = InputValidator.validPassword(passwordTextField.text, pass2: confirmPasswordTextField.text)
        
        if !passwordValidator.valid {
            KlinkAlert.sharedInstance.hide(.Long, message: passwordValidator.message, color: KlinkAlert.AlertColor.Fail)
            return
        }
        
        let df = NSDateFormatter()
        df.dateStyle = .MediumStyle
        df.timeStyle = .NoStyle
        
        let dob = df.dateFromString(dobTextField.text!)
        
        if InputValidator.isEmpty(dobTextField.text!) {
            KlinkAlert.sharedInstance.hide(.Long, message: "Please enter your birth date.", color: KlinkAlert.AlertColor.Fail)
            return
        } else {
            
            let yearCalendarUnit: NSCalendarUnit = [.Year]
            let userCalendar = NSCalendar.currentCalendar()
            
            let age = userCalendar.components(
                yearCalendarUnit,
                fromDate: dob!,
                toDate: NSDate(),
                options: [ ])
            
            if age.year < 21 {
                KlinkAlert.sharedInstance.hide(.Long, message: "You have to be older than 21 to use Klink.", color: KlinkAlert.AlertColor.Fail)
                return
            }
            
        }
        
        let dfForAPI = NSDateFormatter()
        dfForAPI.dateStyle = .MediumStyle
        dfForAPI.timeStyle = .NoStyle
        
        let dobForAPI = dfForAPI.dateFromString(dobTextField.text!)

        SignupModel().signup(fullNameTextField.text, email: emailTextField.text, password: passwordTextField.text, confirmPassword: confirmPasswordTextField.text, dob: dobForAPI) { (result, error) -> Void in
            if (error != nil) {
                KlinkAlert.sharedInstance.hide(.Long, message: result, color: KlinkAlert.AlertColor.Fail)
            } else {
                KlinkAlert.sharedInstance.hide(.Long, message: result, color: KlinkAlert.AlertColor.Success)
                if let d = self.delegate {
                    d.userDidSignedUp()
                }
                self.dismissViewController()
            }
        }
    }
    
    func login() {
        KlinkAlert.sharedInstance.showLoadingWindow()
        
        if !InputValidator.isValidEmail(emailTextField.text!) {
            KlinkAlert.sharedInstance.hide(.Long, message: "Please enter a valid email address.", color: KlinkAlert.AlertColor.Fail)
            return
        }
        
        if InputValidator.isEmpty(passwordTextField.text!) {
            KlinkAlert.sharedInstance.hide(.Long, message: "Please enter your password.", color: KlinkAlert.AlertColor.Fail)
            return
        }
        
        LoginModel.loginWithEmail(emailTextField.text!, password: passwordTextField.text!) { (result, error) -> Void in
            if (error != nil) {
                KlinkAlert.sharedInstance.hide(.Long, message: result, color: KlinkAlert.AlertColor.Fail)
            } else {
                KlinkAlert.sharedInstance.hide(.Long, message: "Welcome back!", color: KlinkAlert.AlertColor.Success)
                if let d = self.delegate {
                    d.userDidLoggedIn()
                }
                self.dismissViewController()
            }
        }
//        KlinkAlert.sharedInstance.hide(2.0, message: "Log In not connected to the API.", color: KlinkAlert.AlertColor.Fail)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        if textField == dobTextField {
            textField.endEditing(true)
            view.endEditing(true)
            let vc = PopDateViewController()
            vc.delegate = self
            presentViewController(vc, animated: true, completion:nil)
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == emailTextField || textField == fullNameTextField{
            textField.returnKeyType = UIReturnKeyType.Next
        } else {
            if segmentedControl.selectedSegmentIndex == loginSegmentIndex {
            passwordTextField.returnKeyType = UIReturnKeyType.Go
            } else {
                passwordTextField.returnKeyType = UIReturnKeyType.Next
            }
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        textField.layoutIfNeeded()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if segmentedControl.selectedSegmentIndex == loginSegmentIndex {
            if textField == emailTextField {
                passwordTextField.becomeFirstResponder()
            } else {
                print("Log In")
//                login()
                
//                KlinkAlert.sharedInstance.showWithTitle("heheh", andDuration: 2.0, onView: self.view)
            }
        } else {
            if textField == fullNameTextField {
                emailTextField.becomeFirstResponder()
            }else if textField == emailTextField {
                passwordTextField.becomeFirstResponder()
            } else if textField == passwordTextField {
                confirmPasswordTextField.becomeFirstResponder()
            } else if textField == confirmPasswordTextField {
                dobTextField.becomeFirstResponder()
            } else {
                textField.endEditing(true)
            }
        }
        
        return true
    }
    
    // MARK: - TTTAttributedLabelDelegate
    
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        let backItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(KlinkWebViewController(title: "TERMS OF USE", url: Constants.termsStringUrl), animated: true)
    }
    
    // MARK: - Button Actions
    
    @IBAction func segmentValueChanged(sender: UISegmentedControl) {
//        println("segment \(sender.selectedSegmentIndex)")
        
        if sender.selectedSegmentIndex == loginSegmentIndex {
            showLogin(true)
        } else {
            showSignup(true)
        }
    }
    
    @IBAction func facebookButtonPressed(sender: AnyObject) {
//        let facebookLogin:FBSDKLoginManager! = FBSDKLoginManager()
////        let params = ["fields": "public_profile", "email"]
//        
//        facebookLogin.logInWithReadPermissions(["email"], handler: { (result: FBSDKLoginManagerLoginResult!, error: NSError!) -> Void in
//            if (error != nil) {
//                print("Facebook login error: \(error)")
//            } else if result.isCancelled {
//                print("Facebook login cancelled")
//            } else {
//                print("Facebook result \(result)")
//                let request = FBSDKGraphRequest(graphPath:"me", parameters: ["fields":"email,first_name,last_name,gender"]);
//                
//                request.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
//                    if error == nil {
//                        print("The information requested is : \(result)")
//                    } else {
//                        print("Error getting information \(error)");
//                    }
//                }
//            }
//        })
//        
        
    }
    
    // MARK: - UIPopoverPresentationControllerDelegate
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        let navigationController = UINavigationController(rootViewController: controller.presentedViewController)
        let btnDone = UIBarButtonItem(title: "Done", style: .Done, target: self, action: "dismiss")
        navigationController.topViewController!.navigationItem.rightBarButtonItem = btnDone
        return navigationController
    }
    
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - PopDateViewDelegate
    
    func popDateDismissed(controller: PopDateViewController, date: NSDate?) {
        print("selected date: \(date)")
        // NSString *localizedDateTime = [NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle]
        if let date = date {
            let localString = NSDateFormatter.localizedStringFromDate(date, dateStyle: NSDateFormatterStyle.MediumStyle, timeStyle: NSDateFormatterStyle.NoStyle)
            print("Localized:\(localString)")
            dobTextField.text = localString
        }
    }
    

    // MARK: - Button Actions
    
    func forgotPassPressed() {
        self.presentViewController(ForgotPasswordViewController(), animated: true, completion: nil)
    }
    
    @IBAction func loginSignupPressed(sender: AnyObject) {
        if segmentedControl.selectedSegmentIndex == loginSegmentIndex {
            login()
            
        } else {
            signUp()
        }
    }
    

}
