//
//  PackContentViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 27/10/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit
import PureLayout
import SwiftyJSON
//import MagicalRecord

class PackContentViewController: UIViewController, UIViewControllerTransitioningDelegate, UITableViewDataSource, PackContentHeaderDelegate, UITableViewDelegate, ItemCardTableViewCellDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var contentView: UIView!
    @IBOutlet var contentTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var contentLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet var contentViewBottomConstraint: NSLayoutConstraint!
    
    var tapGesture:UITapGestureRecognizer!
    let PackHeaderCellIdentifier = "PackHeaderCellIdentifier"
    let ItemCardCellIdentifier = "ItemCardCellIdentifier"
    var footerButton:KlinkOrangeButton!
    var footerView:UIView!
    var pack:PackModel!
    
    var price:Double = 0.0
    var items:Int = 0
    
    weak var delegate: PackItemsViewController?
    
    init(pack:PackModel!) {
        super.init(nibName: "PackContentViewController", bundle: nil)
        self.pack = pack
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        self.modalPresentationStyle = .Custom
        self.transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(PackContentViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        for item in pack.packItems {
            items += item.tempQuantity
            price += (Double(item.tempQuantity) * item.product.variants[0].price)
            print("PRICE \(price)")
        }
        
        contentLeadingConstraint.constant = 0
        contentTrailingConstraint.constant = 0
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let screen = UIScreen.mainScreen().bounds
        if contentView.frame.size.width >= screen.width {
            contentView.frame = CGRectMake(20, 20, screen.width - 40, screen.height - 40)
            print("fix width")
        }
        
        setupTableView()
        registerForKeyboardNotification()
        self.view.layoutIfNeeded()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        contentView.layoutIfNeeded()
        self.view.layoutIfNeeded()
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
    
    func setupTableView() {
        tableView.registerNib(UINib(nibName: "PackContentheaderTableViewCell", bundle: nil), forCellReuseIdentifier: PackHeaderCellIdentifier)
        tableView.registerNib(UINib(nibName: "ItemCardTableViewCell", bundle: nil), forCellReuseIdentifier: ItemCardCellIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 220.0
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        tableView.contentInset = UIEdgeInsetsMake(40, 0, 20, 0)
        
        tableView.backgroundColor = UIColor.clearColor()
        
        let screenWidth = UIScreen.mainScreen().bounds.width - 40
        
        footerView = UIView(frame: CGRectMake(0,0, screenWidth, 75))
        let maskPath = UIBezierPath(roundedRect: footerView.bounds, byRoundingCorners: [UIRectCorner.BottomRight, UIRectCorner.BottomLeft], cornerRadii: CGSizeMake(5.0, 5.0))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = footerView.bounds
        maskLayer.path = maskPath.CGPath
        footerView.layer.mask = maskLayer
        footerView.backgroundColor = UIColor.whiteColor()
        footerButton = KlinkOrangeButton(type: .Custom)
        footerView.addSubview(footerButton)
        footerButton.autoCenterInSuperview()
        
        let priceString:String = String(format: "%.2f", price/100.0)
        footerButton.setTitle("Add \(items) items to cart - $\(priceString)", forState: .Normal)
        footerButton.addTarget(self, action: #selector(PackContentViewController.addToCartPressed), forControlEvents: .TouchUpInside)
        
        tableView.tableFooterView = footerView
    }
    
    
    // MARK: Keyboard Notification
    
    func registerForKeyboardNotification() {
        //        println("Register keyboard notifications")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PackContentViewController.keyboardWillChange(_:)), name:UIKeyboardWillChangeFrameNotification, object: nil);
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
        
        contentViewBottomConstraint.constant -= originDelta
        UIView.animateWithDuration(animationDuration) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pack.packItems.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(PackHeaderCellIdentifier, forIndexPath: indexPath) as! PackContentheaderTableViewCell
            cell.setupView(pack)
            cell.delegate = self
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(ItemCardCellIdentifier, forIndexPath: indexPath) as! ItemCardTableViewCell
        cell.setupView(pack.packItems[indexPath.row - 1])
        
        cell.delegate = self
        
        return cell
    }
    
    // MARK: - UIViewControllerTransitioningDelegate methods
    
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        if presented == self {
            return SlideFromBottomPresentationController(presentedViewController: presented, presentingViewController: presenting)
        }
        
        return nil
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if presented == self {
            return SlideFromBottomAnimationController(isPresenting: true)
        }
        else {
            return nil
        }
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if dismissed == self {
            return SlideFromBottomAnimationController(isPresenting: false)
        }
        else {
            return nil
        }
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y < -140 {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -140 {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // MARK: - PackContentHeaderDelegate
    
    func didPressClose() {
        self.dismissViewControllerAnimated(true, completion: nil)
        delegate!.updateControllerAfterDismissing()
    }
    
    // MARK: - ItemCardTableViewCellDelegate
    
    func quantityChanged() {
        price = 0.0
        items = 0
        for item in pack.packItems {
            items += item.tempQuantity
            price += (Double(item.tempQuantity) * item.product.variants[0].price)
            print("PRICE \(price)")
        }
        let priceString:String = String(format: "%.2f", price/100.0)
        footerButton.setTitle("Add \(items) items to cart - $\(priceString)", forState: .Normal)
    }
    
    func quantityDidBeginEditing() {
        
        if (tapGesture == nil) {
            tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(ItemCardViewController.endEditing))
        }
        
        self.view.addGestureRecognizer(tapGesture)
        
        let diff = self.view.frame.size.height - 214
        
        if self.tableView.contentSize.height > diff {
            self.contentViewBottomConstraint.constant = self.tableView.contentSize.height - diff
            
            UIView.animateWithDuration(0.35) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func quantityDidEndEditing() {
        
        self.view.removeGestureRecognizer(tapGesture)
        
        self.contentViewBottomConstraint.constant = 0
        
        UIView.animateWithDuration(0.35) {
            self.view.layoutIfNeeded()
        }
    }
    
    func endEditing() {
        self.view.endEditing(true)
    }
    
    // MARK: - Button Actions
    
    func addToCartPressed() {
        guard SessionManager.getAccessToken() != nil else {
            
            let loginVC = LoginViewController()
            loginVC.navigationItem.title = "LOG IN"
            //            loginVC.delegate = self
            let navVC = LoginNavigationController(rootViewController: loginVC)
            self.presentViewController(navVC, animated: true, completion: { () -> Void in
                self.contentLeadingConstraint.constant = 20
                self.contentTrailingConstraint.constant = 20
                self.view.layoutIfNeeded()
            })
            return
        }
        
        for item in pack.packItems {
            item.product.variants[0].itemsInCart += item.tempQuantity
            Cart.getCart()?.addItem(item.product.variants[0], quantity: item.tempQuantity)
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
        self.delegate!.updateControllerAfterDismissing()
    }

}
