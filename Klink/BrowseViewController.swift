//
//  BrowseViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 17/09/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit
import PureLayout

class BrowseViewController: UIViewController, UICollectionViewDelegate, DiscoverBrowseScrollViewDelegate, ProductFilterViewDelegate {
    
    var currentVC: ProductsViewController!
    var previousOffset:CGFloat = 0
    var pageController:UIPageViewController!
    var currentIndex:Int!
    

    @IBOutlet var contentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var contentView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet var horizontalScrollView: DiscoverBrowseScrollView!
    @IBOutlet var cartContainer: UIView!
    @IBOutlet var filtersView: UIView!
    
    var cartVC:CartViewController!
    
    var categories:[CategoryModel] = []
    
    var productsControllers:[Int:ProductsViewController] = [:]
    
    init(categories:[CategoryModel], index:Int) {
        super.init(nibName: "BrowseViewController", bundle: nil)
        self.categories = categories
        self.currentIndex = index
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let klinkNavBar = self.navigationController?.navigationBar as! KlinkNavigationBar
        klinkNavBar.viewsToIgnoreTouchesFor.append(horizontalScrollView)
        
        var previousView:UIView?
        
        scrollView.delegate = self
        scrollView.addSubview(contentView)
        contentView.autoMatchDimension(.Height, toDimension: .Height, ofView: scrollView)
        
        for (index, c) in categories.enumerate() {
            print("KATEG -> \(c)")
            let controller = ProductsViewController(category: c)
            addChildViewController(controller)
            let v = controller.view
            v.backgroundColor = UIColor.collectionBackground()
            scrollView.addSubview(v)
            
            v.autoMatchDimension(.Width, toDimension: .Width, ofView: scrollView)
            v.autoMatchDimension(.Height, toDimension: .Height, ofView: scrollView)
            v.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: contentView)
            v.autoPinEdge(.Top, toEdge: .Top, ofView: contentView)
            
            if let temp = previousView {
                v.autoPinEdge(.Left, toEdge: .Right, ofView: temp)
                temp.backgroundColor = UIColor.clearColor()
                
            } else {
                v.autoPinEdge(.Leading, toEdge: .Leading, ofView: contentView)
            }
//            containerView.addSubview(controller.view)
            controller.didMoveToParentViewController(self)
            controller.collectionView.setContentOffset(CGPointMake(0, -150), animated: false)
            controller.collectionView.contentInset = UIEdgeInsetsMake(150, 0, 48, 0)
            
            previousView = v
            
            productsControllers[index] = controller
        }
        
//        addController(ProductsViewController())
        
        let searchBarItem = UIBarButtonItem(image: UIImage(named: "navigation-search-icon"), style: UIBarButtonItemStyle.Plain, target: self, action: "searchTapped")
        navigationItem.rightBarButtonItem = searchBarItem
        
        horizontalScrollView.addCategories(categories, selectedIndex: 0)
        horizontalScrollView.showIndicator(true)
        horizontalScrollView.discoverBrowseScrollDelegate = self
        horizontalScrollView.decelerationRate = UIScrollViewDecelerationRateFast
        self.automaticallyAdjustsScrollViewInsets = false
        
        let tap = UITapGestureRecognizer(target: self, action: "filtersTapped")
        filtersView.addGestureRecognizer(tap)
        
        setCartContainer()
        scrollView.pagingEnabled = true
        
//        let filterTap = UITapGestureRecognizer(target: self, action: "filtersTapped")
//        filterView.addGestureRecognizer(filterTap)
    }
    
    override func viewWillAppear(animated: Bool) {
        print("current index: \(currentIndex)")
        print(CGPointMake(CGFloat(currentIndex) * view.frame.size.width, 0))
        horizontalScrollView.setSelectedCategory(currentIndex)
        
//        self.scrollView.setContentOffset(CGPointMake(CGFloat(currentIndex) * view.frame.size.width, 0), animated: false)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.scrollView.setContentOffset(CGPointMake(CGFloat(currentIndex) * view.frame.size.width, 0), animated: false)
        contentViewWidthConstraint.constant = scrollView.frame.size.width * CGFloat(categories.count)
        horizontalScrollView.setSelectedCategory(currentIndex)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper Methods
    
    
    func searchTapped() {
        self.navigationController?.presentViewController(SearchViewController(), animated: true, completion: nil)
    }
    
    func setCartContainer() {
        cartVC = CartViewController()
        cartVC.view.frame = cartContainer.bounds
        cartContainer.addSubview(cartVC.view)
        cartVC.view.backgroundColor = UIColor.clearColor()
        self.addChildViewController(cartVC)
        cartVC.didMoveToParentViewController(self)
        debugPrint("set cart container")
    }
    
    // MARK: - UICollectionViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if self.scrollView == scrollView {
            return
        }
        
        let currentOffset = scrollView.contentOffset.y
        if currentOffset < -80 || currentOffset > 50 {
            previousOffset = currentOffset
            return
        }
        
        headerHeightConstraint.constant -= (currentOffset - previousOffset)
        if headerHeightConstraint.constant > 108 {
            headerHeightConstraint.constant = 108
        } else if headerHeightConstraint.constant < 64 {
            headerHeightConstraint.constant = 64
        }
        
        
        previousOffset = currentOffset
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            stoppedScrolling(scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        stoppedScrolling(scrollView)
    }
    
    func stoppedScrolling(scrollView: UIScrollView) {
        
        if self.scrollView == scrollView {
            let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
            print("current page \(currentPage)")
            currentIndex = currentPage
            horizontalScrollView.setSelectedCategory(currentPage)
        } else {
            if headerHeightConstraint.constant > 86 {
                headerHeightConstraint.constant = 108
            } else {
                headerHeightConstraint.constant = 64
            }
            
            if scrollView.contentOffset.y == 0 {
                headerHeightConstraint.constant = 108
            }
            
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func filtersTapped() {
        print("show filters")
        let vc = ProductFilterViewController(category: self.categories[currentIndex])
        vc.delegate = self
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    // MARK: - ProductFilterViewDelegate
    
    func didChangeSubcategories() {
        let vc = productsControllers[currentIndex]
        
        let subcategories = vc?.category.subcategories
        
        for c in subcategories! {
            if c.selectedAsSubcategory {
                print("Selected: \(c.name)")
            } else {
                print("not Selected: \(c.name)")
            }
        }
        
        vc?.loadProducts()
    }
    
    // MARK: - DiscoverBrowseScrollViewDelegate
    
    func discoverBrowseScrollButtonPressed(scrollView: UIScrollView, atIndex index: Int) {
        print("button pressed")
        horizontalScrollView.setSelectedCategory(index)
        self.scrollView.setContentOffset(CGPointMake(CGFloat(index) * scrollView.frame.size.width, 0), animated: true)
        self.currentIndex = index
    }


}
