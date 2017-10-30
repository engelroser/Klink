//
//  SavedCardsViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 05/10/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit
import PureLayout

protocol SavedCardsViewDelegate {
    func didSelectCard(card: CreditCard?)
}

class SavedCardsViewController: UIViewController, UITableViewDataSource, UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate, UITableViewDelegate {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var tableView: UITableView!
    var selectedIndex = -1
    
    let SavedCardCellIdentifier = "SavedCardCellIdentifier"
    
    var cards:[CreditCard] = []
    
    var selectedCard:CreditCard?
    
    var delegate:SavedCardsViewDelegate?
    
    init() {
        super.init(nibName: "SavedCardsViewController", bundle: nil)
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
        
        setupTableView()
        
        cards = SessionManager.currentUser()?.creditCards?.allObjects as! [CreditCard]
        
        contentView.layer.cornerRadius = 5.0
        contentView.layer.masksToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    // MARK: - Helper Methods
    
    func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 40
        tableView.registerNib(UINib(nibName: "SavedCardTableViewCell", bundle: nil), forCellReuseIdentifier: SavedCardCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.separatorColor = UIColor.blackColor().colorWithAlphaComponent(0.1)
        tableView.layoutMargins = UIEdgeInsetsZero
        
        let footerView = UIView(frame: CGRectMake(0,0, tableView.frame.size.width, 75))
        let maskPath = UIBezierPath(roundedRect: footerView.bounds, byRoundingCorners: [UIRectCorner.BottomRight, UIRectCorner.BottomLeft], cornerRadii: CGSizeMake(5.0, 5.0))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = footerView.bounds
        maskLayer.path = maskPath.CGPath
        footerView.layer.mask = maskLayer
        footerView.backgroundColor = UIColor.whiteColor()
        let footerButton = KlinkOrangeButton(type: .Custom)
        footerView.addSubview(footerButton)
        footerButton.autoCenterInSuperview()
        
        footerButton.addTarget(self, action: "useCardPressed", forControlEvents: .TouchUpInside)
        footerButton.setTitle("Use Card", forState: .Normal)
        
        tableView.tableFooterView = footerView
        
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(SavedCardCellIdentifier, forIndexPath: indexPath) as! SavedCardTableViewCell
        cell.setupView(cards[indexPath.row])
        if selectedIndex == indexPath.row {
            cell.setSelected(true, animated: false)
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedIndex = indexPath.row
        selectedCard = cards[indexPath.row]
//        tableView.reloadData()
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
    
    func useCardPressed() {
        print("user card pressed")
        delegate?.didSelectCard(selectedCard)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
