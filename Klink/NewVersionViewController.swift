//
//  NewVersionViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 5/6/16.
//  Copyright © 2016 Ars Futura. All rights reserved.
//

import UIKit

class NewVersionViewController: UIViewController {
    internal var showAlertOnAppear = false
    lazy var alertController: UIAlertController = {
        let alertController = UIAlertController(title: "Hey, it looks like you may be missing out on some of our latest features. Be sure to update to the most recent version of Klink.", message: nil, preferredStyle: .Alert)
        let updateAction = UIAlertAction(title: "Update", style: .Cancel) { _ in
            let appUrl = NSURL(string: Constants.itunesStringUrl)
            UIApplication.sharedApplication().openURL(appUrl!)
        }
        alertController.addAction(updateAction)
        return alertController
    }()
  
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
  
    override func viewDidLoad() {
        navigationController?.navigationBar.hidden = true
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(backToNormalFlow), name: Constants.klinkAppHasNoUpdatesNotification, object: nil)
    }
  
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if showAlertOnAppear {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            navigationController?.presentViewController(alertController, animated: true, completion: nil)
        }
    }
  
    func backToNormalFlow(notifcation: NSNotification) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.beginNormalFlow()
    }
  
}
