//
//  CartDisclaimerViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 5/23/16.
//  Copyright © 2016 Ars Futura. All rights reserved.
//

import Foundation


protocol CartDisclaimerViewControllerDelegate: class {
    func didPressedNext();
}


class CartDisclaimerViewController: UIViewController, UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate {
    
    
    weak var delegate:CartDisclaimerViewControllerDelegate?
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var dontShowDisclaimerButton: UIButton!
    @IBOutlet weak var gotItButton: UIButton!
    @IBOutlet weak var editInfoButton: UIButton!

    init() {
        super.init(nibName: "CartDisclaimerViewController", bundle: nil)
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
        
        self.setupViews()
    }
    
    func setupViews() {
        
        containerView.layer.cornerRadius = 5.0
        containerView.layer.masksToBounds = true
        
        gotItButton.backgroundColor = UIColor.kvfKlinkOrangeColor()
        gotItButton.layer.cornerRadius = 5.0
        gotItButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5)
        gotItButton.titleLabel?.adjustsFontSizeToFitWidth = true

        editInfoButton.layer.cornerRadius = 5.0
        editInfoButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5)
        editInfoButton.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    // MARK: - Navigation
    
    @IBAction func gotItButtonPressed(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true) {
            self.hideDisclaimer()
            self.delegate?.didPressedNext()
        }
    }
    
    @IBAction func editInfoButtonPressed(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func dontShowDisclaimerButtonPressed(sender: AnyObject) {
        
        self.dontShowDisclaimerButton.selected = !self.dontShowDisclaimerButton.selected
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
    
    // MARK: - Hide disclaimer 
    
    private func hideDisclaimer() {
        
        if self.dontShowDisclaimerButton.selected {
            let userDefaults = NSUserDefaults.standardUserDefaults()
            userDefaults.setInteger(1, forKey: "DisclaimerHidden")
            userDefaults.synchronize()
        }
    }

    
}