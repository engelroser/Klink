//
//  CartRoundedTableViewCell.swift
//  Klink
//
//  Created by Mobile App Dev on 24/09/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit

import pop
import PureLayout

protocol CartRoundedCellDelegate: NSObjectProtocol {
    func itemDeleted(item: Item)
    func itemQuantityUpdated(item: Item)
    func quantityDidBeginEditing()
    func quantityDidEndEditing()
}

class CartRoundedTableViewCell: KlinkBaseTableViewCell, UITextFieldDelegate {

    @IBOutlet var backRoundedView: UIView!
    var originalCenter = CGPoint()
    var deleteOnDragRelease = false
    var showDeleteButton = false
    let deleteView = UIView()
    var item:Item!
    weak var delegate:CartRoundedCellDelegate?
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var productOptionsLabel: UILabel!
    @IBOutlet var productPriceLabel: UILabel!
    @IBOutlet var quantityTextField: UITextField!
    @IBOutlet var productImageView: UIImageView!
    
    var quantity = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        quantityTextField.delegate = self
        quantityTextField.returnKeyType = .Done
        
        backRoundedView.layer.cornerRadius = 5
        backRoundedView.layer.masksToBounds = true
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
        deleteButton.addTarget(self, action: #selector(CartRoundedTableViewCell.deleteItem), forControlEvents: .TouchUpInside)
        
        contentView.insertSubview(deleteView, belowSubview: backRoundedView)

        deleteView.autoMatchDimension(.Height, toDimension: .Height, ofView: backRoundedView)
        deleteView.autoMatchDimension(.Width, toDimension: .Width, ofView: backRoundedView)
        deleteView.autoCenterInSuperview()
        
        contentView.bringSubviewToFront(backRoundedView)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: "didPan:")
        panGesture.delegate = self
        backRoundedView.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "didTap")
        backRoundedView.addGestureRecognizer(tapGesture)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView(item: Item) {
        
        self.item = item
        
        if let p = item.unitPrice?.prettyPriceInDollars() {
            productNameLabel.text = item.name
            productPriceLabel.text = "$\(p)"
            quantityTextField.text = "\(item.quantity!)"
            
            if let itemImage = item.image {
                
                productImageView.kf_setImageWithURL(NSURL(string: itemImage)!, placeholderImage: nil)
//                
//                productImageView.load(itemImage, placeholder: nil, completionHandler: { (url, image, error, cache) -> Void in
//                    if error == nil {
//                        self.productImageView.image = image
//                    }
//                })
            }
        }
        
        
    }
    
    func didPan(pan: UIPanGestureRecognizer) {
        if let _ = backgroundView?.layer.pop_animationForKey("positionAnimation") {
            return
        }
        
        switch pan.state {
        case .Began:
            originalCenter = backRoundedView.center
            break
        case .Changed:
            let translation = pan.translationInView(self)
            if translation.x < 0 {
                backRoundedView.center = CGPointMake(originalCenter.x + translation.x, originalCenter.y)
            }
            let xPosition = backRoundedView.frame.origin.x - 15
            let alpha = (-xPosition) / (backRoundedView.frame.size.width)
            deleteView.backgroundColor = UIColor.kvfBrickColor().colorWithAlphaComponent(alpha)
            deleteOnDragRelease = xPosition < -frame.size.width * 0.7
            showDeleteButton = xPosition > -frame.size.width * 0.7 && xPosition < -frame.size.width * 0.25
            break
            
        case .Ended:
            if !deleteOnDragRelease && !showDeleteButton {
                let positionAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPosition)
                positionAnimation.toValue = NSValue(CGPoint: CGPointMake(contentView.frame.size.width / 2, contentView.frame.size.height / 2))
                positionAnimation.springBounciness = 10
                backRoundedView.layer.pop_addAnimation(positionAnimation, forKey: "positionAnimation")
            } else if deleteOnDragRelease {
                print("delete cell")
                delegate?.itemDeleted(item)
            } else {
                print("delete button show")
                let positionAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPosition)
                positionAnimation.toValue = NSValue(CGPoint: CGPointMake((contentView.frame.size.width / 2) - contentView.frame.size.width * 0.25, contentView.frame.size.height / 2))
                positionAnimation.springBounciness = 10
                backRoundedView.layer.pop_addAnimation(positionAnimation, forKey: "positionAnimation")
                deleteView.backgroundColor = UIColor.kvfBrickColor().colorWithAlphaComponent(1)
            }
            break
            
        default:
            break
        }
    }
    
    func didTap() {
        let positionAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPosition)
        positionAnimation.toValue = NSValue(CGPoint: CGPointMake((contentView.frame.size.width / 2) , contentView.frame.size.height / 2))
        positionAnimation.springBounciness = 10
        backRoundedView.layer.pop_addAnimation(positionAnimation, forKey: "positionAnimation")
        self.endEditing(true)
    }
    
    func deleteItem() {
        delegate?.itemDeleted(item)
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
    
    @IBAction func subtractItemPressed(sender: AnyObject) {
        var quantity = self.item.quantity!.integerValue
        
        if quantity > 0 {
            quantity--
            
            self.item.quantity = NSNumber(integer: quantity)
            self.delegate?.itemQuantityUpdated(self.item)
        }
    }

    @IBAction func addItemPressed(sender: AnyObject) {
        var quantity = self.item.quantity!.integerValue
        
        quantity++
        
        self.item.quantity = NSNumber(integer: quantity)
        self.delegate?.itemQuantityUpdated(self.item)
    }
    
    private func changeQuantity() {
        
        var result = Int(quantityTextField.text!)! - quantity
        
        if result > 0 {

            self.item.quantity = NSNumber(integer: quantity + result)
            self.delegate?.itemQuantityUpdated(self.item)
            
        } else if result < 0 {
            
            result *= -1

            self.item.quantity = NSNumber(integer: quantity - result)
            self.delegate?.itemQuantityUpdated(self.item)
        }
    }
    
    
    // MARK: - UITextFieldDelegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if textField.text!.characters.first == "0" && string != "." && string != ","  {
            textField.text! = string
            
            return false
        }
        
        if range.location > 2 {
            return false
        }
        
        let num = Int(string)
        
        if num != nil || string == "" && (string != "," || string != ".")  {
            return true
        } else {
            return false
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.delegate?.quantityDidBeginEditing()
        quantity = Int(textField.text!)!
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.delegate?.quantityDidEndEditing()
        if quantityTextField.text!.characters.count > 0 {
            if Int(quantityTextField.text!)! > -1 {
                self.changeQuantity()
            }
        } else {
            quantityTextField.text! = "\(quantity)"
        }
    }
    
}
