//
//  CheckoutMainViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 01/10/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit
import PureLayout

class CheckoutMainViewController: UIViewController {
    
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var contentView: UIView!
    @IBOutlet var contentViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet var termsLabel: UILabel!
    
    @IBOutlet var termsLabelBottomConstraint: NSLayoutConstraint!
    init() {
        super.init(nibName: "CheckoutMainViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.setKlinkTitleView("CHECKOUT")
        
        
    
        scrollView.pagingEnabled = true
        
        registerForKeyboardNotification()
        
        let tapDissmis = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tapDissmis)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        
        contentViewWidthConstraint.constant = screenWidth * 3
        
        
//        for i in 0...1 {
//            let checkoutGiftVC = CheckoutGiftViewController()
//            let v = checkoutGiftVC.view
//            addChildViewController(checkoutGiftVC)
//            contentView.addSubview(v)
//            checkoutGiftVC.didMoveToParentViewController(self)
//            v.translatesAutoresizingMaskIntoConstraints = false
//            v.autoPinEdgeToSuperviewEdge(.Top)
//            v.autoPinEdgeToSuperviewEdge(.Bottom)
//            //            v.autoPinEdgeToSuperviewEdge(.Bottom, withInset: pageControl.frame.origin.x + pageControl.frame.size.height )
//            v.autoSetDimension(.Width, toSize: screenWidth)
//            v.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Left, ofView: contentView, withOffset: screenWidth * CGFloat(i) )
//        }
//        
//        let paymentVC = CheckoutPaymentViewController()
//        let v = paymentVC.view
//        addChildViewController(paymentVC)
//        contentView.addSubview(v)
//        paymentVC.didMoveToParentViewController(self)
//        v.translatesAutoresizingMaskIntoConstraints = false
//        v.autoPinEdgeToSuperviewEdge(.Top)
//        v.autoPinEdgeToSuperviewEdge(.Bottom)
//        //            v.autoPinEdgeToSuperviewEdge(.Bottom, withInset: pageControl.frame.origin.x + pageControl.frame.size.height )
//        v.autoSetDimension(.Width, toSize: screenWidth)
//        v.autoPinEdge(ALEdge.Left, toEdge: ALEdge.Left, ofView: contentView, withOffset: screenWidth * 2 )
        
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
        
        termsLabelBottomConstraint.constant -= originDelta
        UIView.animateWithDuration(animationDuration) { () -> Void in
            self.view.layoutIfNeeded()
        }
        
    }


}
