//
//  CartFullViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 24/09/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit
import SwiftyJSON

class CartFullViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CartCollapsibleTableViewCellDelegate, CartTotalPricingCellDelegate, CartRoundedCellDelegate, CheckoutFinishedViewDelegate {
    
    @IBOutlet var deliveringToLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var checkoutBottomLabel: KLLabel!
    @IBOutlet var cartTitleLabel: UILabel!
    
    
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    var tapGesture:UITapGestureRecognizer!
    
    @IBOutlet var checkoutButtonView: UIView!
    @IBOutlet var checkoutButtonViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var undoButton: UIButton!
    @IBOutlet var checkoutButtonArrowImageView: UIImageView!
    
    static let cartsyncedwithserver = "cartsyncedwithserver"
    
    let CellProductIdentifier = "CellProductIdentifier"
    let CellCollapsibleIdentifier = "CellCollapsibleIdentifier"
    let CartTotalPricingCellIdentifier = "CartTotalPricingCellIdentifier"
    let CartMessageCellIdentifier = "CartMessageCellIdentifier"
    
    var cartItems:[Item] = []
    var deletedItems:[Item] = []
    
//    var canCheckout = false
    
    init() {
        super.init(nibName: "CartFullViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpTableView()
        
        let tapDismiss = UITapGestureRecognizer(target: self, action: #selector(CartFullViewController.dismissKeyboard))
        view.addGestureRecognizer(tapDismiss)
        registerForKeyboardNotification()
        
        let checkoutTap = UITapGestureRecognizer(target: self, action: #selector(CartFullViewController.didTapCheckout)
        )
        checkoutButtonView.addGestureRecognizer(checkoutTap)
        
        cartItems = Cart.getCart()?.items?.allObjects as! [Item]
        
        undoButton.enabled = false
        
        let deliveringToStyle = NSMutableParagraphStyle()
        deliveringToStyle.lineSpacing = 5
        deliveringToStyle.alignment = NSTextAlignment.Center
        
        let deliveringToAttributedText = NSMutableAttributedString(string: "Delivering to\n\(SessionManager.currentDeliveryAddress()!.street!)")
        deliveringToAttributedText.addAttribute(NSParagraphStyleAttributeName, value:deliveringToStyle, range:NSMakeRange(0, deliveringToAttributedText.length))
        
        self.deliveringToLabel.attributedText = deliveringToAttributedText
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CartFullViewController.cartSynced), name: Cart.CART_SYNCED, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CartFullViewController.successfullyPurchased), name: CheckoutReviewViewController.notif, object: nil)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        updateBottomLabel()

        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().postNotificationName(CartFullViewController.cartsyncedwithserver, object: nil)
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        unRegisterForKeyboardNotification()
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func viewDidDisappear(animated: Bool) {
//        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Helper Methods
    
    func updateBottomLabel() {
        if let cart = Cart.getCart() {
            if let canCheckout = cart.canCheckout {
                if canCheckout.boolValue {
                    checkoutBottomLabel.text = "CHECKOUT  $\(cart.total!.prettyPriceInDollars())"
                    print("checkoutBottomLabel: \(checkoutBottomLabel.text)")
                    
                } else {
                    checkoutBottomLabel.text = cart.checkoutMessage
                    print("checkoutBottomLabel: \(checkoutBottomLabel.text)")
                }
            } else {
                checkoutBottomLabel.text = "CHECKOUT  $\(cart.total!.prettyPriceInDollars())"
            }
        }
    }
    
    func successfullyPurchased() {
        print("gotovo prikazi")
        let vc = CheckoutFinishedViewController()
        vc.delegate = self
        self.navigationController?.presentViewController(vc, animated: true, completion: nil)
    }
    
    func cartSynced() {
        
        print("cartSynced")
        
        KlinkAlert.sharedInstance.hide(0.0, message: "", color: .Neutral)
        updateBottomLabel()
        let cart = Cart.getCart()
        cartItems = cart?.items?.allObjects as! [Item]
        self.tableView.reloadData()
        
        if cartItems.count > 0 {
            var totalQuantity = 0
            
            for item in cartItems {
                totalQuantity += (item.quantity?.integerValue)!
            }
            
            self.cartTitleLabel.text = "CART (\(totalQuantity))"
            print("cartTitle totalQuantity: \(totalQuantity)")
            
        } else {
            self.cartTitleLabel.text = "CART"
        }
        
        if let canCheckout = cart?.canCheckout {
            if canCheckout.boolValue {
                self.checkoutButtonView.backgroundColor = UIColor.kvfAlgaeColor()
                checkoutButtonArrowImageView.hidden = false
            } else {
                self.checkoutButtonView.backgroundColor = UIColor.kvfBrickColor()
                checkoutButtonArrowImageView.hidden = true
            }
        } else {
            
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func didTapCheckout() {
        print("tapped checkout")
        
        let cart = Cart.getCart()
        print("cart = \(cart!.total)")
        
        if let canCheckout = cart?.canCheckout {
            if canCheckout.boolValue {
                
            } else {
                print("can't checkout...")
                return
            }
        } else {
            
        }
        
        let backItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.pushViewController(CheckoutDeliveryInfoViewController(), animated: true)
    }
    
    func setUpTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 20
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clearColor()
//        tableView.delegate = self
        
        tableView.registerNib(UINib(nibName: "CartRoundedTableViewCell", bundle: nil), forCellReuseIdentifier: CellProductIdentifier)
        tableView.registerNib(UINib(nibName: "CartCollapsibleTableViewCell", bundle: nil), forCellReuseIdentifier: CellCollapsibleIdentifier)
        tableView.registerNib(UINib(nibName: "CartTotalPricingTableViewCell", bundle: nil), forCellReuseIdentifier: CartTotalPricingCellIdentifier)
        tableView.registerNib(UINib(nibName: "CartMessageTableViewCell", bundle: nil), forCellReuseIdentifier: CartMessageCellIdentifier)
//        tableView.layoutMargins = UIEdgeInsetsMake(0, 20, 0, 20)
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.separatorStyle = .None
        tableView.backgroundColor = nil
        tableView.separatorColor = UIColor.whiteColor().colorWithAlphaComponent(0.25)
        
        tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0)
        
    }
    
    // MARK: - CheckoutFinishedViewDelegate
    
    func continueBrowsingPressed() {
        modalTransitionStyle = .CrossDissolve
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + cartItems.count + 1 // pricing cell + items + message cell
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     
        
        if indexPath.row == cartItems.count {
            let cell = tableView.dequeueReusableCellWithIdentifier(CartTotalPricingCellIdentifier, forIndexPath: indexPath) as! CartTotalPricingTableViewCell
            cell.delegate = self
            cell.setupView()
            return cell

        }
        if indexPath.row == cartItems.count + 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(CartMessageCellIdentifier, forIndexPath: indexPath) as! CartMessageTableViewCell
//            if let cart = Cart.getCart() {
//                
//                if let _ = cart.canCheckout {
//                    cell.messageLabel.text = cart.checkoutMessage
//                } else {
//                    cell.messageLabel.text = ""
//                }
//            }
            
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CellProductIdentifier, forIndexPath: indexPath) as! CartRoundedTableViewCell
        cell.setupView(cartItems[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    // MARK: - Button actions

    @IBAction func dismissViewControllerPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - CartCollapsibleTableViewCellDelegate
    
    func cellDidUpdated(cell: CartCollapsibleTableViewCell) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func undoPressed(sender: AnyObject) {
        if deletedItems.count == 0 {
            return
        }
        let item = deletedItems.removeLast()
        item.cart = Cart.getCart()!
        undoButton.enabled = true
        
        // use the UITableView to animate the removal of this row
        tableView.beginUpdates()
        
        cartItems.insert(item, atIndex: 0)
        print("Add item: \(item.quantity) ")
        let indexPathForRow = NSIndexPath(forRow: 0, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPathForRow], withRowAnimation: .Left)
//        tableView.deleteRowsAtIndexPaths([indexPathForRow], withRowAnimation: .Fade)
        tableView.endUpdates()
        if deletedItems.count == 0 {
            undoButton.enabled = false
        }
    }
    
    // MARK: Keyboard Notification

    func registerForKeyboardNotification() {
            //        println("Register keyboard notifications")
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CartFullViewController.keyboardWillChange(_:)), name:UIKeyboardWillChangeFrameNotification, object: nil);
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
        
        checkoutButtonViewBottomConstraint.constant -= originDelta
        print("constant: \(checkoutButtonViewBottomConstraint.constant)")
        UIView.animateWithDuration(animationDuration) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - CartTotalPricingCellDelegate
    
    func didPressPromoCode() {
        self.presentViewController(PromoCodeViewController(), animated: true, completion: nil)
    }
    
    func didPressScheduleDelivery() {
        self.presentViewController(ScheduleDeliveryViewController(), animated: true, completion: nil)
    }
    
    func didPressSendAsAGift() {
        
    }
    
    func updateTip(tip: Double!) {
        KlinkAlert.sharedInstance.showLoadingWindow()
        
        let parameters:[String: AnyObject] = [
            "amount" : tip
        ]
        
        APIClient.sharedClient.klinkRequest(.PUT, URLString: "cart/tip/", parameters: parameters, authorized: true) { (response) -> Void in
            let result = response.result
            switch result {
            case .Success(_):
                Cart.syncCart { (success, message) -> Void in
                    if success {
                        KlinkAlert.sharedInstance.hide(0, message: "Tip successfully updated.", color: .Success)
                    } else {
                        KlinkAlert.sharedInstance.hide(.Long, message: message, color: .Fail)
                    }
                }
                break
            case .Failure(_):
                KlinkAlert.sharedInstance.hide(.Medium, message: "Error occured, please try again.", color: .Fail)
                self.tableView.reloadData()
                break
            }
        }
    }
    
    // MARK: - CartRoundedCellDelegate
    
    func itemDeleted(item: Item) {
        
        KlinkAlert.sharedInstance.showLoadingWindow()
        
        print("ITEM TO DELETE -> \(item)")
        
        APIClient.sharedClient.klinkRequest(.DELETE, URLString: "cart/item/\(item.id!)/", parameters: nil, authorized: true) { (response) -> Void in
            let result = response.result
            switch result {
            case .Success(let data):
                KlinkAlert.sharedInstance.hide(.Short, message: "Product successfully removed from cart.", color: .Success)
                
//                let index = (self.cartItems as NSArray).indexOfObject(item)
//                if index == NSNotFound { return }
//                
//                // could removeAtIndex in the loop but keep it here for when indexOfObject works
//                let item = self.cartItems.removeAtIndex(index)
//                print("Delete item: \(item.quantity) ")
//                item.cart = nil
//                self.deletedItems.append(item)
//                self.undoButton.enabled = true
//                
//                // use the UITableView to animate the removal of this row
//                self.tableView.beginUpdates()
//                let indexPathForRow = NSIndexPath(forRow: index, inSection: 0)
//                self.tableView.deleteRowsAtIndexPaths([indexPathForRow], withRowAnimation: .Fade)
//                self.tableView.endUpdates()
                
                let json = JSON(data)
                
                print("JSON -> \(json)")
                
                Item.MR_truncateAll()
                
                let cart = Cart.createCartFromJSON(json)
                Item.createItemsFromJSON(json["items"], forCart: cart)
                
                print("CART -> \(cart)")
                
                print("item deleted from cart")
                NSNotificationCenter.defaultCenter().postNotificationName(Cart.CART_SYNCED, object: nil)
                NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreWithCompletion { (saved, error) -> Void in
                }
                
                self.cartItems = cart.items?.allObjects as! [Item]
                
                if self.cartItems.count == 0 {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                
                print("CART -> \(self.cartItems)")
                
                self.tableView.reloadData()
                break
            case .Failure(_):
                KlinkAlert.sharedInstance.hide(.Medium, message: "Error occured, please try again.", color: .Fail)
                break
            }
        }
        
    }
    
    func itemQuantityUpdated(item: Item) {
        
        if item.quantity?.integerValue == 0 {
            itemDeleted(item)
            
            return
        }
        
        KlinkAlert.sharedInstance.showLoadingWindow()
        
        let parameters:[String:AnyObject] = [
            "quantity": item.quantity!
        ]
        
        APIClient.sharedClient.klinkRequest(.PATCH, URLString: "cart/item/\(item.id!)/", parameters: parameters, authorized: true) { (response) -> Void in
            let result = response.result
            
            switch result {
            case .Success(let data):
                KlinkAlert.sharedInstance.hide(.Short, message: "Product successfully updated.", color: .Success)
                
                let json = JSON(data)
                
                Item.MR_truncateAll()
                
                let cart = Cart.createCartFromJSON(json)
                Item.createItemsFromJSON(json["items"], forCart: cart)
                
                print("item updated in cart")
                NSNotificationCenter.defaultCenter().postNotificationName(Cart.CART_SYNCED, object: nil)
                NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreWithCompletion { (saved, error) -> Void in
                    
                }
                
                self.cartItems = cart.items?.allObjects as! [Item]
                
                if self.cartItems.count == 0 {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                
                self.tableView.reloadData()
                break
            case .Failure(_):
                KlinkAlert.sharedInstance.hide(.Medium, message: "Error occured, please try again.", color: .Fail)
                break
            }
        }
    }
    
    func quantityDidBeginEditing() {
        
        if (tapGesture == nil) {
            tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(ItemCardViewController.endEditing))
        }
        
        self.view.addGestureRecognizer(tapGesture)
//        
//        self.tableViewBottomConstraint.constant = 214
//        
//        UIView.animateWithDuration(0.35) {
//            self.view.layoutIfNeeded()
//        }
    }
    
    func quantityDidEndEditing() {
        
        self.view.removeGestureRecognizer(tapGesture)
//        
//        self.tableViewBottomConstraint.constant = 0
//        
//        UIView.animateWithDuration(0.35) {
//            self.view.layoutIfNeeded()
//        }
    }
    
    func endEditing() {
        self.view.endEditing(true)
    }

}
