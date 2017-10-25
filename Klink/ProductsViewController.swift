//
//  ProductsViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 23/10/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit

class ProductsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet var collectionView: UICollectionView!
    let ProductItemCellIdentifier = "ProductItemCellIdentifier"
    
    var currentPage = 1
    var shouldLoadMoreProducts = true
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    var products:[ProductModel] = []
    
    var category:CategoryModel!
    init(category: CategoryModel!) {
        super.init(nibName: "ProductsViewController", bundle: nil)
        self.category = category
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpCollectionView()
        
        print("subcategories: \(self.category.subcategories.count)")
        
        collectionView.hidden = true
        spinner.startAnimating()
        ProductModel.allProductsByCategory(self.category, page: 1, storeID: SessionManager.getCurrentStoreID()!) { (products, page, total, error) -> Void in
            self.spinner.hidden = true
            self.spinner.stopAnimating()
            if error == nil {
                self.shouldLoadMoreProducts = true
                self.collectionView.hidden = false
                self.products = products!
                self.collectionView.reloadData()
                
                if self.products.count >= total {
                    self.shouldLoadMoreProducts = false
                }
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper Methods
    
    func loadProducts() {
        self.products = [ ]
        collectionView.hidden = true
        self.spinner.hidden = false
        view.bringSubviewToFront(spinner)
        spinner.startAnimating()
        self.currentPage = 1
        ProductModel.allProductsByCategory(self.category, page: 1, storeID: SessionManager.getCurrentStoreID()!) { (products, page, total, error) -> Void in
            self.collectionView.hidden = false
            self.spinner.hidden = true
            if error == nil {
                self.shouldLoadMoreProducts = true
                
                self.products = products!
                self.collectionView.reloadData()
                
                if self.products.count == 0 {
                    let alertVC = UIAlertController(title: "", message: "This store doesn’t have drinks for that filter category. Try another one.", preferredStyle: .Alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: { (act) -> Void in
                        alertVC.dismissViewControllerAnimated(true, completion: nil)
                    })
                    
                    alertVC.addAction(okAction)
                    
                    self.presentViewController(alertVC, animated: true, completion: nil)
                }
                
                if self.products.count >= total {
                    self.shouldLoadMoreProducts = false
                }
            }
        }
    }
    
    func setUpCollectionView() {
        let screenSize = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        
        //        collectionView.autoSetDimension(.Width, toSize: screenWidth)
        collectionView!.autoSetDimension(.Height, toSize: 228.0)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerNib(UINib(nibName: "ProductItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ProductItemCellIdentifier)
        let flowLayout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        
        let cellWidth = (screenWidth / 2) - 7.50 - 20
        let cellHeight:CGFloat = cellWidth + ProductItemCollectionViewCell.cellBannerHeight
        flowLayout.itemSize = CGSizeMake(cellWidth, cellHeight)
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 20, 0, 20)
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
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
        
        if indexPath.row == products.count - 1 && self.shouldLoadMoreProducts {
            print("LOAD MORE")
            loadMoreProducts(self.currentPage + 1)
        }
        
        return cell
    }
    
    func loadMoreProducts(page:Int!) {
        ProductModel.allProductsByCategory(self.category, page: page, storeID: SessionManager.getCurrentStoreID()) { (products, page, total, error) -> Void in
            if error == nil {
                self.currentPage = page!
                self.products.appendContentsOf(products!)
                self.collectionView.reloadData()
                
                print("Hej narode: \(self.products.count), \(products?.count)")
                
                if self.products.count >= total {
                    self.shouldLoadMoreProducts = false
                }
                
                print("products: \(products)")
            }
        }
    }
    

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let product = products[indexPath.row]
        self.presentViewController(ItemCardViewController(product: product), animated: true, completion: nil)
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */
    
    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */
    
    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return false
    }
    
    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
    return false
    }
    
    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
