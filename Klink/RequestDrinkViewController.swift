//
//  RequestDrinkViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 03/09/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit

class RequestDrinkViewController: BaseViewController {
    
    @IBOutlet var scrollViewBottomConstraint: NSLayoutConstraint!
    init() {
        super.init(nibName: "RequestDrinkViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.setKlinkTitleView("ITEM REQUEST")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: UIBarButtonItemStyle.Done, target: self, action: "submitPressed:")
        
        registerForKeyboardNotification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        unRegisterForKeyboardNotification()
    }
    
    // MARK: - Button Actions
    
    func submitPressed(button: UIBarButtonItem) {
        print("Submit request")
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        spinner.startAnimating()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: spinner)
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
//        
//        let keyboardScreenBeginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        scrollViewBottomConstraint.constant = keyboardScreenEndFrame.size.height
        UIView.animateWithDuration(animationDuration) { () -> Void in
            self.view.layoutIfNeeded()
        }
        
    }

}
