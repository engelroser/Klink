//
//  SocialAppsViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 04/09/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit

protocol SocialAppsControllerDelegate {
    func facebookPressed(controller:SocialAppsViewController)
    func twitterPressed(controller:SocialAppsViewController)
    func instagramPressed(controller:SocialAppsViewController)
    func pinterestPressed(controller:SocialAppsViewController)
}

class SocialAppsViewController: UIViewController {
    
    var delegate:SocialAppsControllerDelegate?
    
    init() {
        super.init(nibName: "SocialAppsViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Button Actions
    
    @IBAction func facebookButtonPressed(sender: AnyObject) {
        let klinkFacebookID =  "541327939261717"
        let appUrl = NSURL(string: "fb://profile/541327939261717")
        let webUrl = NSURL(string: "https://www.facebook.com/klinkdelivery")
        if (UIApplication.sharedApplication().canOpenURL(appUrl!)) {
            // Facebook app is installed
            print("facebook")
            UIApplication.sharedApplication().openURL(appUrl!)
        } else {
            print("no facebook")
//            UIApplication.sharedApplication().openURL(webUrl!)
            delegate?.facebookPressed(self)
        }
    }

    @IBAction func twitterButtonPressed(sender: AnyObject) {
        //twitter:///user?screen_name=jessicaalba
        let appUrl = NSURL(string: "twitter:///user?screen_name=klinkdelivery")
        let webUrl = "https://twitter.com/klinkdelivery"
        if (UIApplication.sharedApplication().canOpenURL(appUrl!)) {
            // Twitter app is installed
            UIApplication.sharedApplication().openURL(appUrl!)
        } else {
//            UIApplication.sharedApplication().openURL(webUrl!)
//            var webVC = KlinkWebViewController(title: "test", url: webUrl)
//            self.navigationController?.pushViewController(webVC, animated: true)
            delegate?.twitterPressed(self)
        }
    }
    
    @IBAction func instagramButtonPressed(sender: AnyObject) {
        //https://instagram.com/klink_delivery/
        let appUrl = NSURL(string: "instagram://user?username=klink_delivery")
        let webUrl = NSURL(string: "https://instagram.com/klink_delivery/")
        if (UIApplication.sharedApplication().canOpenURL(appUrl!)) {
            // Twitter app is installed
            UIApplication.sharedApplication().openURL(appUrl!)
        } else {
//            UIApplication.sharedApplication().openURL(webUrl!)
            delegate?.instagramPressed(self)
        }
    }

    @IBAction func pinterestButtonPressed(sender: AnyObject) {
        //https://www.pinterest.com/Klinkdelivery/
        //pinit12://pinterest.com/pin/create/bookmarklet/?
        let appUrl = NSURL(string: "pinit12://pinterest.com/Klinkdelivery/")
        let webUrl = NSURL(string: "https://www.pinterest.com/Klinkdelivery/")
        if (UIApplication.sharedApplication().canOpenURL(appUrl!)) {
            // Twitter app is installed
            UIApplication.sharedApplication().openURL(appUrl!)
        } else {
//            UIApplication.sharedApplication().openURL(webUrl!)
            delegate?.pinterestPressed(self)
        }
    }
    
    
}
