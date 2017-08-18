//
//  CartTotalPricingTableViewCell.swift
//  Klink
//
//  Created by Mobile App Dev on 28/09/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit

protocol CartTotalPricingCellDelegate: NSObjectProtocol {
    func didPressScheduleDelivery()
    func didPressPromoCode()
    func didPressSendAsAGift()
    func updateTip(tip: Double!)
}

class CartTotalPricingTableViewCell: KlinkBaseTableViewCell, UITextFieldDelegate {

    @IBOutlet var sendAsGift: BorderedButton!
    @IBOutlet var tipPercentageSegment: UISegmentedControl!
    @IBOutlet weak var scheduleDeliveryTimeButton: BorderedButton!
    
    @IBOutlet var tipTextField: UITextField!
    weak var delegate:CartTotalPricingCellDelegate?
    @IBOutlet var subtotalLabel: KLLabel!
    @IBOutlet var deliveryLabel: KLLabel!
    @IBOutlet var taxLabel: KLLabel!
    @IBOutlet var discountLabel: KLLabel!
    @IBOutlet var tipLabel: KLLabel!
    @IBOutlet var totalLabel: KLLabel!
    
    var currentTip:String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        tipTextField.borderStyle = .None
        tipTextField.layer.cornerRadius = 4.0
        tipTextField.layer.borderColor = UIColor.whiteColor().CGColor
        tipTextField.layer.borderWidth = 1.0
        tipTextField.layer.masksToBounds = true
        tipTextField.delegate = self
        
        sendAsGift.setTitleColor(UIColor.blackColor(), forState: .Selected)
        sendAsGift.setBackgroundImage(UIImage.imageWithColor(UIColor.whiteColor()), forState: .Selected)
        
        tipTextField.addTarget(self, action: #selector(CartTotalPricingTableViewCell.textDidChange), forControlEvents: .EditingChanged)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView() {
        if let cart = Cart.getCart() {
            taxLabel.text = cart.taxTotal?.prettyPriceInDollars()
            discountLabel.text = cart.promotionTotal?.prettyPriceInDollars()
            tipLabel.text = cart.tipTotal?.prettyPriceInDollars()
            
            print("Cart total: \(cart.total)")
            
            totalLabel.text = cart.total?.prettyPriceInDollars()
            deliveryLabel.text = cart.shippingTotal?.prettyPriceInDollars()
            subtotalLabel.text = cart.itemsTotal?.prettyPriceInDollars()
            
            if let tip = cart.tipTotal {
                tipTextField.text = "\(tip.prettyPriceInDollars())"
                currentTip = tipTextField.text
                tipPercentageSegment.selectedSegmentIndex = -1
            }
        }
    }
    
    @IBAction func sendAsAGiftPressed(sender: AnyObject) {
        delegate?.didPressSendAsAGift()
        sendAsGift.selected = !sendAsGift.selected
    }
    
    @IBAction func promoCodePressed(sender: AnyObject) {
        delegate?.didPressPromoCode()
    }

    @IBAction func scheduleDeliveryPressed(sender: AnyObject) {
        delegate?.didPressScheduleDelivery()
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
//        NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
//        text = [text stringByReplacingOccurrencesOfString:@"." withString:@""];
//        double number = [text intValue] * 0.01;
//        textField.text = [NSString stringWithFormat:@"%.2lf", number];
        
//        NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//        var text:NSString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
//        let arrayOfString:NSArray = text.componentsSeparatedByString(".")
//        
////        NSArray  *arrayOfString = [newString componentsSeparatedByString:@"."];
//        
//        if ( arrayOfString.count > 2 ) {
//            return false
//        }
//        
//        return true
        
        // Update the string in the text input
//        NSMutableString* currentString = [NSMutableString stringWithString:textField.text];
//        [currentString replaceCharactersInRange:range withString:string];
//        // Strip out the decimal separator
//        [currentString replaceOccurrencesOfString:self.decimalSeparator withString:@""
//        options:NSLiteralSearch range:NSMakeRange(0, [currentString length])];
//        // Generate a new string for the text input
        
//        int currentValue = [currentString intValue];
//        NSString* format = [NSString stringWithFormat:@"%%.%df", self.maximumFractionDigits];
//        double minorUnitsPerMajor = pow(10, self.maximumFractionDigits);
//        NSString* newString = [NSString stringWithFormat:format, currentValue/minorUnitsPerMajor];
//        textField.text = newString;
//        return NO;
        
        
        var text:String = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        print("TEXT \(text)")
        
        text = text.stringByReplacingOccurrencesOfString(".", withString: "")
        
        print("TEXT \(text)")
        
        let a = Int(text)
        print("INT \(a)")
        
        if a < 10000000 {
            let number:Double = Double(a!) * 0.01
            
            tipTextField.text = String(format: "%.2f", number)
        }
        
        return false
    }

    func textFieldDidEndEditing(textField: UITextField) {
        print("Endedddddd")
        
        if textField.text == currentTip {
            print("isto")
        } else {
            print("asdfasdf 343894")
            
            let tip = Double(tipTextField.text!)
            
            delegate?.updateTip(tip)
        }
    }
    
    
    @IBAction func percentageChanged(sender: AnyObject) {
//        print("\(tipPercentageSegment.selectedSegmentIndex)")
        
        var percentage:Double = 0.0
        switch tipPercentageSegment.selectedSegmentIndex {
        case 0:
            percentage = 0.1
            break
        case 1:
            percentage = 0.15
            break
        case 2:
            percentage = 0.2
            break
        default:
            percentage = 0.0
            break
        }
        
        if let cart = Cart.getCart() {

            let tip = (cart.itemsTotal?.doubleValue)! / 100 * percentage
            delegate?.updateTip(tip)
        }
        
        
    }
    
    
    func textDidChange() {
        print("did change")
        
    }
    
}
