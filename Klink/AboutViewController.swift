//
//  AboutViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 03/09/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController, SocialAppsControllerDelegate {
    
    var tableView:UITableView!
    
    let cellTitles = [
        "What we're about",
        "Rate us in the App Store",
        "Terms of Use"
    ]
    
    @IBOutlet var socialContainer: UIView!
    
    @IBOutlet var appVersionLabel: UILabel!
    
    init() {
        super.init(nibName: "AboutViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.setKlinkTitleView("ABOUT")
    }
    
    override func viewWillAppear(animated: Bool) {
        let socialVC = SocialAppsViewController()
        addChildViewController(socialVC)
        socialVC.view.frame = socialContainer.bounds
        socialVC.view.backgroundColor = UIColor.clearColor()
        socialVC.delegate = self
        socialContainer.addSubview(socialVC.view)
        socialVC.didMoveToParentViewController(self)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        paragraphStyle.alignment = NSTextAlignment.Center
        let attrString = NSMutableAttributedString(string: "Klink Technologies\nversion \((UIApplication.sharedApplication().delegate as! AppDelegate).currentAppVersion())")
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        appVersionLabel.attributedText = attrString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - SocialAppsController Delegate
    
    func facebookPressed(controller: SocialAppsViewController) {
        openUrlInApp("FACEBOOK", url: Constants.klinkFacebook)
    }
    
    func twitterPressed(controller: SocialAppsViewController) {
        openUrlInApp("TWITTER", url: Constants.klinkTwitter)
    }
    
    func instagramPressed(controller: SocialAppsViewController) {
        openUrlInApp("INSTAGRAM", url: Constants.klinkInstagram)
    }
    
    func pinterestPressed(controller: SocialAppsViewController) {
        openUrlInApp("PINTEREST", url: Constants.klinkPinterest)
    }
    
    // MARK: - Button Actions
    
    @IBAction func whatWeAreAboutPressed(sender: AnyObject) {
//        UIApplication.sharedApplication().openURL(NSURL(string: Constants.klinkHomepage)!)
        openUrlInApp("WHAT WE'RE ABOUT", url: Constants.klinkAboutPage)
    }

    @IBAction func rateUsPressed(sender: AnyObject) {
        let appUrl = NSURL(string: Constants.itunesStringUrl)
        UIApplication.sharedApplication().openURL(appUrl!)
    }
    
    @IBAction func termsOfUsePressed(sender: AnyObject) {
//        UIApplication.sharedApplication().openURL(NSURL(string: Constants.termsStringUrl)!)
        openUrlInApp("TERMS OF USE", url: Constants.termsStringUrl)
    }
    
    // MARK: - Helper Methods
    
    func openUrlInApp(title: String, url: String) {
        let backItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(KlinkWebViewController(title: title, url: url), animated: true)
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
