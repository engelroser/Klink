//
//  KlinkAlert.swift
//  Klink
//
//  Created by Mobile App Dev on 01/09/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import Foundation


class KlinkAlert {
    static let sharedInstance = KlinkAlert()
    var window:UIWindow?
    var visualEffectView:UIVisualEffectView!
    
    enum AlertColor {
        case Success
        case Fail
        case Neutral
    }
    
    enum Duration : Double {
        case Short = 0.3
        case Medium = 0.8
        case Long = 2.0
    }
    
    func showLoadingWindow() {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
//        let screenHeight = screenSize.height
        
        if let _ = window {
            return
        }
        let view = KlinkAlertView(frame: CGRectMake(0, -64, screenWidth, 64))
        view.tag = 1
        view.backgroundColor = UIColor.kvfKlinkOrangeColor()
        window = UIWindow(frame: screenSize)
        window?.backgroundColor = UIColor.clearColor().colorWithAlphaComponent(0.5)
        window?.alpha = 0
        
        UIApplication.sharedApplication().keyWindow?.endEditing(true)
        self.window?.addSubview(view)
        self.window?.windowLevel = UIWindowLevelAlert
        self.window?.makeKeyAndVisible()
        show()
    }
    
    
    func show() {
//        print("Window is: \(window)")
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
//        let screenHeight = screenSize.height
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            let v = self.window?.viewWithTag(1)
            v?.frame = CGRectMake(0, 0, screenWidth, 64)
            self.window?.alpha = 1
//            self.window?.frame = CGRectMake(0, 0, screenWidth, 64)
            self.window?.makeKeyAndVisible()
            }) { (completed) -> Void in
//                print("Show completed")
        }
    }
    
    func hide(delay: Double, message: String?, color: AlertColor) {
        if self.window == nil {
            return
        }
        let d = delay * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(d))
        let v = self.window?.viewWithTag(1) as! KlinkAlertView
        v.messageLabel.text = message
        v.spinner.hidden = true
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.setColor(color)
        })
        
        dispatch_after(time, dispatch_get_main_queue(), {
            self.hide(message, color: color)
        })
    }
    
    func hide(delay: Duration, message: String?, color: AlertColor) {
        if self.window == nil {
            return
        }
        let d = delay.rawValue * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(d))
        let v = self.window?.viewWithTag(1) as! KlinkAlertView
        v.messageLabel.text = message
        v.spinner.hidden = true
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.setColor(color)
        })
        
        dispatch_after(time, dispatch_get_main_queue(), {
            self.hide(message, color: color)
        })
    }
    
    
    func hide(message: String?, color: AlertColor) {
        if self.window == nil {
            return
        }
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            let v = self.window?.viewWithTag(1)
            v?.frame = CGRectMake(0, -64, screenWidth, 64)
            self.window?.alpha = 0
            }) { (completed) -> Void in
                if completed {
                    self.window = nil
                }
        }
    }
    
    
    func setColor(color: AlertColor) {
        switch (color) {
        case .Success:
            self.window?.viewWithTag(1)!.backgroundColor = UIColor.kvfAlgaeColor()
            break
        case .Fail:
            self.window?.viewWithTag(1)!.backgroundColor = UIColor.kvfBrickColor()
            break
        case .Neutral:
            self.window?.viewWithTag(1)!.backgroundColor = UIColor.kvfKlinkOrangeColor()
            break
        }
    }
}