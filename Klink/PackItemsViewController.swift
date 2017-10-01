//
//  PackItemsViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 03/11/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit

class PackItemsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    let ProductCellIdentifier = "ProductCellIdentifier"
    @IBOutlet var headerImageView: UIImageView!
    @IBOutlet var packageTitleLabel: UILabel!
    @IBOutlet var packageDescriptionLabel: UILabel!
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var cartContainer: UIView!
    var pack:PackModel!
    
    let cartVC = CartViewController()
    
    init(pack: PackModel) {
        super.init(nibName: "PackItemsViewController", bundle: nil)
        self.pack = pack
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupCollectionView()
        
        self.packageTitleLabel.text = pack!.name.uppercaseString
        
        PackModel.getPackage(pack.id!) { (pack, error) -> Void in
            if error == nil {
                self.pack = pack
                
                if let packDescription = self.pack.packDescription {
                    let descriptionStyle = NSMutableParagraphStyle()
                    descriptionStyle.lineSpacing = 4
                    descriptionStyle.alignment = NSTextAlignment.Center
                    let packDescriptionAttributedText = NSMutableAttributedString(string: packDescription)
                    packDescriptionAttributedText.addAttribute(NSParagraphStyleAttributeName, value:descriptionStyle, range:NSMakeRange(0, packDescriptionAttributedText.length))
                    
                    self.packageDescriptionLabel.attributedText = packDescriptionAttributedText
                }
                
                self.collectionView.hidden = false
                self.collectionView.reloadData()
            }
        }
        
        if let image = pack.imagePath {
            headerImageView.kf_setImageWithURL(NSURL(string: image)!, placeholderImage: nil)
//            headerImageView.load(image)
        }
        
        view.backgroundColor = UIColor.collectionBackground()
        
        spinner.startAnimating()
        
        cartVC.view.frame = cartContainer.bounds
        cartContainer.addSubview(cartVC.view)
        cartVC.view.backgroundColor = UIColor.clearColor()
        self.addChildViewController(cartVC)
        cartVC.didMoveToParentViewController(self)
        
        let searchIcon = UIBarButtonItem(image: UIImage(named: "navigation-search-icon"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PackItemsViewController.searchTapped))
        
        self.navigationItem.rightBarButtonItem = searchIcon
    }
    
    override func viewWillAppear(animated: Bool) {
        self.collectionView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.contentInset = UIEdgeInsetsMake(headerImageView.frame.size.height + 50, 0, 48, 0)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchTapped() {
        self.navigationController?.presentViewController(SearchViewController(), animated: true, completion:nil)
    }
    
    // MARK: - Helper Methods
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsetsMake(220, 0, 48, 0)
        collectionView.backgroundColor = UIColor.collectionBackground()
        collectionView.registerNib(UINib(nibName: "ProductItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ProductCellIdentifier)
        
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let screenWidth = UIScreen.mainScreen().bounds.width
        
        let cellWidth = (screenWidth / 2) - 7.50 - 20
        let cellHeight:CGFloat = cellWidth + ProductItemCollectionViewCell.cellBannerHeight
        flowLayout.itemSize = CGSizeMake(cellWidth, cellHeight)
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20)
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return pack.packItems.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ProductCellIdentifier, forIndexPath: indexPath) as! ProductItemCollectionViewCell
        
        cell.setupView(pack.packItems[indexPath.row].product)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let product = pack.packItems[indexPath.row].product
        self.presentViewController(ItemCardViewController(product: product), animated: true, completion: nil)
    }

    // MARK: - Button Actions
    
    @IBAction func addToCartPressed(sender: AnyObject) {
        if pack.packItems.count == 0 {
            return
        }
//        PackModel.getPackage(pack.id!) { (pack, error) in
            let controller = PackContentViewController(pack: self.pack)
            controller.delegate = self
            self.presentViewController(controller, animated: true, completion: nil)
//        }
    }
    
    func updateControllerAfterDismissing() -> Void {
        
        self.collectionView.reloadData()
    }
}
