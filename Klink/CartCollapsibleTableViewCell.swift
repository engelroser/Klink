//
//  CartCollapsibleTableViewCell.swift
//  Klink
//
//  Created by Mobile App Dev on 24/09/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit
import pop

protocol CartCollapsibleTableViewCellDelegate {
    func cellDidUpdated(cell : CartCollapsibleTableViewCell)
}

class CartCollapsibleTableViewCell: KlinkBaseTableViewCell {


    @IBOutlet var collapseButton: UIButton!
    @IBOutlet var itemsHolder: UIView!
    @IBOutlet var roundedContentView: UIView!
    @IBOutlet var itemsHolderHeightConstraint: NSLayoutConstraint!
    
    var originalCenter = CGPoint()
    var deleteOnDragRelease = false
    var showDeleteButton = false
    let deleteView = UIView()
    
    var items:[CartCollapsibleItemView] = []
    
    var isShow = false
    
    var delegate: CartCollapsibleTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        roundedContentView.layer.cornerRadius = 5
        roundedContentView.layer.masksToBounds = true
        
        deleteView.layer.cornerRadius = 5
        deleteView.layer.masksToBounds = true
        
        deleteView.backgroundColor = UIColor.kvfBrickColor().colorWithAlphaComponent(0.3)
        let deleteButton = UIButton(type: .Custom)
        deleteView.addSubview(deleteButton)
        deleteButton.autoPinEdge(.Trailing, toEdge: .Trailing, ofView: deleteView)
        deleteButton.autoPinEdge(.Top, toEdge: .Top, ofView: deleteView)
        deleteButton.autoPinEdge(.Bottom, toEdge: .Bottom, ofView: deleteView)
        deleteButton.autoMatchDimension(.Width, toDimension: .Width, ofView: deleteView, withMultiplier: 0.28)
        deleteButton.backgroundColor = UIColor.clearColor()
        deleteButton.setTitle("DELETE", forState: .Normal)
        deleteButton.titleLabel!.font =  UIFont(name: "Gotham-Book", size: 14)
        deleteButton.addTarget(self, action: "deleteItem", forControlEvents: .TouchUpInside)
        
        
        contentView.insertSubview(deleteView, belowSubview: roundedContentView)
        
        deleteView.autoMatchDimension(.Height, toDimension: .Height, ofView: roundedContentView)
        deleteView.autoMatchDimension(.Width, toDimension: .Width, ofView: roundedContentView)
        deleteView.autoCenterInSuperview()
        
        contentView.bringSubviewToFront(roundedContentView)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: "didPan:")
        panGesture.delegate = self
        roundedContentView.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "didTap")
        roundedContentView.addGestureRecognizer(tapGesture)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func deleteItem() {
        
    }
    
    func didTap() {
        let positionAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPosition)
        positionAnimation.toValue = NSValue(CGPoint: CGPointMake((contentView.frame.size.width / 2) , contentView.frame.size.height / 2))
        positionAnimation.springBounciness = 10
        roundedContentView.layer.pop_addAnimation(positionAnimation, forKey: "positionAnimation")
    }
    
    func didPan(pan: UIPanGestureRecognizer) {
        //        debugPrint("didpan")
        
        if let _ = backgroundView?.layer.pop_animationForKey("positionAnimation") {
            return
        }
        
        switch pan.state {
        case .Began:
            originalCenter = roundedContentView.center
            break
        case .Changed:
            let translation = pan.translationInView(self)
            if translation.x < 0 {
                roundedContentView.center = CGPointMake(originalCenter.x + translation.x, originalCenter.y)
            }
            
            let xPosition = roundedContentView.frame.origin.x - 15
            //            print("Frame width: \(backRoundedView.frame.size.width)")
            let alpha = (-xPosition) / (roundedContentView.frame.size.width)
            deleteView.backgroundColor = UIColor.kvfBrickColor().colorWithAlphaComponent(alpha)
            //            print("X position: \(alpha)")
            
            // has the user dragged the item far enough to initiate a delete/complete?
            deleteOnDragRelease = xPosition < -frame.size.width * 0.7
            showDeleteButton = xPosition > -frame.size.width * 0.7 && xPosition < -frame.size.width * 0.25
            break
            
        case .Ended:
            //            let originalFrame = CGRect(x: 0, y: contentView.frame.origin.y,
            //                width: contentView.bounds.size.width, height: contentView.bounds.size.height)
            if !deleteOnDragRelease && !showDeleteButton {
                let positionAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPosition)
                positionAnimation.toValue = NSValue(CGPoint: CGPointMake(contentView.frame.size.width / 2, contentView.frame.size.height / 2))
                positionAnimation.springBounciness = 10
                roundedContentView.layer.pop_addAnimation(positionAnimation, forKey: "positionAnimation")
            } else if deleteOnDragRelease {
                print("delete cell")
//                delegate?.itemDeleted(item)
            } else {
                print("delete button show")
                let positionAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPosition)
                positionAnimation.toValue = NSValue(CGPoint: CGPointMake((contentView.frame.size.width / 2) - contentView.frame.size.width * 0.25, contentView.frame.size.height / 2))
                positionAnimation.springBounciness = 10
                roundedContentView.layer.pop_addAnimation(positionAnimation, forKey: "positionAnimation")
                deleteView.backgroundColor = UIColor.kvfBrickColor().colorWithAlphaComponent(1)
            }
            break
            
        default:
            break
        }
    }
    
    
    func addItem() -> CartCollapsibleItemView {
        let test = CartCollapsibleItemView(frame: CGRectMake(0, 0, roundedContentView.frame.size.width, 64))
        return test
    }
    
    @IBAction func collapseShowPressed(sender: AnyObject) {
        var height:CGFloat = 0.0
        if items.count == 0 {
            
            var y:CGFloat = 0.0
            for _ in 1...4 {
                let test = CartCollapsibleItemView(frame: CGRectMake(0, y, roundedContentView.frame.size.width, 64))
                itemsHolder.addSubview(test)
                items.append(test)
                y+=test.frame.size.height
            }
        }
        
        for v in items {
            height += v.frame.size.height
        }
        
        if itemsHolderHeightConstraint.constant != 0 {
            itemsHolderHeightConstraint.constant = 0
            collapseButton.setImage(UIImage(named: "cart-dots"), forState: .Normal)
        } else {
            itemsHolderHeightConstraint.constant = height
            collapseButton.setImage(UIImage(named: "cart-arrow-up"), forState: .Normal)
        }
        
        setNeedsUpdateConstraints()
        layoutIfNeeded()
        
        delegate?.cellDidUpdated(self)
    }
    
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        self.endEditing(true)
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let translation = panGestureRecognizer.translationInView(superview!)
            if fabs(translation.x) > fabs(translation.y) {
                return true
            }
            return false
        }
        return false
    }
}
