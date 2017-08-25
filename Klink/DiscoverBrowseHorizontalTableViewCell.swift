//
//  DiscoverBrowseHorizontalTableViewCell.swift
//  Klink
//
//  Created by Mobile App Dev on 23/10/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit

protocol DiscoverBrowseHorizontalCellDelegate {
    func didSelectProduct(product: ProductModel)
}

class DiscoverBrowseHorizontalTableViewCell: KlinkBaseTableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var titleLabel: UILabel!
    
    let ProductItemCellIdentifier = "ProductItemCellIdentifier"
    let HeaderSupplementaryViewIdentifier = "HeaderSupplementaryViewIdentifier"
    
    var products:[ProductModel] = []
    
    var delegate:DiscoverBrowseHorizontalCellDelegate?
    
    var category:CategoryModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setUpCollectionView()

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func didMoveToSuperview() {
        setUpCollectionView()
    }
    
    func setUpCollectionView() {
        let screenSize = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        
//        collectionView.autoSetDimension(.Width, toSize: screenWidth)
        collectionView.autoSetDimension(.Height, toSize: 228.0)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerNib(UINib(nibName: "ProductItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ProductItemCellIdentifier)
        collectionView.registerNib(UINib(nibName: "ProductItemHeaderReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HeaderSupplementaryViewIdentifier)
        
        collectionView.backgroundColor = UIColor.clearColor()
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        let cellWidth = (screenWidth / 2) - 7.50 - 20
        let cellHeight:CGFloat = cellWidth + ProductItemCollectionViewCell.cellBannerHeight
        flowLayout.itemSize = CGSizeMake(cellWidth, cellHeight)
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20)
        flowLayout.scrollDirection = .Horizontal
//        flowLayout.headerReferenceSize = CGSizeMake(20, 38);
    }
    
    
    func setupView(category: CategoryModel!) {
        
        self.category = category
        titleLabel.text = category.name.uppercaseString
        if products.count == 0 {
            ProductModel.allProductsByCategory(category, page: 1, storeID: SessionManager.getCurrentStoreID(), completion: { (products, page, total, error) -> Void in
                if error == nil {
                    self.products = products!
                    self.collectionView.reloadData()
                }
            })
        }
        print("Reload asljdlas;ls;lsdlksdsls")
        self.collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ProductItemCellIdentifier, forIndexPath: indexPath) as! ProductItemCollectionViewCell
        cell.setupView(self.products[indexPath.row])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.didSelectProduct(self.products[indexPath.row])
    }
    
//    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//        var header: ProductItemHeaderReusableView?
//
//        if kind == UICollectionElementKindSectionHeader {
//            header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: HeaderSupplementaryViewIdentifier, forIndexPath: indexPath) as? ProductItemHeaderReusableView
//        }
//        return header!
//    }
    
}
