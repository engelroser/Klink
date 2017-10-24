//
//  ProductItemCollectionViewCell.swift
//  Klink
//
//  Created by Mobile App Dev on 11/09/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit
import PureLayout
import ImageLoader
import Kingfisher

class ProductItemCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {

    @IBOutlet var plusButton: UIButton!
    @IBOutlet var minusButton: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var overlay: UIView!
    @IBOutlet var nameLabel: KLLabel!
    @IBOutlet var variantsContentView: UIView!
    @IBOutlet var variantsContentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var productImageView: UIImageView!
    
    var product:ProductModel!
    var currentVariant:ProductVariantModel!
    
    var variantsInCart:[Int:ProductVariantModel]!
    
    var image:UIImage?
    
    static let cellBannerHeight:CGFloat = 56.0
    
    @IBOutlet var scrollContentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var itemsInCartLabel: UILabel!
    
    var itemsInCart:Int =  0 {
        didSet {
            if itemsInCart < 0 {
                itemsInCart = 0
            }
            itemsInCartLabel.text = "\(itemsInCart)"
            if itemsInCart > 0 {
                fadeInOverlay()
                setWhiteButtons()
            } else {
                fadeOutOverlay()
                setBlackButtons()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       scrollView.delegate = self
        
        
        
        if itemsInCart == 0 {
            overlay.alpha = 0
        } else {
            overlay.alpha = 1
            itemsInCartLabel.text = "\(itemsInCart)"
        }
    }
    
    deinit {
//        for p in product.variants {
//            CartModel.sharedInstance.addItem(p)
//        }
    }
    
    func setupVariantView(packageItem: PackItemModel!) {

//        let variant = packageItem.productVariant
//        
//        let product = ProductModel()
//        product.name = variant.presentation
//        product.variants.append(variant)
//        product.color = "#000000"
//        product.imagePath = variant.imagePath
        
        
        
        self.setupView(product)
    }
    
    func setupView(product:ProductModel!) {
        self.product = product
        nameLabel.text = product.name
        pageControl.numberOfPages = product.variants.count
        
//        print("variants: \(product.variants.count)")
        self.productImageView.image = nil
        if let path = product.imagePath {
            
            productImageView.kf_setImageWithURL(NSURL(string: path)!, placeholderImage: nil)
            
//            productImageView.load(path, placeholder: nil, completionHandler: { (url, image, error, cache) -> Void in
//                self.productImageView.image = image
//            })
        }
        
        for v in variantsContentView.subviews {
            v.removeFromSuperview()
        }
        
        var previousView:UIView?
        for (_, variant) in product.variants.enumerate() {
            let v = UIView()
            
            v.backgroundColor = UIColor.clearColor()
            
            variantsContentView.addSubview(v)
            v.autoMatchDimension(.Width, toDimension: .Width, ofView: scrollView)
            v.autoMatchDimension(.Height, toDimension: .Height, ofView: scrollView)
            v.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: scrollView)
            v.autoPinEdge(.Top, toEdge: .Top, ofView: scrollView)
            
            if let temp = previousView {
                v.autoPinEdge(.Left, toEdge: .Right, ofView: temp)
                temp.backgroundColor = UIColor.clearColor()
                
            } else {
                v.autoPinEdge(.Leading, toEdge: .Leading, ofView: variantsContentView)
            }
            
            // add variant name label
            let kLabel = KLLabel()
            kLabel.textAlignment = .Center
            kLabel.text = variant.presentation
            kLabel.textColor = UIColor.whiteColor()
            kLabel.font = UIFont(name: "Gotham-Book", size: 11.0)
            
            v.addSubview(kLabel)
            kLabel.autoPinEdge(.Top, toEdge: .Top, ofView: v, withOffset: 8.0)
            kLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: v)
            kLabel.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: v)
            
            // add variant price label
            let pLabel = KLLabel()
            pLabel.textAlignment = .Center
            let priceString = String(format: "%.2f", variant.price/100)
            pLabel.text = "$\(priceString)"
            pLabel.textColor = UIColor.whiteColor()
            pLabel.font = UIFont(name: "Gotham-Book", size: 11.0)
            
            v.addSubview(pLabel)
            pLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: kLabel, withOffset: 2.0)
            pLabel.autoPinEdge(.Leading, toEdge: .Leading, ofView: v)
            pLabel.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: v)
            
            previousView = v
            
        }
        
        variantsContentView.backgroundColor = UIColor.clearColor()
//        scrollView.backgroundColor = UIColor(hexString: product.color)
        scrollView.backgroundColor = UIColor.blackColor()
        scrollView.pagingEnabled = true
        
        if product.variants.count == 1 {
            pageControl.hidden = true
            scrollView.alwaysBounceHorizontal = false
        }
        
        variantsContentViewWidthConstraint.constant = CGFloat(self.product.variants.count) * self.frame.size.width
        
//        print("NAME: \(product.name), \(variantsContentViewWidthConstraint.constant)")
        
        let variant = product.variants[pageControl.currentPage]
        itemsInCartLabel.text = "\(variant.itemsInCart)"
        if variant.itemsInCart > 0 {
//            fadeInOverlay()
             self.overlay.alpha = 1
            setWhiteButtons()
        } else {
//            fadeOutOverlay()
             self.overlay.alpha = 0
            setBlackButtons()
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if self.product != nil {
            variantsContentViewWidthConstraint.constant = CGFloat(self.product.variants.count) * self.frame.size.width
            
//            print("NAME: \(product.name), \(variantsContentViewWidthConstraint.constant)")
            self.layoutIfNeeded()
        }

    }
    
    // MARK: - Helper Methods
    
    func setWhiteButtons() {
        plusButton.setImage(UIImage(named: "addIconWhite"), forState: .Normal)
        minusButton.setImage(UIImage(named: "removeIconWhite"), forState: .Normal)
    }
    
    func setBlackButtons() {
        plusButton.setImage(UIImage(named: "addIconBlack"), forState: .Normal)
        minusButton.setImage(UIImage(named: "removeIconBlack"), forState: .Normal)
    }
    
    func fadeInOverlay() {
        UIView.animateWithDuration(0.3) { () -> Void in
            self.overlay.alpha = 1
        }
    }
    
    func fadeOutOverlay() {
        UIView.animateWithDuration(0.3) { () -> Void in
            self.overlay.alpha = 0
        }
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print("scrolled")
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        print("scroll productaaa")
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        
        let variant = product.variants[Int(pageNumber)]
        itemsInCart = variant.itemsInCart
        
    }

    // MARK: - Button Actions
    
    @IBAction func plusPressed(sender: AnyObject) {
        if SessionManager.getAccessToken() == nil {
            print("login")
            NSNotificationCenter.defaultCenter().postNotificationName(KlinkRevealViewController.NOT_LOGGED_IN, object: nil)
            return
        }
//        itemsInCart++
        let variant = product.variants[pageControl.currentPage]
        variant.itemsInCart += 1
        
        Cart.getCart()?.addItem(variant, quantity: 1)
        print("VARIATN :\(variant.itemsInCart)")
        itemsInCart = variant.itemsInCart
    }
    
    @IBAction func minusPressed(sender: AnyObject) {
        if SessionManager.getAccessToken() == nil {
            print("login")
            NSNotificationCenter.defaultCenter().postNotificationName(KlinkRevealViewController.NOT_LOGGED_IN, object: nil)
            return
        }
//        itemsInCart--
        let variant = product.variants[pageControl.currentPage]
        print("VARIATN :\(variant.itemsInCart)")
        if variant.itemsInCart - 1 >= 0 {
            variant.itemsInCart -= 1
            Cart.getCart()?.removeItem(variant)
        }
        
        itemsInCart = variant.itemsInCart
    }
}
