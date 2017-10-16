//
//  PacksViewController.swift
//  Klink
//
//  Created by Mobile App Developer on 27/10/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit
import PureLayout

class PacksViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet var collectionView: UICollectionView!
//    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet var cartContainer: UIView!
    @IBOutlet var headerOverlay: UIView!
    @IBOutlet var headerImageView: UIImageView!
    @IBOutlet var headerTitleTopConstraint: NSLayoutConstraint!
    @IBOutlet var headerTitleLabel: KLLabel!
    @IBOutlet var headerDescLabel: KLLabel!
    
    let headerMaxheight:CGFloat = 220.0
    let headerMinHeight:CGFloat = 64.0
    let PackItemCellIdentifier = "PackItemCellIdentifier"
    let LoadingCellIdentifier = "LoadingCellIdentifier"
    var packs:[PackModel] = []
    let cartVC = CartViewController()
    
    var collectionModel:CollectionModel!
    
    init(collectionModel:CollectionModel!) {
        super.init(nibName: "PacksViewController", bundle: nil)
        self.collectionModel = collectionModel
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupCollectionView()
        
        let searchIcon = UIBarButtonItem(image: UIImage(named: "navigation-search-icon"), style: UIBarButtonItemStyle.Plain, target: self, action: "searchTapped")
        
        self.navigationItem.rightBarButtonItem = searchIcon
        spinner.startAnimating()
        if let id = SessionManager.getCurrentStoreID() {
            PackModel.getPackages(id, collectionID: collectionModel.id, page: 0, completion: { (packs, error) -> Void in
                if error == nil {
                    self.spinner.hidden = true
                    self.packs = packs!
                    self.collectionView.reloadData()
                } else {
                    
                }
            })
        }
        
        let backItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        headerTitleLabel.text = collectionModel.name.uppercaseString
        
        if let collectionHeroImage = collectionModel.image {
            headerImageView.kf_setImageWithURL(NSURL(string: collectionHeroImage)!, placeholderImage: nil)
//            headerImageView.load(collectionHeroImage, placeholder: nil) { (url, image, error, cache) -> Void in
//                if error == nil {
//                    self.headerImageView.image = image
//                }
//            }
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.alignment = NSTextAlignment.Center
        
        let headerDescAttributedText = NSMutableAttributedString(string: collectionModel.desc!)
        headerDescAttributedText.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, headerDescAttributedText.length))
        
        headerDescLabel.attributedText = headerDescAttributedText
        
        cartVC.view.frame = cartContainer.bounds
        cartContainer.addSubview(cartVC.view)
        cartVC.view.backgroundColor = UIColor.clearColor()
        self.addChildViewController(cartVC)
        cartVC.didMoveToParentViewController(self)
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        collectionView.alwaysBounceVertical = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper Methods
    
    func searchTapped() {
        self.navigationController?.presentViewController(SearchViewController(), animated: true, completion:nil)
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsetsMake(220, 0, 48, 0)
        collectionView.backgroundColor = UIColor.collectionBackground()
        collectionView.registerNib(UINib(nibName: "PackCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: PackItemCellIdentifier)
        
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let screenWidth = UIScreen.mainScreen().bounds.width
        
        let cellWidth = (screenWidth / 2) - 7.50 - 20
        let cellHeight:CGFloat = cellWidth * 1.2
        flowLayout.itemSize = CGSizeMake(cellWidth, cellHeight)
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20)
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packs.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PackItemCellIdentifier, forIndexPath: indexPath) as! PackCollectionViewCell
        cell.setupView(packs[indexPath.row])
        
        return cell
    }
    
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        headerHeightConstraint.constant = -collectionView.contentOffset.y
        
        if headerHeightConstraint.constant < headerMinHeight {
            headerHeightConstraint.constant = headerMinHeight
        } else if headerHeightConstraint.constant > headerMaxheight {
            headerHeightConstraint.constant = headerMaxheight
        }
        
        headerTitleTopConstraint.constant = headerHeightConstraint.constant - 160

        if headerTitleTopConstraint.constant < 20 {
            headerTitleTopConstraint.constant = 20
        } else if headerTitleTopConstraint.constant > 60 {
            headerTitleTopConstraint.constant = 60
        }
        
        let alpha = 1 - ((headerHeightConstraint.constant - headerMinHeight)/(headerMaxheight - headerMinHeight))
        headerOverlay.alpha = alpha + 0.2
        
        headerDescLabel.alpha = 1 - alpha
        
        if alpha == 1 {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.headerImageView.alpha = 0
            })
        } else {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.headerImageView.alpha = 1
            })
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        let backItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        self.navigationController?.pushViewController(PackItemsViewController(pack: packs[indexPath.row]), animated: true)
//        self.presentViewController(PackItemsViewController(), animated: true, completion: nil)
    }

}
