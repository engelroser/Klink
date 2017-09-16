//
//  MainSearchAddresViewController.swift
//  Klink
//
//  Created by Mobile app Dev on 25/08/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit
import CoreLocation
import TTTAttributedLabel

@objc protocol MainAddressSearchViewControllerDelegate {

    optional func mainSearchAddressViewControllerDidUpdateLocation(controller: MainAddressSearchViewController, location: CLLocationCoordinate2D)
}

class MainAddressSearchViewController: UIViewController, CLLocationManagerDelegate, TTTAttributedLabelDelegate{

    
    @IBOutlet var termsUseLabel: TTTAttributedLabel!
    @IBOutlet var containerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var backgroundElementsHolder: UIView!
    @IBOutlet var currentLocationButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet var parachuteImageViewBottomConstraint: NSLayoutConstraint!

    var delegate: MainAddressSearchViewControllerDelegate?
    let manager = CLLocationManager()
    var shrinked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setTermsOfUseLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Helper Methods
    
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
    
    func shrinkBackgroundElements() {
//        if !shrinked {
            currentLocationButtonTopConstraint.constant = (backgroundElementsHolder.frame.size.height) / 8.8
            parachuteImageViewBottomConstraint.constant = (backgroundElementsHolder.frame.size.height) / 8.8
            self.view.layoutIfNeeded()
//        }
        shrinked = true
    }
    
    func expandBackgroundElements() {
        currentLocationButtonTopConstraint.constant = (backgroundElementsHolder.frame.size.height) * 8.8
        parachuteImageViewBottomConstraint.constant = (backgroundElementsHolder.frame.size.height ) * 8.8
        self.view.layoutIfNeeded()
    }
    
    // MARK: - Button Actions

    @IBAction func useCurrentLocationPressed(sender: AnyObject) {
        (self.parentViewController as! AddressSearchViewController).searchBar.endEditing(true)
        
        manager.delegate = self
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            manager.requestWhenInUseAuthorization()
        }
        else if CLLocationManager.locationServicesEnabled() &&  CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse{
            manager.startUpdatingLocation()
        } else if !CLLocationManager.locationServicesEnabled() ||  CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Denied {
            Permissions.alertPermissionNotAllowed(self, message: "Please enable location service in settings.")        }
//        println("Get location")
    }
    
    // MARK: - TTTAttributedLabelDelegate
    
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        let backItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        if (self.parentViewController != nil) {
            self.parentViewController!.navigationItem.backBarButtonItem = backItem
        } else {
            navigationItem.backBarButtonItem = backItem
        }
        self.navigationController?.pushViewController(KlinkWebViewController(title: "TERMS OF USE", url: Constants.termsStringUrl), animated: true)
    }
    
    // MARK: - Location Service Delegate

    func locationManager(manager: CLLocationManager,
        didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            manager.startUpdatingLocation()
            // ...
        }
    }

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
//        println("locations = \(locValue.latitude) \(locValue.longitude)")
        manager.stopUpdatingLocation()
        self.delegate?.mainSearchAddressViewControllerDidUpdateLocation!(self, location: locValue)
    }

    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location manager did fail with error: \(error)")
        let alert = UIAlertController(title: "", message: "Error while getting location", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
