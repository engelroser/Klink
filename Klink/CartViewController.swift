//
//  CartViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 11/09/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit
import SwiftyJSON

class CartViewController: BaseViewController, UIViewControllerTransitioningDelegate, LoginViewDelegate {
    
    @IBOutlet var cartEffectView: UIVisualEffectView!
    @IBOutlet var cartLabel: UILabel!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var itemsToAdd = 0
    
    var cartSyncInProgress:Bool = false {
        didSet {
            if cartSyncInProgress {
                cartLabel.hidden = true
                spinner.hidden = false
                spinner.startAnimating()
            } else {
                cartChanged()
            }
        }
    }
    
    init() {
        super.init(nibName: "CartViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(CartViewController.cartTapped))
        view.addGestureRecognizer(tapRec)
        
        cartChanged()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CartViewController.cartChanged), name:Cart.CART_SYNCED, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cartTapped() {
        
        if cartSyncInProgress {
            return
        }
        
        if let _ = SessionManager.getAccessToken() {
            
            if let cart = Cart.getCart() {
                
                itemsToAdd = (cart.items?.count)!
                
                if itemsToAdd == 0 {
                    return
                }
                
                var t:[String:Int] = [:]
                var items:[[String:Int]] = []
                
                var parameters:[String : AnyObject] = [:]
                
                var localToDelete:[Item] = []
                
                KlinkAlert.sharedInstance.showLoadingWindow()
                
                print("CART ITEMS -> \(cart.items)")
                
                for i in cart.items! {
                    let item = i as! Item
                    
                    if item.local != nil {
                        
                        localToDelete.append(item)
                        
                        t["product"] = item.variantID?.integerValue
                        t["quantity"] = item.quantity?.integerValue
                        t["channel"] = SessionManager.getCurrentStoreID()
                        
                        items.append(t)
                        
                    } else if item.serverQuantity != item.quantity {
                        
                        print("ITEM QUANTITY -> \(item.quantity)")
                        
                        if item.quantity == 0 {
                            print("QUANTITY ZERO")
                            APIClient.sharedClient.klinkRequest(.DELETE, URLString: "cart/item/\(item.id!)/", parameters: nil, authorized: true) { (response) -> Void in
                                let result = response.result
                                switch result {
                                case .Success(let data):
                                    item.cart = nil
                                    item.MR_deleteEntity()
                                    
                                    self.itemsToAdd = self.itemsToAdd - 1
                                    self.goToCartFull()
                                    
                                    break
                                case .Failure(let error):
                                    if let rawError = error.localizedDescription.dataUsingEncoding(NSUTF8StringEncoding) {
                                        let errorLocalized = JSON(data: rawError)
                                        KlinkAlert.sharedInstance.hide(.Medium, message: errorLocalized["message"].stringValue, color: .Fail)
                                    }
                                    break
                                }
                            }
                        } else {
                            let parameters:[String:AnyObject] = [
                                "quantity": item.quantity!
                            ]
                            
                            APIClient.sharedClient.klinkRequest(.PATCH, URLString: "cart/item/\(item.id!)/", parameters: parameters, authorized: true) { (response) -> Void in
                                let result = response.result
                                
                                switch result {
                                case .Success(let data):
                                    self.itemsToAdd = self.itemsToAdd - 1
                                    self.goToCartFull()
                                    
                                    break
                                case .Failure(let error):
                                    if let rawError = error.localizedDescription.dataUsingEncoding(NSUTF8StringEncoding) {
                                        let errorLocalized = JSON(data: rawError)
                                        KlinkAlert.sharedInstance.hide(.Medium, message: errorLocalized["message"].stringValue, color: .Fail)
                                    }
                                    break
                                }
                            }
                        }
                    } else {
                        self.itemsToAdd = self.itemsToAdd - 1
                        goToCartFull()
                    }
                }
                
                parameters["items"] = items
                
                if items.count > 0 {
                    APIClient.sharedClient.klinkRequest2(.POST, URLString: "cart/products/", parameters: parameters, authorized: true, completionHandler: { (response) -> Void in
                        print("RESPONSE -> \(response)")
                        let result = response.result
                        switch result {
                        case .Success(let data):
                            for item in localToDelete {
                                item.cart = nil
                                item.MR_deleteEntity()
                            }
                            
                            self.itemsToAdd -= items.count
                            self.goToCartFull()
                            break
                            
                        case .Failure(let error):
                            if let rawError = error.localizedDescription.dataUsingEncoding(NSUTF8StringEncoding) {
                                let errorLocalized = JSON(data: rawError)
                                KlinkAlert.sharedInstance.hide(.Long, message: errorLocalized["message"].stringValue, color: .Fail)
                            }
                            break
                        }
                    })
                }
            }
        } else {
            let loginVC = LoginViewController()
            loginVC.navigationItem.title = "LOG IN"
            loginVC.delegate = self
            let navVC = LoginNavigationController(rootViewController: loginVC)
            self.presentViewController(navVC, animated: true, completion: nil)
            
            self.cartSyncInProgress = false
        }
    }
    
    // MARK: - CartModelDelegate
    
    func cartChanged() {
        if let cart = Cart.getCart() {
            cartLabel.text = "CHECKOUT $\((cart.itemsTotal?.prettyPriceInDollars())!)"
            print("Cart label \(cartLabel.text)")
            spinner.hidden = true
            cartLabel.hidden = false
        } else {
            cartSyncInProgress = true
            cartLabel.hidden = true
            spinner.hidden = false
            spinner.startAnimating()
        }
    }
    
    func goToCartFull() {
        if itemsToAdd > 0 {
            return
        }
        
        // Cart.getCart()?.updateCart()
        
        Cart.syncCart { (success, message) -> Void in
            if success {
                KlinkAlert.sharedInstance.hide(0, message: message, color: .Neutral)
                let navVC = UINavigationController(rootViewController: CartFullViewController())
                self.presentViewController(navVC, animated: true, completion: nil)
            } else {
                KlinkAlert.sharedInstance.hide(.Long, message: message, color: .Fail)
            }
        }
    }
    
    // MARK: - LoginViewDelegate
    
    func userDidSignedUp() {
        // Sync cart with user
        cartSyncInProgress = true
        Cart.syncCart()
    }
    
    func userDidLoggedIn() {
        // ask to keep local cart or remove everything
        cartSyncInProgress = true
        Cart.syncCart()
    }
}
