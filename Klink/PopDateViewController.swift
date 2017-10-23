//
//  PopDateViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 08/09/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit

@objc protocol PopDateViewDelegate {
    optional func popDateDismissed(controller: PopDateViewController, date: NSDate?)
}

class PopDateViewController: PopupMainViewController, UIViewControllerTransitioningDelegate {
    
    @IBOutlet var container: UIView!
    
    @IBOutlet var datePicker: UIDatePicker!
    var delegate:PopDateViewDelegate?
//    var customPicker:PIDatePicker?
    
    
    init() {
        super.init(nibName: "PopDateViewController", bundle: nil)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        self.modalPresentationStyle = .Custom
        self.transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        container.layer.cornerRadius = 5.0
        container.layer.masksToBounds = true
        
        print("PopDate Date: \(datePicker.date)")
        
        datePicker.maximumDate = NSDate()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Button Actions
    
    @IBAction func cancelPressed(sender: AnyObject) {
        delegate?.popDateDismissed!(self, date: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func okPressed(sender: AnyObject) {
        delegate?.popDateDismissed!(self, date: datePicker.date)
        self.dismissViewControllerAnimated(true, completion: nil)
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

}
