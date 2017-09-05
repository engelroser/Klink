//
//  ItemCardsViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 14/09/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit

class ItemCardsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var pageController:UIPageViewController?
    let CellIdentifier = "CellIdentifier"
    
    @IBOutlet var cartContainerView: UIView!
    var screenWidth:CGFloat = 0.0

    @IBOutlet var collectionView: UICollectionView!
    
    init() {
        super.init(nibName: "ItemCardsViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        screenWidth = screenSize.width
//        let screenHeight = screenSize.height
        
        let cartVC = CartViewController()
        addChildViewController(cartVC)
        cartVC.view.frame = cartContainerView.bounds
        cartVC.view.backgroundColor = UIColor.clearColor()
        cartContainerView.addSubview(cartVC.view)
        cartVC.didMoveToParentViewController(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        setUpCollectionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper Methods
    
    func setUpCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenHeight = screenSize.height
        
        let cellWidth = (screenWidth - 40)
        let cellHeight = screenHeight
        
        
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20)
        flowLayout.minimumLineSpacing = 10
        flowLayout.itemSize = CGSizeMake(cellWidth, cellHeight)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(ItemCardHolderCollectionViewCell.self, forCellWithReuseIdentifier: CellIdentifier)
        collectionView.setCollectionViewLayout(flowLayout, animated: false)
//        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ItemCardHolderCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier, forIndexPath: indexPath) as! ItemCardHolderCollectionViewCell
//        if cell.cardVC == nil{
//            let nextVC = ItemCardViewController()
//            self.addChildViewController(nextVC)
//        
//            nextVC.view.frame = cell.bounds
//            
//            nextVC.beginAppearanceTransition(true, animated: true)
//            
//            cell.contentView.addSubview(nextVC.view)
//            nextVC.endAppearanceTransition()
//            nextVC.didMoveToParentViewController(self)
//            nextVC.view.backgroundColor = UIColor.clearColor()
//            
//            
//            cell.contentView.clipsToBounds = false
//            cell.cardVC = nextVC
//        }
        
        return cell
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageWidth = screenWidth - 30
        let currentOffset = scrollView.contentOffset.x
        let targetOffset = targetContentOffset.memory.x
        var newTargetOffset:CGFloat = 0.0
        
        
        if targetOffset > currentOffset {
            newTargetOffset = ceil(currentOffset / pageWidth) * pageWidth
        } else {
            newTargetOffset = floor(currentOffset / pageWidth) * pageWidth
        }
        
        if newTargetOffset < 0 {
            newTargetOffset = 0
        } else if newTargetOffset > scrollView.contentSize.width {
            newTargetOffset = scrollView.contentSize.width
        }
//        println("-----")
//        println("current: \(currentOffset), newtarget: \(newTargetOffset)")
        targetContentOffset.memory.x = currentOffset
        scrollView.userInteractionEnabled = false
        scrollView.setContentOffset(CGPointMake(newTargetOffset, 0), animated: true)
        
        let index = Int(newTargetOffset / pageWidth)

        UIView.animateWithDuration(0.2, animations: { () -> Void in
            if let cell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0)) {
                let tempVC = (cell as! ItemCardHolderCollectionViewCell).cardVC
                tempVC?.tableView.contentOffset = CGPointMake(0, -30)
                tempVC?.tableView.contentInset = UIEdgeInsetsMake(30, 0, 50, 0)
                cell.superview?.bringSubviewToFront(cell)
            }
            
            if let cell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index - 1 , inSection: 0)) {
//                println("left cell")
                let tempVC = (cell as! ItemCardHolderCollectionViewCell).cardVC
                tempVC?.tableView.contentOffset = CGPointMake(0, -60)
                tempVC?.tableView.contentInset = UIEdgeInsetsMake(60, 0, 50, 0)
            }
            if let cell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index + 1 , inSection: 0)) {
//                println("right cell")
                let tempVC = (cell as! ItemCardHolderCollectionViewCell).cardVC
                tempVC?.tableView.contentOffset = CGPointMake(0, -60)
                tempVC?.tableView.contentInset = UIEdgeInsetsMake(60, 0, 50, 0)
            }
        })
        
    }
    
    
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if !decelerate {
            stoppedScrolling()
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//        println("scrollViewDidEndDecelerating")
        
        stoppedScrolling()
    }
    
    func stoppedScrolling() {
//        println("stopped scrolling")
        collectionView.userInteractionEnabled = true
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
//        println("scrolling animation stopped")
        scrollView.userInteractionEnabled = true
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
