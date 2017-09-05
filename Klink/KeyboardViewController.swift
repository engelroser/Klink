//
//  KeyboardViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 03/09/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit

class KeyboardViewController: BaseViewController {
    
    var backgroundImageView:UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//            selector:@selector(keyboardFrameDidChange:)
//        name:UIKeyboardDidChangeFrameNotification object:nil];
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardFrameDidChange:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardDidHideNotification, object: nil)
        
        let tapRec = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tapRec)
        
//        backgroundImageView = UIImageView(frame: view.bounds)
//        view.addSubview(backgroundImageView!)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Helper Methods
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
//    func keyboardDidHide(notification: NSNotification) {
//        //        println("Keyboard will change frame")
//        let userInfo = notification.userInfo!
//        //        let animationDuration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
//        
//        let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
//        
//        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height + keyboardFrame.size.height)
//        
//        view.setNeedsUpdateConstraints()
//        
//        UIView.animateWithDuration(0.2, delay:0, options:.BeginFromCurrentState, animations: {
//            self.view.layoutIfNeeded()
//            }, completion: nil)
//        
//    }
    
    func keyboardFrameDidChange(notification: NSNotification) {
        //        println("Keyboard will change frame")
        let userInfo = notification.userInfo!
        let animationDuration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        
        let diff = keyboardEndFrame.origin.y - keyboardFrame.origin.y
        
        if keyboardEndFrame.origin.y > keyboardFrame.origin.y {
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height + diff)
        } else {
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height + diff)
        }
        view.setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(animationDuration, delay:0, options:.BeginFromCurrentState, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
