//
//  ItemCardViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 14/09/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit

class ItemCardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ItemCardHeaderViewDelegate, ItemCardHeaderCellDelegate, ItemCardTableViewCellDelegate {
    
//    var cartVC:CartViewController()?
    @IBOutlet var tableView: UITableView!
    var screenWidth:CGFloat = 0.0
    var previousOffset:CGFloat = 0.0
    var startingWidth:CGFloat = 0.0
    
    var tapGesture:UITapGestureRecognizer!
    
    @IBOutlet var cartContainer: UIView!
    
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    
    let cartVC = CartViewController()
    
    let ItemCardCellIdentifier = "ItemCardCellIdentifier"
    let ItemCardFirstCellIdentifier = "ItemCardFirstCellIdentifier"
    let ItemCardHeaderCellIdentifier = "ItemCardHeaderCellIdentifier"

    var product:ProductModel!
    
    @IBOutlet var tableViewWidthConstraint: NSLayoutConstraint!
    
    init(product: ProductModel!) {
        super.init(nibName: "ItemCardViewController", bundle: nil)
        self.product = product
//        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func commonInit() {
//        self.modalPresentationStyle = .Custom
//        self.transitioningDelegate = self
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        screenWidth = screenSize.width
        
//        println("card loaded")
        
        cartVC.view.frame = cartContainer.bounds
        cartContainer.addSubview(cartVC.view)
        cartVC.view.backgroundColor = UIColor.clearColor()
        self.addChildViewController(cartVC)
        cartVC.didMoveToParentViewController(self)
        setUpTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
//        startingWidth = view.frame.size.width
//        tableViewWidthConstraint.constant = view.frame.size.width
        
    }
    
    override func viewDidAppear(animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper Methods
    
    func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerNib(UINib(nibName: "ItemCardHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: ItemCardHeaderCellIdentifier)
        tableView.registerNib(UINib(nibName: "ItemCardTableViewCell", bundle: nil), forCellReuseIdentifier: ItemCardCellIdentifier)
        tableView.registerNib(UINib(nibName: "ItemCardFirstTableViewCell", bundle: nil), forCellReuseIdentifier: ItemCardFirstCellIdentifier)
//        tableView.registerNib(UINib(nibName: "ItemCardTableViewCell", bundle: nil), forCellReuseIdentifier: ItemCardCellIdentifier)
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 48, 0)
        tableView.contentOffset = CGPointMake(0, -60)
        previousOffset = -30
        tableView.backgroundColor = UIColor.clearColor()
        
        tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15)
        tableView.separatorStyle = .None
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + 1 + product.variants.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell: ItemCardHeaderTableViewCell = tableView.dequeueReusableCellWithIdentifier(ItemCardHeaderCellIdentifier, forIndexPath: indexPath) as! ItemCardHeaderTableViewCell
            cell.delegate = self
            cell.setupView(product)
            return cell
        }
        
        if indexPath.row == 1 {
            let cell: ItemCardFirstTableViewCell = tableView.dequeueReusableCellWithIdentifier(ItemCardFirstCellIdentifier, forIndexPath: indexPath) as! ItemCardFirstTableViewCell
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(ItemCardCellIdentifier, forIndexPath: indexPath) as! ItemCardTableViewCell
        
        let variant = product.variants[indexPath.row - 2]
        
        cell.setupVariant(variant)
        cell.delegate = self
        
        
        return cell
    }
    
    // MARK: -ItemCardTableViewCellDelegate
    
    func quantityChanged() {
        
    }
    
    func quantityDidBeginEditing() {
        
        if (tapGesture == nil) {
            tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(ItemCardViewController.endEditing))
        }
        
        self.view.addGestureRecognizer(tapGesture)
        
        self.tableViewBottomConstraint.constant = 214
        
        UIView.animateWithDuration(0.35) { 
            self.view.layoutIfNeeded()
        }
    }
    
    func quantityDidEndEditing() {
        
        self.view.removeGestureRecognizer(tapGesture)
        
        self.tableViewBottomConstraint.constant = 0
        
        UIView.animateWithDuration(0.35) {
            self.view.layoutIfNeeded()
        }
    }
    
    func endEditing() {
        self.view.endEditing(true)
    }
    
    // MARK: - UITableViewDelegate
    
//    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        cell.preservesSuperviewLayoutMargins = false
//        cell.layoutMargins = UIEdgeInsetsMake(0, 15, 0, 15)
//        
//    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
////        println("card scrolled: \(scrollView.contentOffset.y), view: \(screenWidth)")
//        let offset = scrollView.contentOffset.y
//        let leaveScrollAlone:Bool = scrollView.contentOffset.y <= -30
//        if (leaveScrollAlone)
//        {
//            // This allows for bounce when swiping your finger downwards and reaching the stopping point
//            previousOffset = offset
//            return;
//        }
////        
//        if  offset >= 100 {
//            previousOffset = offset
//            return
//        }
//        
//        
//        var frame = view.frame
//        
//        let diff = (offset - previousOffset) * 1.35
////        let diff = (30 + offset) * 1.5
////        println("offset: \(offset), previous: \(previousOffset), diff: \(diff)")
////        println("ratio: \((screenWidth - startingWidth)/2)")
//        
//        
//        tableViewWidthConstraint.constant += diff
//        
//        if tableViewWidthConstraint.constant < startingWidth {
//            tableViewWidthConstraint.constant = startingWidth
//        }
//        if tableViewWidthConstraint.constant > screenWidth {
//            tableViewWidthConstraint.constant = screenWidth
//        }
//        view.layoutIfNeeded()
//        previousOffset = offset
////        println("new frame: \(tableViewWidthConstraint.constant)")
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        stoppedScrolling()
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (!decelerate) {
            stoppedScrolling()
        }
    }
    
    func stoppedScrolling() {
//        println("popravi")
//        if tableView.contentOffset.y <= 0 {
//            tableView.userInteractionEnabled = false
////            tableView.scrollEnabled = false
//            let grow = tableView.contentOffset.y > -15
//            var offset:CGFloat = 0.0
//            if grow {
//                offset = 0
////                tableViewWidthConstraint.constant = screenWidth
//            } else {
//                offset = -30
////                tableView.setContentOffset(CGPointMake(0, -30), animated: true)
////                tableViewWidthConstraint.constant = startingWidth
//            }
//
//            UIView.animateWithDuration(0.7, animations: { () -> Void in
//                self.tableView.setContentOffset(CGPointMake(0, offset), animated: true)
//                self.view.layoutIfNeeded()
//                
//                }, completion: { (finished) -> Void in
//                    self.tableView.userInteractionEnabled = true
//                    self.tableView.scrollEnabled = true
//            })
//        }
        
    }
    
    
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
//        tableView.userInteractionEnabled = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - ItemCardHeaderViewDelegate
    
    func itemCardHeaderClosePressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func headerCellCloseButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - // ---- UIViewControllerTransitioningDelegate methods
    
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

}
