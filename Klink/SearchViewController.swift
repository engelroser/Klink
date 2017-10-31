//
//  SearchViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 14/09/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate, UICollectionViewDelegate {
    
    // let searches = ["Coke", "Bud Light", "Ice", "Titos", "Smirnoff", "Andre", "Club Soda", "Red Wine"]
    var currentPage = 1
    var shouldLoadMoreProducts = true
    
    let ProductItemCellIdentifier = "ProductItemCellIdentifier"
    
    @IBOutlet var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet var headerView: UIView!
    var products:[ProductModel] = [] {
        didSet {
            if products.count == 0 {
                collectionView.hidden = true
            } else {
                collectionView.hidden = false
            }
        }
    }
    
    let cartVC = CartViewController()
    
    @IBOutlet var cartContainer: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var collectionViewBottom: NSLayoutConstraint!
    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet var scrollViewBottomConstraint: NSLayoutConstraint!
    init() {
        super.init(nibName: "SearchViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpScrollView()
        setupCollectionView()
        registerForKeyboardNotification()
        
        searchBar.delegate = self
        
        cartVC.view.frame = cartContainer.bounds
        cartContainer.addSubview(cartVC.view)
        cartVC.view.backgroundColor = UIColor.clearColor()
        self.addChildViewController(cartVC)
        cartVC.didMoveToParentViewController(self)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SearchViewController.becomeActive), name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.collectionView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
        print("Whaaaaat")
        view.bringSubviewToFront(headerView)
        headerHeightConstraint.constant = 64
        self.view.layoutIfNeeded()
    }
    
    override func viewWillDisappear(animated: Bool) {
        view.endEditing(true)
        unRegisterForKeyboardNotification()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper Methods
    
    func becomeActive() {
        print("activee")
        view.bringSubviewToFront(headerView)
        headerHeightConstraint.constant = 64
        self.view.layoutIfNeeded()
    }
    
    func setUpScrollView() {
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        
//        let titleLabel = UILabel(frame: CGRectMake(0, 30, screenWidth, 54))
//        titleLabel.font = UIFont(name: "Gotham-Bold", size: 18.0)
//        titleLabel.text = "POPULAR SEARCHES\nIN YOUR AREA"
//        titleLabel.textColor = UIColor.whiteColor()
//        titleLabel.textAlignment = NSTextAlignment.Center
//        titleLabel.numberOfLines = 2
        
        
//        scrollView.addSubview(titleLabel)
//        var yOffset:CGFloat = titleLabel.frame.origin.y + titleLabel.frame.size.height + 20
//        for search in searches {
//            let button:UIButton = UIButton(frame: CGRectMake(0, yOffset, screenWidth, 30))
//            button.setTitle(search.uppercaseString, forState: .Normal)
//            button.backgroundColor = UIColor.clearColor()
//            let font = UIFont(name: "Gotham-Book", size: 14.0)
//            button.titleLabel?.font = font
//            yOffset += 37
//            
//            scrollView.addSubview(button)
//        }
//        scrollView.contentSize = CGSizeMake(screenWidth, yOffset)
//        println("Scroll size: \(view.frame)")
    }
    
    func setupCollectionView() {
        let screenSize = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        
        //        collectionView.autoSetDimension(.Width, toSize: screenWidth)
//        collectionView!.autoSetDimension(.Height, toSize: 228.0)
        collectionView!.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.collectionBackground()
        collectionView!.registerNib(UINib(nibName: "ProductItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ProductItemCellIdentifier)
        
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, 48, 0)
        
        let flowLayout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        
        let cellWidth = (screenWidth / 2) - 7.50 - 20
        let cellHeight:CGFloat = cellWidth + ProductItemCollectionViewCell.cellBannerHeight
        flowLayout.itemSize = CGSizeMake(cellWidth, cellHeight)
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 20, 0, 20)
        collectionView.hidden = true
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return products.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ProductItemCellIdentifier, forIndexPath: indexPath) as! ProductItemCollectionViewCell
        cell.setupView(products[indexPath.row])
        // Configure the cell
        
        if indexPath.row == products.count - 1 && self.shouldLoadMoreProducts {
            print("LOAD MORE")
            loadMoreProducts(self.currentPage + 1)
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let product = products[indexPath.row]
        self.presentViewController(ItemCardViewController(product: product), animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
    // MARK: - Button Actions
    
    @IBAction func cancelPressed(sender: AnyObject) {
        searchBar.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - Keyboard Notification

    func registerForKeyboardNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SearchViewController.keyboardWillChange(_:)), name:UIKeyboardWillChangeFrameNotification, object: nil);
    }

    func unRegisterForKeyboardNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }

    // MARK: - Keyboard Notification
    
    func keyboardWillChange(sender: NSNotification) {
        let userInfo = sender.userInfo!
        let animationDuration: NSTimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let keyboardScreenBeginFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).CGRectValue()
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        let keyboardViewBeginFrame = view.convertRect(keyboardScreenBeginFrame, fromView: view.window)
        let keyboardViewEndFrame = view.convertRect(keyboardScreenEndFrame, fromView: view.window)
        let originDelta = keyboardViewEndFrame.origin.y - keyboardViewBeginFrame.origin.y
        
        
        scrollViewBottomConstraint.constant -= originDelta
        collectionViewBottom.constant -= originDelta
        UIView.animateWithDuration(animationDuration) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }

    // MARK: - UISearchBarDelegate
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        let searchTerm = searchText.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        if searchTerm.characters.count > 0 {
            ProductModel.allProductsBy(searchTerm, page: 1, storeID: SessionManager.getCurrentStoreID()!, completion: { (products, page, total, error) -> Void in
                if error == nil {
                    self.shouldLoadMoreProducts = true
                    
                    self.products = products!
                    self.collectionView.reloadData()
                    
                    if self.products.count >= total {
                        self.shouldLoadMoreProducts = false
                    }
                    
                    print("products: \(products)")
                }
            })
        }
    }
    
    func loadMoreProducts(page:Int!) {
        ProductModel.allProductsBy(searchBar.text, page: page, storeID: SessionManager.getCurrentStoreID(), completion: { (products, page, total, error) -> Void in
            if error == nil {
                self.currentPage = page!
                self.products.appendContentsOf(products!)
                self.collectionView.reloadData()
                
                if self.products.count >= total {
                    self.shouldLoadMoreProducts = false
                }
                
                print("products: \(products)")
            }
        })
    }

}
