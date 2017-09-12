//
//  KlinkRevealViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 24/08/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit

class KlinkRevealViewController: SWRevealViewController, SWRevealViewControllerDelegate {
    
    static let NOT_LOGGED_IN = "NOT_LOGGED_IN"
    static let DELIVERY_ADDRESS_ADDED = "DELIVERY_ADDRESS_ADDED"
    
    var overlayView:UIView?
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var screenWidth: CGFloat = 0.0
    var selectedIndex:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        screenWidth = screenSize.width
        self.rearViewController = MenuViewController()
        
        
        self.rearViewRevealWidth = screenWidth - 55
        self.rearViewRevealOverdraw = 0
        
        self.delegate = self
        
        if let _ = SessionManager.currentDeliveryAddress() {
            let navVC = RevealNavigationViewController(navigationBarClass: KlinkNavigationBar.self, toolbarClass: nil)
            navVC.setViewControllers([DiscoverViewController()], animated: false)
            self.setFrontViewController(navVC, animated: false)
        } else {
            let navVC = RevealNavigationViewController(rootViewController: AddressSearchViewController())
            self.setFrontViewController(navVC, animated: false)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showLogin", name: KlinkRevealViewController.NOT_LOGGED_IN, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showDiscoverScreen", name: KlinkRevealViewController.DELIVERY_ADDRESS_ADDED, object: nil)
        
        setUpOverlayView()
    }
    
    override func viewWillAppear(animated: Bool) {
//        self.presentViewController(TutorialMainViewController(), animated: false, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
//        self.presentViewController(TutorialMainViewController(), animated: false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //// MARK: - Helper Methods
    
    func showLogin() {
        print("SHOW LOGIN")
        
        if let vc = self.presentedViewController {
            
            if let cv = vc.presentedViewController {
                let loginVC = LoginViewController()
                loginVC.navigationItem.title = "LOG IN"
                let navVC = LoginNavigationController(rootViewController: loginVC)
                cv.presentViewController(navVC, animated: true, completion: nil)
            } else {
                let loginVC = LoginViewController()
                loginVC.navigationItem.title = "LOG IN"
                let navVC = LoginNavigationController(rootViewController: loginVC)
                vc.presentViewController(navVC, animated: true, completion: nil)
            }
        } else {
            let loginVC = LoginViewController()
            loginVC.navigationItem.title = "LOG IN"
            let navVC = LoginNavigationController(rootViewController: loginVC)
            self.presentViewController(navVC, animated: true, completion: nil)
        }
    }
    
    func showDiscoverScreen() {
        let navVC = RevealNavigationViewController(navigationBarClass: KlinkNavigationBar.self, toolbarClass: nil)
        navVC.setViewControllers([DiscoverViewController()], animated: false)
        self.setFrontViewController(navVC, animated: false)
        self.setFrontViewPosition(FrontViewPosition.Left, animated: true)
    }
    
    func setUpOverlayView() {
        overlayView = UIView(frame: UIScreen.mainScreen().bounds)
        overlayView?.backgroundColor = UIColor.blackColor()
        overlayView?.alpha = 0
    }
    
    func addOverlay() {
        if overlayView?.superview == nil {
            self.frontViewController.view.addSubview(overlayView!)
            overlayView!.addGestureRecognizer(self.panGestureRecognizer())
            overlayView!.addGestureRecognizer(self.tapGestureRecognizer())
        }
    }
    
    func removeOverlay() {
        self.overlayView?.removeFromSuperview()
//        self.frontViewController.view.addGestureRecognizer(self.panGestureRecognizer())
//        self.frontViewController.view.addGestureRecognizer(self.tapGestureRecognizer())
    }
    
    //// MARK: - RevealViewControllerDelegate Methods
    
    func revealController(revealController: SWRevealViewController!, willMoveToPosition position: FrontViewPosition) {
        if position == FrontViewPosition.Right {
            self.frontViewController.view.endEditing(true)
        }
    }
    
    func revealController(revealController: SWRevealViewController!, panGestureMovedToLocation location: CGFloat, progress: CGFloat, overProgress: CGFloat) {
        overlayView?.alpha = progress / 2.0
    }

    func revealController(revealController: SWRevealViewController!, panGestureBeganFromLocation location: CGFloat, progress: CGFloat, overProgress: CGFloat) {
        addOverlay()
    }
    
    func revealController(revealController: SWRevealViewController!, animateToPosition position: FrontViewPosition) {
//        println("animate to position \(position)")
        
        if position == FrontViewPosition.Right {
            UIView.animateWithDuration(1, animations: { () -> Void in
                self.overlayView?.alpha = 0.5
                })
        } else if position == FrontViewPosition.Left {
            UIView.animateWithDuration(1, animations: { () -> Void in
                self.overlayView?.alpha = 0
            }, completion: { (finished) -> Void in
                self.removeOverlay()
            })
            
        }
    }
    
    override func revealToggle(sender: AnyObject!) {
        addOverlay()
        if self.frontViewPosition == FrontViewPosition.Left {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.overlayView?.alpha = 0.5
            })
        } else if self.frontViewPosition == FrontViewPosition.Right {
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.overlayView?.alpha = 0
                }, completion: { (finished) -> Void in
                    self.removeOverlay()
            })
        }
        super.revealToggle(sender)
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
