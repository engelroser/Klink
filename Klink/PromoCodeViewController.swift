//
//  PromoCodeViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 02/10/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit
import SwiftyJSON

class PromoCodeViewController: UIViewController, UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var checkCodeButton: UIButton!
    @IBOutlet var codeTextField: UITextField!
    
    init() {
        super.init(nibName: "PromoCodeViewController", bundle: nil)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.commonInit()
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!)  {
        super.init(nibName: nibNameOrNil, bundle: nil)
        self.commonInit()
    }
    
    func commonInit() {
        self.modalPresentationStyle = .Custom
        self.transitioningDelegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tap = UITapGestureRecognizer(target: self, action: "dismissPressed:")
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
        contentView.layer.cornerRadius = 5.0
        contentView.layer.masksToBounds = true
        
        checkCodeButton.backgroundColor = UIColor.kvfKlinkOrangeColor()
        checkCodeButton.layer.cornerRadius = 5.0
        checkCodeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5)
        checkCodeButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Buttons Action
    
    @IBAction func checkCodePressed(sender: AnyObject) {
        KlinkAlert.sharedInstance.showLoadingWindow()
        print("code is : \(codeTextField.text!)")
        APIClient.sharedClient.klinkRequest(.PUT, URLString: "cart/coupon/", parameters: [ "code" : codeTextField.text!], authorized: true) { (response) -> Void in
            let result = response.result
            switch result {
            case .Success(_):
                APIClient.sharedClient.klinkRequest(.GET, URLString: "cart/", parameters: nil, authorized: true) { (response) -> Void in
                    let result = response.result
                    switch result {
                    case .Success(let data):
                        let json = JSON(data)
                        
                        let cart = Cart.createCartFromJSON(json)
                        Item.createItemsFromJSON(json["items"], forCart: cart)
                        
                        print("cart synced")
                        NSNotificationCenter.defaultCenter().postNotificationName(Cart.CART_SYNCED, object: nil)
                        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreWithCompletion { (saved, error) -> Void in
                        }
                        KlinkAlert.sharedInstance.hide(.Long, message: "Successfully added promo code.", color: .Success)
                        self.dismissViewControllerAnimated(true, completion: nil)
                        break
                    case .Failure(let error):
                        print("cart sync error: \(error.localizedDescription)")
                        break
                    }
                }
                break
            case .Failure(let error):
                if response.response?.statusCode == 204 {
                    APIClient.sharedClient.klinkRequest(.GET, URLString: "cart/", parameters: nil, authorized: true) { (response) -> Void in
                        let result = response.result
                        switch result {
                        case .Success(let data):
                            let json = JSON(data)
                            
                            let cart = Cart.createCartFromJSON(json)
                            Item.createItemsFromJSON(json["items"], forCart: cart)
                            
                            print("cart synced")
                            NSNotificationCenter.defaultCenter().postNotificationName(Cart.CART_SYNCED, object: nil)
                            NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreWithCompletion { (saved, error) -> Void in
                                
                            }
                            KlinkAlert.sharedInstance.hide(.Long, message: "Successfully added promo code.", color: .Success)
                            self.dismissViewControllerAnimated(true, completion: nil)
                            break
                        case .Failure(let error):
                            break
                        }
                    }
                } else if response.response?.statusCode == 400 {
                    KlinkAlert.sharedInstance.hide(.Long, message: "Code is not valid. Please try again.", color: .Fail)
                } else {
                    KlinkAlert.sharedInstance.hide(.Long, message: error.localizedDescription, color: .Fail)
                }
                break
            }
        }
    }
    

    // ---- UIViewControllerTransitioningDelegate methods
    
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
    
    @IBAction func dismissPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        let touchLocation = touch.locationInView(self.view)
        return !CGRectContainsPoint(self.contentView.frame, touchLocation)
    }

}
