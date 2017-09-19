//
//  MapViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 25/08/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

@objc protocol MapViewControllerDelegate {
    optional func mapViewControllerDidGetAddress(controller: MapViewController, addressString: String)
    optional func deliveryAddressChanged()
}

class MapViewController: UIViewController {

    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var orderArrowImageView: UIImageView!
    @IBOutlet var orderLabel: KLLabel!
    @IBOutlet var orderContainerView: UIView!
    @IBOutlet var storeHoursView: UIView!
    @IBOutlet var storeHoursHolderViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var viewStoreHoursLabel: UILabel!
    @IBOutlet var storeHoursDaysHolderView: UIView!
    @IBOutlet var daysHolderView: UIView!
    
    let storeHoursHideConstraintConstant: CGFloat = -115.0
    let storeHoursShowConstraintConstant: CGFloat = 45.0
    
    var markerLocation:CLLocationCoordinate2D!
    var delegate:MapViewControllerDelegate?
    
    var deliveryAddress:RecentAddress?
    
    var tempBarButtonItem:UIBarButtonItem?
    
    let colorAvailable = UIColor.kvfAlgaeColor()
    let colorNotAvailable = UIColor.kvfDuskColor()
    let colorNotHereYet = UIColor.kvfBrickColor()
    
    let availableString = "START MY ORDER"
    let unavailableString = "STORE IS CLOSED. BROWSE ANYWAY?"
    let notHereYetString = "KLINK ISN’T HERE YET." //
    
    var storesIDs:[Int] = []
    
    init(location: CLLocationCoordinate2D) {
        super.init(nibName: "MapViewController", bundle: nil)
        self.markerLocation = location
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("Map Controller loaded")
        
        let marker = GMSMarker(position: markerLocation)
//        marker.title = "Hello World"
        marker.icon = UIImage(named: "map-marker")
        marker.map = mapView
        
        // 1
//        let geocoder = GMSGeocoder()
        
        // 2
        
        AddressSearchModel.geocodeReverse(self.markerLocation.latitude, long: self.markerLocation.longitude) { (address, error) -> Void in
            self.deliveryAddress = address
            if let address = address {
                
                print("ADDRESS FROM SERVER'\(address.street!)")
                address.stateName = StateAddress.stateForCode(address.administrativeArea)
                self.delegate?.mapViewControllerDidGetAddress!(self, addressString: "\(address.street!), \(address.locality!), \(address.stateName!)")
            }
        }
        
        let center = CLLocationCoordinate2D(latitude: markerLocation.latitude - 0.002, longitude: markerLocation.longitude)

        let cameraPosition = GMSCameraPosition(target: center, zoom: 15.0, bearing: 0, viewingAngle: 0)
        mapView.camera = cameraPosition
        
        fetchStores()
//        setUpStoreDaysView()
        self.storeHoursView.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
//        setUpStoreDaysView()
        
//        if let navVC = self.parentViewController?.navigationController {
//            if navVC is RevealNavigationViewController  {
//                print("reveal")
//                tempBarButtonItem = self.parentViewController?.navigationItem.leftBarButtonItem
////                self.parentViewController?.navigationItem.leftBarButtonItem = nil
////                (self.parentViewController!.navigationController as! RevealNavigationViewController).setLeftMenuButton((self.parentViewController?.navigationItem)!)
//            } else {
//                print("not reveal")
//                self.parentViewController?.navigationItem.leftBarButtonItem = tempBarButtonItem
//                
//                //                tempBarButtonItem = nil
//            }
//            (self.parentViewController as! AddressSearchViewController).showMainAddressSearchControllerView()
//        }
//        
//        
        let rootViewController = self.navigationController!.viewControllers.first
        if rootViewController?.navigationItem.leftBarButtonItem != nil {
            tempBarButtonItem = rootViewController?.navigationItem.leftBarButtonItem
        }
        
        print("tempbar button: \(tempBarButtonItem?.title)")
        
        rootViewController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "cancelPressed")
        
//        tempBarButtonItem = self.parentViewController?.navigationItem.leftBarButtonItem
    }
    
    override func viewDidAppear(animated: Bool) {
        self.view.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //// MARK: - Helper Methods
    
    func fetchStores() {
        KlinkAlert.sharedInstance.showLoadingWindow()
        MapStoreModel.fetchStores(markerLocation.latitude, longitude: markerLocation.longitude) { (storeStatus, storesIDs, error) -> Void in
            if error == nil {
                print("Stores: \(storesIDs)")
                var colorToSet:UIColor?
                
                var tapGesture:UITapGestureRecognizer!
                
                switch storeStatus! {
                case MapStoreModel.StoreAvailability.Available:
                    colorToSet = self.colorAvailable
                    self.orderLabel.text = self.availableString
                    self.orderArrowImageView.hidden = false
                    self.storeHoursView.hidden = true
                    self.storesIDs = storesIDs!

                    tapGesture = UITapGestureRecognizer(target: self, action: "startOrderAvailableTapped")
                    break
                case MapStoreModel.StoreAvailability.Unavailable:
                    colorToSet = self.colorNotAvailable
                    self.orderLabel.text = self.unavailableString
                    self.orderArrowImageView.hidden = false
                    self.storeHoursView.hidden = true
                    self.storesIDs = storesIDs!

                    tapGesture = UITapGestureRecognizer(target: self, action: "startOrderNotAvailableTapped")
                    break
                case MapStoreModel.StoreAvailability.NotHereYet:
                    colorToSet = self.colorNotHereYet
                    self.orderLabel.text = self.notHereYetString
                    self.storeHoursView.hidden = true
                    tapGesture = UITapGestureRecognizer(target: self, action: "klinkNotHereTapped")
                    break
                    
                default:
                    break
                }
                
                self.orderContainerView.addGestureRecognizer(tapGesture)
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.orderContainerView.backgroundColor = colorToSet
                    self.orderLabel.hidden = false
//                    self.orderArrowImageView.hidden = false
                    self.spinner.stopAnimating()
                    self.spinner.hidden = true
                })
                
                KlinkAlert.sharedInstance.hide(.Short, message: "", color: .Neutral)
            } else {
                KlinkAlert.sharedInstance.hide(.Short, message: error, color: .Fail)
            }
        }
    }
    
    func setUpStoreDaysView() {
        let storeHoursDaysView = StoreHoursView(frame: storeHoursDaysHolderView.bounds)
        print("bound \(storeHoursDaysView.bounds)")
        storeHoursDaysHolderView.addSubview(storeHoursDaysView)
        
    }
    
    func hideStoreHoursView(animated: Bool) {
        var duration = 0.0
        if animated {
            duration = 0.2
        }
        storeHoursHolderViewBottomConstraint.constant = storeHoursHideConstraintConstant
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.storeHoursView.backgroundColor = UIColor.clearColor()
            self.viewStoreHoursLabel.text = "View Store Hours"
            self.daysHolderView.alpha = 0.0
            self.view.layoutIfNeeded()
        })
    }
    
    func showStoreHoursView(animated: Bool) {
        var duration = 0.0
        if animated {
            duration = 0.2
        }
        storeHoursHolderViewBottomConstraint.constant = storeHoursShowConstraintConstant
        UIView.animateWithDuration(duration, animations: { () -> Void in
            self.storeHoursView.backgroundColor = UIColor.kvfDark80Color()
            self.viewStoreHoursLabel.text = "Hide Store Hours"
            self.daysHolderView.alpha = 1.0
            self.view.layoutIfNeeded()
        })
        
    }
    
    // MARK: - Tap Actions
    
    func cancelPressed() {
        if let navVC = self.parentViewController?.navigationController {
            if navVC is RevealNavigationViewController  {
                print("reveal")
                self.parentViewController?.navigationItem.leftBarButtonItem = nil
                (self.parentViewController!.navigationController as! RevealNavigationViewController).setLeftMenuButton((self.parentViewController?.navigationItem)!)
            } else {
                print("not reveal")
                self.navigationItem.leftBarButtonItem = nil
                self.parentViewController?.navigationItem.leftBarButtonItem = tempBarButtonItem
//                self.navigationController?.navigationItem.leftBarButtonItem = tempBarButtonItem
                tempBarButtonItem = nil
            }
            (self.parentViewController as! AddressSearchViewController).showMainAddressSearchControllerView()
        }
    }
    
    func startOrderAvailableTapped() {
        
        if let id = SessionManager.getCurrentStoreID() {
            if id != self.storesIDs.first {
                let alertVC = UIAlertController(title: "", message: "Your cart will be cleared. Continue?", preferredStyle: .Alert)
                let yesAction = UIAlertAction(title: "Yes", style: .Default, handler: { (act) -> Void in
                    self.startBrowsingStore()
                    
                    KlinkAlert.sharedInstance.showLoadingWindow()
                    
                    Item.MR_truncateAll()
                    
                    if let _ = SessionManager.getAccessToken() {
                        APIClient.sharedClient.klinkRequest(.DELETE, URLString: "cart/", parameters: nil, authorized: true, completionHandler: { (response) -> Void in
                            let cart = Cart.getCart()
                            cart?.itemsTotal = NSDecimalNumber(double: 0.0)
                            
                            Cart.syncCart()
                            KlinkAlert.sharedInstance.hide(0.0, message: "", color: .Neutral)
                        })
                    } else {
                        KlinkAlert.sharedInstance.hide(0.0, message: "", color: .Neutral)
                    }
                })
                
                let noAction = UIAlertAction(title: "No", style: .Cancel, handler: { (act) -> Void in
                    alertVC.dismissViewControllerAnimated(true, completion: nil)
                })
                
                alertVC.addAction(yesAction)
                alertVC.addAction(noAction)
                print("present alert vc")
                self.presentViewController(alertVC, animated: true, completion: nil)
            } else {
                print("current id:\(id), new id:\(self.storesIDs.first)")
                self.startBrowsingStore()
            }
        } else {
            self.startBrowsingStore()
        }
    }
    
    func startOrderNotAvailableTapped() {
//        let navVC = RevealNavigationViewController(navigationBarClass: KlinkNavigationBar.self, toolbarClass: nil)
//        navVC.setViewControllers([DiscoverViewController()], animated: false)
//        if self.revealViewController() != nil {
//            self.revealViewController().setFrontViewController(navVC, animated: true)
//        } else {
//            print("Reveal is nil.")
//        }
//        let navVC = RevealNavigationViewController(navigationBarClass: KlinkNavigationBar.self, toolbarClass: nil)
//        navVC.setViewControllers([DiscoverViewController()], animated: false)
//        self.revealViewController().setFrontViewController(navVC, animated: true)
        startOrderAvailableTapped()
    }
    
    func startBrowsingStore() {
        // save address to recent addresses
//        deliveryAddress?.current = true
        RecentAddress.setAsCurrent(deliveryAddress!)
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreWithCompletion { (saved, error) -> Void in
            if saved {
                SessionManager.setCurrentStore(self.storesIDs.first!)
                let navVC = RevealNavigationViewController(navigationBarClass: KlinkNavigationBar.self, toolbarClass: nil)
                navVC.setViewControllers([DiscoverViewController()], animated: false)
                if self.revealViewController() != nil {
                    self.revealViewController().setFrontViewController(navVC, animated: true)
                } else {
                    print("Reveal is nil.")
                    self.dismissViewControllerAnimated(true, completion: nil)
                    NSNotificationCenter.defaultCenter().postNotificationName(KlinkRevealViewController.DELIVERY_ADDRESS_ADDED, object: nil)
                }
            }
        }
    }
    
    func klinkNotHereTapped() {
//        self.presentViewController(KlinkNotHereViewController(), animated: true, completion: nil)
    }
    
    /**
    Shows and hides (toogle) store hours view on the bottom of
    map view.
    
    - parameter sender: AnyObject
    */
    @IBAction func storeHoursHolderViewTapped(sender: AnyObject) {
        
        // Show store hours
        if storeHoursHolderViewBottomConstraint.constant == storeHoursHideConstraintConstant {
            showStoreHoursView(true)
        } else {
            hideStoreHoursView(true)
        }
        
    }
    
    

}
