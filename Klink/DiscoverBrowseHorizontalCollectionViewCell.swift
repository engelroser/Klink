//
//  DiscoverBrowseHorizontalCollectionViewCell.swift
//  Klink
//
//  Created by Mobile App Dev on 23/10/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit
import PureLayout

class DiscoverBrowseHorizontalCollectionViewCell: UITableViewCell, UICollectionViewDataSource {

    @IBOutlet var collectionView: UICollectionView!
    
    let ProductItemCellIdentifier = "ProductItemCellIdentifier"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.autoSetDimension(.Width, toSize: 320)
        self.autoSetDimension(.Height, toSize: 228)
        setUpCollectionView()
    }
    
    
    func setUpCollectionView() {
        let screenSize = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        
        collectionView.autoSetDimension(.Width, toSize: screenWidth)
        collectionView.autoSetDimension(.Height, toSize: 220.0)
        collectionView.dataSource = self
//        collectionView.delegate = self
        collectionView.registerNib(UINib(nibName: "ProductItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ProductItemCellIdentifier)
//        collectionView.registerNib(UINib(nibName: "ProductItemHeaderReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HeaderSupplementaryViewIdentifier)
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout

        let cellWidth = (screenWidth / 2) - 7.50 - 20
        let cellHeight = collectionView.frame.size.height
        flowLayout.itemSize = CGSizeMake(cellWidth, cellHeight)
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 10)
//        flowLayout.headerReferenceSize = CGSizeMake(20, 38);
        flowLayout.scrollDirection = .Horizontal
    }
    
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ProductItemCellIdentifier, forIndexPath: indexPath)
        
        return cell
    }
    
}
