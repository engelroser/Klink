//
//  AddressSearchViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 24/08/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import CoreLocation
import Alamofire

class AddressSearchViewController: BaseViewController, UISearchBarDelegate, MainAddressSearchViewControllerDelegate, MapViewControllerDelegate, UIGestureRecognizerDelegate, AddressSearchTableViewDelegate {

    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var containerView: UIView!

    @IBOutlet var containerViewBottomConstraint: NSLayoutConstraint!
//    @IBOutlet var termsUseLabel: TTTAttributedLabel!
    
    var mainSearchVC:MainAddressSearchViewController!
    var currentVC:UIViewController!
    
    let logInString:String = "Log in"
    let cancelString:String = "Cancel"
    var suggestionsRequest:Request?
//    var searchBarSpinner:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    private var searchBarTimer:NSTimer?
    
    
    init() {
        super.init(nibName: "AddressSearchViewController", bundle: nil)
//        self = self.storyboard?.instantiateViewControllerWithIdentifier("AddressSearchViewController") as AddressSearchViewController
    }

    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let tapDismissGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard"))
        tapDismissGesture.delegate = self
        self.view.addGestureRecognizer(tapDismissGesture)
        setLogoTitle()
        showMainAddressSearchControllerView()
        setUpSearchBar()
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillAppear(animated: Bool) {
        setLoginButton()
    }
    
    override func viewDidAppear(animated: Bool) {
        registerForKeyboardNotification()
        if self.revealViewController() != nil {
            if self.revealViewController().frontViewPosition == .Left {
                searchBar.becomeFirstResponder()
            }
        } else {
            searchBar.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        view.endEditing(true)
        unRegisterForKeyboardNotification()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        unRegisterForKeyboardNotification()
    }
    
    //// MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        if let v = touch.view {
            if v.isKindOfClass(TTTAttributedLabel.self)  {
                return false
            }
            if v.isKindOfClass(UITableViewCell.self) {
                return false
            }
            if let view = v.superview {
                if view.isKindOfClass(UITableViewCell.self)  {
                    return false
                }
            }
        }
        
        return true
    }
    
    // MARK: - MainSearchAddresViewControllerDelegate
    
    func mainSearchAddressViewControllerDidUpdateLocation(controller: MainAddressSearchViewController, location: CLLocationCoordinate2D) {
//        println("Got location \(location)")
        
        if self.currentVC.isKindOfClass(MapViewController) {
            return
        }
        goToMapViewController(location)
    }
    
    // MARK: - AddressSearchTableView Delegate
    func addressSearchTableView(controller: AddressSearchTableViewController, didSelectAddress address: String) {
        KlinkAlert.sharedInstance.showLoadingWindow()
        AddressSearchModel.geocode(address, completion: { (lat, long, address, error) -> Void in
            if error == nil {
                print("got place \(address)")
                
                self.goToMapViewController(CLLocationCoordinate2DMake(lat!, long!))
//                self.searchBar.text = address
                self.searchBar.resignFirstResponder()
            } else {
                KlinkAlert.sharedInstance.hide(.Medium, message: "Error occured, please try again.", color: .Fail)
            }
        })
    }
    
    // MARK: - Keyboard Notification

    func registerForKeyboardNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillFrameWillChange:"), name:UIKeyboardWillChangeFrameNotification, object: nil);
    }

    func unRegisterForKeyboardNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }

    // MARK: - Keyboard Notification
    
    func keyboardWillFrameWillChange(sender: NSNotification) {
        let userInfo = sender.userInfo!
        let animationDuration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        
        let diff = keyboardEndFrame.origin.y - keyboardFrame.origin.y
        view.setNeedsUpdateConstraints()
        if keyboardEndFrame.origin.y > keyboardFrame.origin.y {
            containerViewBottomConstraint.constant = 0
        } else {
            containerViewBottomConstraint.constant -= diff
        }
        UIView.animateWithDuration(animationDuration, delay:0, options:.BeginFromCurrentState, animations: {
            self.view.layoutIfNeeded()
            if self.currentVC.isKindOfClass(MainAddressSearchViewController.self) {
                (self.currentVC as! MainAddressSearchViewController).shrinkBackgroundElements()
            }
            }, completion: nil)
        
    }
    
    // MARK: - Helper Methods
    
    func setLoginButton() {
        if let _ = SessionManager.getAccessToken() {
            self.navigationItem.rightBarButtonItem = nil
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: logInString, style: UIBarButtonItemStyle.Done, target: self, action: "rightBarButtonTapped")
        }
    }
    
    func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    func rightBarButtonTapped() {
        if self.navigationItem.rightBarButtonItem?.title == logInString {
            let loginVC = LoginViewController()
            loginVC.navigationItem.title = "LOG IN"
            let navVC = LoginNavigationController(rootViewController: loginVC)
            self.presentViewController(navVC, animated: true, completion: nil)
        } else {
            searchBar.text = ""
            showMainAddressSearchControllerView()
            searchBar.resignFirstResponder()
        }
    }
    
    func setLogoTitle() {
        let logo = UIImage(named: "klink-header-logo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
    }
    func setUpSearchBar() {
        searchBar.setBackgroundImage(UIImage(), forBarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
        searchBar.setImage(UIImage(), forSearchBarIcon: UISearchBarIcon.Search, state: UIControlState.Normal)
        searchBar.delegate = self
        searchBar.backgroundColor = UIColor.kvfKlinkOrangeColor()
        UITextField.my_appearanceWhenContainedIn(UISearchBar.self).font = UIFont(name: "Gotham-Book", size: 14.0)
        UITextField.my_appearanceWhenContainedIn(UISearchBar.self).leftViewMode = UITextFieldViewMode.Never
    }
    // MARK: - UISearchBarDelegate
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let barButton = self.navigationItem.rightBarButtonItem
        
        if searchText.characters.count > 0 {
//            barButton?.title = cancelString
            
            if !currentVC.isKindOfClass(AddressSearchTableViewController.self) {
                setAddressSearchTableViewController()
            }
            
            if searchText.characters.count > 2 {
                // API call
                if (searchBarTimer != nil) {
                    if searchBarTimer!.valid {
                        searchBarTimer?.invalidate()
                    }
                    searchBarTimer = nil
                }
                searchBarTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "getAddressSuggestions", userInfo: nil, repeats: false)
            } else {
                suggestionsRequest?.cancel()
            }
        } else {
            barButton?.title = logInString
        }
    }
    
    func cancelSearch() {
    }
    
    func getAddressSuggestions() {
        print("get address with: \(searchBar.text)")
        suggestionsRequest?.cancel()
        suggestionsRequest = AddressSearchModel.addressSugestions(searchBar.text, completion: { (suggestions, error) -> Void in
            if error == nil {
                print("Suggestions:D \(suggestions)")
                if self.currentVC.isKindOfClass(AddressSearchTableViewController) {
                    (self.currentVC as! AddressSearchTableViewController).setSuggestions(suggestions)
                }
            }
        })
    }
    
    // MARK: - MapViewControllerDelegate
    
    func mapViewControllerDidGetAddress(controller: MapViewController, addressString: String) {
        searchBar.text = addressString
    }
    
    // MARK: - Navigation
    
    func showMainAddressSearchControllerView() {
        searchBar.text = ""
        removeCurrentContainerViewController()
        currentVC = MainAddressSearchViewController(nibName: "MainAddressSearchViewController", bundle: nil)
        
        self.addChildViewController(currentVC)
        currentVC.view.frame = containerView.bounds
        containerView.addSubview(currentVC.view)
        currentVC.didMoveToParentViewController(self)
        containerView.setNeedsUpdateConstraints()
        containerView.layoutIfNeeded()
        self.view.layoutIfNeeded()
//        currentVC.view.layoutIfNeeded()
        (currentVC as! MainAddressSearchViewController).delegate = self
        setLogoTitle()
        setLoginButton()
        
        if let navVC = self.navigationController {
            if navVC is RevealNavigationViewController  {
                print("reveal")
                (self.navigationController as! RevealNavigationViewController).setLeftMenuButton((self.parentViewController?.navigationItem)!)
            } else {
                print("not reveal")
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancelPressed")
            }
        }
    }
    
    func setAddressSearchTableViewController() {
        removeCurrentContainerViewController()
        setLogoTitle()
        
        currentVC = AddressSearchTableViewController()
        (currentVC as! AddressSearchTableViewController).delegate = self
        addChildViewController(currentVC)
        currentVC.view.frame = containerView.bounds
        containerView.addSubview(currentVC.view)
        currentVC.didMoveToParentViewController(self)
        
        if let navVC = self.navigationController {
            if navVC is RevealNavigationViewController  {
                print("reveal")
                (self.navigationController as! RevealNavigationViewController).setLeftMenuButton((self.parentViewController?.navigationItem)!)
            } else {
                print("not reveal")
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "backPressed")
            }
        }
    }
    
    func goToMapViewController(location: CLLocationCoordinate2D) {
        removeCurrentContainerViewController()
        
        
        let mapVC = MapViewController(location: location)
        mapVC.delegate = self
        addChildViewController(mapVC)
        mapVC.view.frame = containerView.bounds
        containerView.addSubview(mapVC.view)
        mapVC.didMoveToParentViewController(self)
        
        currentVC = mapVC
    
        self.navigationItem.setKlinkTitleView("IS THIS ADDRESS CORRECT?")
        self.navigationItem.rightBarButtonItem = nil
//        println("Map view frame \(mapVC.view.frame)")
    }
    
    func removeCurrentContainerViewController() {
        if currentVC != nil {
            currentVC.willMoveToParentViewController(nil)
            currentVC.view.removeFromSuperview()
            currentVC.removeFromParentViewController()
        }
    }
    
    func backPressed() {
        self.showMainAddressSearchControllerView()
        self.view.endEditing(true)
    }
    
    func cancelPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
