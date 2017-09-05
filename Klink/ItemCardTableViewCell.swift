//
//  ItemCardTableViewCell.swift
//  Klink
//
//  Created by Mobile App Dev on 16/09/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit

protocol ItemCardTableViewCellDelegate {
    func quantityChanged()
    func quantityDidBeginEditing()
    func quantityDidEndEditing()
}

class ItemCardTableViewCell: KlinkBaseTableViewCell, UITextFieldDelegate {
    
    @IBOutlet var itemsAddedTextField: UITextField!
    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet var itemTitleLabel: KLLabel!
    @IBOutlet var itemSubtitleLabel: KLLabel!
    @IBOutlet var itemPriceLabel: KLLabel!
    
    var quantity = 0
    var packItem:PackItemModel?
    var delegate:ItemCardTableViewCellDelegate?
    
    var variant:ProductVariantModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        itemsAddedTextField.text = "0"
        itemsAddedTextField.delegate = self
        itemsAddedTextField.returnKeyType = .Done
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupView(item: PackItemModel) {
        itemsAddedTextField.text = "\(item.tempQuantity)"
        itemTitleLabel.text = item.product.variants[0].presentation
        itemSubtitleLabel.text = ""
        let b:String = String(format:"%.2f", item.product.variants[0].price/100)
        itemPriceLabel.text = "$\(b)"
        
        if let itemImage = item.product.variants[0].imagePath {
            
            itemImageView.kf_setImageWithURL(NSURL(string: itemImage)!, placeholderImage: nil)
            
            //            itemImageView.load(itemImage, placeholder: nil, completionHandler: { (url, image, error, cache) -> Void in
            //                if error == nil {
            //                    self.itemImageView.image = image
            //                }
            //            })
        } else {
            self.itemImageView.image = nil
        }
        
        self.packItem = item
        
        self.layoutIfNeeded()
    }
    
    func setupVariant(variant: ProductVariantModel!) {
        self.variant = variant
        
        itemsAddedTextField.text = "\(variant.itemsInCart)"
        itemTitleLabel.text = variant.presentation
        itemSubtitleLabel.text = ""
        let b:String = String(format:"%.2f", variant.price/100)
        itemPriceLabel.text = "$\(b)"
        
        if let itemImage = variant.imagePath {
            itemImageView.kf_setImageWithURL(NSURL(string: itemImage)!, placeholderImage: nil)
            //            itemImageView.load(itemImage, placeholder: nil, completionHandler: { (url, image, error, cache) -> Void in
            //                if error == nil {
            //                    self.itemImageView.image = image
            //                }
            //            })
        } else {
            self.itemImageView.image = nil
        }
        self.layoutIfNeeded()
    }
    
    @IBAction func addItemPressed(sender: AnyObject) {
        
        if let v = self.variant {
            
            if SessionManager.getAccessToken() == nil {
                print("login")
                NSNotificationCenter.defaultCenter().postNotificationName(KlinkRevealViewController.NOT_LOGGED_IN, object: nil)
                return
            }
            
            if itemsAddedTextField.text != "" {
                
                let currentItems = Int(itemsAddedTextField.text!)! + 1
                itemsAddedTextField.text = "\(currentItems)"
                v.itemsInCart++
                Cart.getCart()?.addItem(v, quantity: 1)
                
            } else {
                itemsAddedTextField.text = "0"
            }
            
        } else {
            let currentItems = Int(itemsAddedTextField.text!)! + 1
            itemsAddedTextField.text = "\(currentItems)"
            self.packItem?.tempQuantity = currentItems
            delegate?.quantityChanged()
        }
    }
    
    @IBAction func removeItemPressed(sender: AnyObject) {
        //        print("remove pressed")
        if let v = self.variant {
            if SessionManager.getAccessToken() == nil {
                print("login")
                NSNotificationCenter.defaultCenter().postNotificationName(KlinkRevealViewController.NOT_LOGGED_IN, object: nil)
                //                print("remove pressed, not logged in")
                return
            }
            
            if itemsAddedTextField.text != "" {
                let currentItems = Int(itemsAddedTextField.text!)! - 1
                //            print("remove pressed, current items: \(currentItems)")
                if !(currentItems < 0) {
                    if v.itemsInCart - 1 >= 0 {
                        //                    print("remove pressed, current items in cart: \(v.itemsInCart)")
                        Cart.getCart()?.removeItem(v)
                    }
                    itemsAddedTextField.text = "\(currentItems)"
                    v.itemsInCart--
                }
            
            }
        } else {
            let currentItems = Int(itemsAddedTextField.text!)! - 1
            if !(currentItems < 0) {
                itemsAddedTextField.text = "\(currentItems)"
                self.packItem?.tempQuantity = currentItems
                delegate?.quantityChanged()
            }
        }
    }
    
    private func changeQuantity() {
        
        var result = Int(itemsAddedTextField.text!)! - quantity
        
        if result > 0 {
            if let v = self.variant {
                
                if SessionManager.getAccessToken() == nil {
                    print("login")
                    NSNotificationCenter.defaultCenter().postNotificationName(KlinkRevealViewController.NOT_LOGGED_IN, object: nil)
                    return
                }
                
                v.itemsInCart = v.itemsInCart + result
                
                Cart.getCart()?.addItem(v, quantity: result)
                
            } else {
                
                self.packItem?.tempQuantity = result
                delegate?.quantityChanged()
            }
            
        } else if result < 0 {
            
            result *= -1
            
            if let v = self.variant {
                if SessionManager.getAccessToken() == nil {
                    NSNotificationCenter.defaultCenter().postNotificationName(KlinkRevealViewController.NOT_LOGGED_IN, object: nil)
                    return
                }
                if v.itemsInCart - result >= 0 {
                    for _ in 1...result {
                        Cart.getCart()?.removeItem(v)
                    }
                }
                
                v.itemsInCart = v.itemsInCart - result
            } else {
                self.packItem?.tempQuantity = Int(itemsAddedTextField.text!)!
                delegate?.quantityChanged()
            }
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
        if itemsAddedTextField.text!.characters.count > 0 {
            if Int(itemsAddedTextField.text!)! > -1 {
                self.changeQuantity()
            }
        } else {
            itemsAddedTextField.text! = "\(quantity)"
        }
    }
    
    
}
