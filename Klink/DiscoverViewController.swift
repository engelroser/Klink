//
//  DiscoverViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 07/09/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import SwiftyJSON
import Alamofire

class DiscoverViewController: UIViewController, UITableViewDelegate, UICollectionViewDelegate, TTTAttributedLabelDelegate, DiscoverBrowseScrollViewDelegate {
    
    @IBOutlet var heroSpinner: UIActivityIndicatorView!
    @IBOutlet var categoryScrollHolder: UIView!
    @IBOutlet var visualEffectView: UIVisualEffectView!
    @IBOutlet var orangeIndicatorView: UIView!
    @IBOutlet var orangeIndicatorLeftConstraint: NSLayoutConstraint!
    @IBOutlet var visualEffectHeightConstraint: NSLayoutConstraint!
    @IBOutlet var deliveringAddressLabel: TTTAttributedLabel!
    
    @IBOutlet var backgroundHeaderImageView: UIImageView!
    @IBOutlet var discoverHorizontalScrollView: DiscoverBrowseScrollView!
    @IBOutlet var topImageView: UIImageView!
    @IBOutlet var topEffectVisualView: UIVisualEffectView!
    @IBOutlet var headerImageOverlay: UIView!
    @IBOutlet var headerView: DiscoverHeaderView!
    @IBOutlet var contentView: UIView!
    @IBOutlet var headerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var categoryScrollHolderHeightConstraint: NSLayoutConstraint!
    @IBOutlet var deliverAddressHeightConstraint: NSLayoutConstraint!
    var lastContentOffset:CGFloat = 0
    
    var maxHeaderHeight:CGFloat = 320.0
    var minHeaderHeight:CGFloat = 108.0
    
    var browseHeaderMaxHeight:CGFloat = 320.0
    var discoverHeaderMaxHeight:CGFloat = 240.0
    let discoverHeaderRatioHeight:CGFloat = 240.0 // Ivan
    let browseHeaderRatioHeight:CGFloat = 240.0 // Ivan
    let browseHeaderMinHeight:CGFloat = 188.0
    let discoverHeaderMinHeight:CGFloat = 108.0
    
    var discoverHomeVC:DiscoverHomeViewController?
    var discoverBrowseVC:DiscoverBrowseViewController?
    var currentVC:UIViewController?
    
    var categories:[CategoryModel] = []
    
    @IBOutlet var cartContainer: UIView!

    var billboardTap: UITapGestureRecognizer!

    let cartVC = CartViewController()
    
    struct BillboardData {
        let id: Int
        let type: String
    }

    var billboardData: BillboardData?
    
    init() {
        super.init(nibName: "DiscoverViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.translucent = true
        
        discoverBrowseVC = DiscoverBrowseViewController()
        discoverHomeVC = DiscoverHomeViewController()
        
        let searchIcon = UIBarButtonItem(image: UIImage(named: "navigation-search-icon"), style: UIBarButtonItemStyle.Plain, target: self, action: "searchTapped")
        
        self.navigationItem.rightBarButtonItem = searchIcon
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.discoverHeaderMaxHeight = (UIScreen.mainScreen().bounds.size.width * 0.5) + 54.0 + 25.0
        self.browseHeaderMaxHeight = (UIScreen.mainScreen().bounds.size.width * 0.5) + 54.0 + 25.0 + 80.0
        
        maxHeaderHeight = discoverHeaderMaxHeight
        headerView.maxHeight = maxHeaderHeight
        
        displayContentController(discoverHomeVC!)
        
        if let id = SessionManager.getCurrentStoreID() {
            CategoryModel.allCategories(id, completion: { (categories, error) -> Void in
                self.categories = categories
                self.discoverHorizontalScrollView.addCategories(categories, selectedIndex: 0)
            })
        }
        discoverHorizontalScrollView.discoverBrowseScrollDelegate = self
        discoverHorizontalScrollView.panGestureRecognizer.delaysTouchesBegan = discoverHorizontalScrollView.delaysContentTouches
        discoverHorizontalScrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.heroSpinner.startAnimating()
        
        let parameters:[String:AnyObject] = [
            "stores[]": SessionManager.getCurrentStoreID()!
        ]
        
        APIClient.sharedClient.klinkRequest(.GET, URLString: "home/", parameters: parameters) { (response) -> Void in
            let result = response.result
            
            switch result {
            case .Success(let data):
                let json = JSON(data)

                if let id = json["id"].int, type = json["type"].string {
                    self.billboardData = BillboardData(id: id, type: type)
                }

                self.heroSpinner.stopAnimating()
                self.heroSpinner.hidden = true
                
                self.backgroundHeaderImageView.kf_setImageWithURL(NSURL(string: json["image"].stringValue)!, placeholderImage: nil)
//                self.backgroundHeaderImageView.load(json["image"].stringValue, placeholder: nil, completionHandler: { (ulr, image, error, cache) -> Void in
//                    self.backgroundHeaderImageView.image = image
//                })
                self.topImageView.kf_setImageWithURL(NSURL(string: json["image"].stringValue)!, placeholderImage: nil)
//                self.topImageView.load(json["image"].stringValue, placeholder: nil, completionHandler: { (ulr, image, error, cache) -> Void in
//                    self.topImageView.image = image
//                })

                break
            case .Failure(let error):
                print("home banner error: \(error.localizedDescription)")
                break
            }
        }

        billboardTap = UITapGestureRecognizer(target: self, action: "didTapOnBillboard:")
        
        topImageView.addGestureRecognizer(billboardTap)
        topImageView.userInteractionEnabled = true

    }
    
    func didTapOnBillboard(sender: UITapGestureRecognizer) {
        guard let billboardData = billboardData else {
            return
        }

        switch billboardData.type {
            case "collection":
                break
            case "package":
                KlinkAlert.sharedInstance.showLoadingWindow()
                
                PackModel.getPackage(billboardData.id, completion: { (pack, error) -> Void in
                    let vc = PackItemsViewController(pack: pack!)
                    
                    KlinkAlert.sharedInstance.hide(0, message: "", color: .Neutral)
                    
                    let backItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
                    self.navigationItem.backBarButtonItem = backItem
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                })
                
                break
            default:
                return
        }
    }

    override func viewWillAppear(animated: Bool) {
        
        setDeliveringAddressLabel()
        
        cartVC.view.frame = cartContainer.bounds
        cartContainer.addSubview(cartVC.view)
        cartVC.view.backgroundColor = UIColor.clearColor()
        self.addChildViewController(cartVC)
        cartVC.didMoveToParentViewController(self)
        self.view.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - DiscoverBrowseScrollViewDelegate
    
    func discoverBrowseScrollButtonPressed(scrollView: UIScrollView, atIndex index: Int) {
        let backItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        self.navigationController?.pushViewController(BrowseViewController(categories: categories, index: index), animated: true)
        
    }
    
    // MARK: - Button Actions
    
    @IBAction func discoverButtonPressed(sender: AnyObject) {
        stopScroll()
        maxHeaderHeight = self.discoverHeaderMaxHeight
        minHeaderHeight = discoverHeaderMinHeight
        orangeIndicatorLeftConstraint.constant = 0
        categoryScrollHolderHeightConstraint.constant = 0
        headerHeightConstraint.constant = maxHeaderHeight
        deliverAddressHeightConstraint.constant = 25
        headerView.maxHeight = maxHeaderHeight
        self.displayContentController(self.discoverHomeVC!)
        self.hideContentController(self.discoverBrowseVC!)
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.categoryScrollHolder.alpha = 0
            self.view.layoutIfNeeded()
            self.setHeaderAlpha(1)
        })
    }
    
    @IBAction func browseButtonPressed(sender: AnyObject) {
        stopScroll()
        maxHeaderHeight = self.browseHeaderMaxHeight
        minHeaderHeight = browseHeaderMinHeight
        headerHeightConstraint.constant = maxHeaderHeight
        categoryScrollHolderHeightConstraint.constant = 80
        orangeIndicatorLeftConstraint.constant = view.frame.size.width / 2
        headerView.maxHeight = maxHeaderHeight
        deliverAddressHeightConstraint.constant = 25
        
        self.displayContentController(self.discoverBrowseVC!)
        self.hideContentController(self.discoverHomeVC!)
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.categoryScrollHolder.alpha = 1
            self.view.layoutIfNeeded()
            self.setHeaderAlpha(1)
            })
        
        if self.categories.count > 0 {
            let backItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
            navigationItem.backBarButtonItem = backItem
            
            self.navigationController?.pushViewController(BrowseViewController(categories: categories, index: 0), animated: true)
        }
        
    }
    
    func searchTapped() {
        self.navigationController?.presentViewController(SearchViewController(), animated: true, completion:nil)
    }
    
    // MARK: - Helper Methods
    
    func closeChangeAddress() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func stopScroll() {
        if currentVC == discoverHomeVC {
            discoverHomeVC?.tableView.delegate = nil
        } else {
            discoverBrowseVC?.tableView.delegate = nil
        }
    }
    
    func setDeliveringAddressLabel() {
        let linkAttributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSUnderlineStyleAttributeName: NSNumber(bool:true),
        ]
        let activeLinkAttributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor().colorWithAlphaComponent(0.80),
            NSUnderlineStyleAttributeName: NSNumber(bool:true),
        ]
        
        let change = "Change"
        
        var address = "Delivering to your current location. "
        if let a = SessionManager.currentDeliveryAddress() {
            address = "Delivering to \(a.street!). "
        }
        
        let string = "\(address)\(change)"
        deliveringAddressLabel.text = string
        
        deliveringAddressLabel.activeLinkAttributes = activeLinkAttributes
        deliveringAddressLabel.linkAttributes = linkAttributes
        let nsString = string as NSString
        let range = nsString.rangeOfString(change)
        let url = NSURL(string: "action://change-address")!
        deliveringAddressLabel.addLinkToURL(url, withRange: range)
        
        deliveringAddressLabel.delegate = self
    }
    
    func setHeaderAlpha(alpha: CGFloat) {
        topImageView.alpha = alpha
    }
    
    func displayContentController(content: UIViewController) {
        addChildViewController(content)
//        let screenSize: CGRect = UIScreen.mainScreen().bounds
//        let screenWidth = screenSize.width
//        let screenHeight = screenSize.height
        content.view.frame = contentView.bounds
        
        self.contentView.addSubview(content.view)
        content.didMoveToParentViewController(self)
        
        if content.isKindOfClass(DiscoverHomeViewController.self) {
//            println("Header height \(maxHeaderHeight)")
            (content as! DiscoverHomeViewController).tableView.contentOffset = CGPointMake(0, -(maxHeaderHeight))
            (content as! DiscoverHomeViewController).tableView.contentInset = UIEdgeInsetsMake(maxHeaderHeight, 0, cartContainer.frame.size.height, 0)
            (content as! DiscoverHomeViewController).tableView.delegate = self
        } else if content.isKindOfClass(DiscoverBrowseViewController.self) {
//            println("Header height \(maxHeaderHeight)")
            (content as! DiscoverBrowseViewController).tableView.contentOffset = CGPointMake(0, -(maxHeaderHeight))
            (content as! DiscoverBrowseViewController).tableView.contentInset = UIEdgeInsetsMake(maxHeaderHeight, 0, cartContainer.frame.size.height, 0)
            (content as! DiscoverBrowseViewController).tableView.delegate = self
        }
        currentVC = content
        
    }
    
    func hideContentController(content: UIViewController) {
        content.willMoveToParentViewController(nil)
        content.view.removeFromSuperview()
        content.removeFromParentViewController()
    }
    
    // MARK: - TTTAttributedLabelDelegate
    
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        
        if url.scheme.hasPrefix("action") {
            let addressVC = AddressSearchViewController()
            addressVC.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Plain, target: self, action: "closeChangeAddress")
            self.navigationController?.presentViewController(UINavigationController(rootViewController: addressVC), animated: true, completion: nil)
        }
    }
    
    // MARK: - UIScrollView Delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if -(scrollView.contentOffset.y) < minHeaderHeight {
            headerHeightConstraint.constant = minHeaderHeight
            backgroundHeaderImageView.alpha = 0
        } else if (-(scrollView.contentOffset.y) > maxHeaderHeight) {
            backgroundHeaderImageView.alpha = 1
            headerHeightConstraint.constant = maxHeaderHeight
        } else {
            backgroundHeaderImageView.alpha = 1
            headerHeightConstraint.constant = -(scrollView.contentOffset.y)
        }
        
        let heightForAlpha = (headerHeightConstraint.constant > maxHeaderHeight) ? maxHeaderHeight : headerHeightConstraint.constant
        
        let diff = heightForAlpha - minHeaderHeight
        let maxDiff = maxHeaderHeight - minHeaderHeight
        let alpha = (maxDiff - diff)/maxDiff
        
        
        view.layoutIfNeeded()
        deliverAddressHeightConstraint.constant = ( 1 - alpha ) * 25
        
        topImageView.alpha = 1 - alpha
        
        
    }
    
    // MARK: - Collection view delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.navigationController?.presentViewController(ItemCardsViewController(), animated: true, completion: nil)
    }
    
    // MARK: - Table view delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
//        
//        
//        if indexPath.row % 2 == 0 {
//            let backItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
//            navigationItem.backBarButtonItem = backItem
//            self.navigationController?.pushViewController(PacksViewController(), animated: true)
//
//        } else {
//            let backItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
//            navigationItem.backBarButtonItem = backItem
//            self.navigationController?.pushViewController(FeaturedViewController(), animated: true)
//
//        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
