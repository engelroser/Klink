//
//  CheckoutReviewViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 12/11/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit
import SwiftyJSON

class CheckoutReviewViewController: UIViewController {
    
    static let notif = "CheckoutReviewViewController"
    
    var card:CreditCard!
    var address:ShippingModel!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var titleAddress: UILabel!
    @IBOutlet var subtitleAddress: UILabel!
    @IBOutlet var instructionsLabel: UILabel!
    @IBOutlet var cardnameLabel: UILabel!
    @IBOutlet var cardNumberLabel: UILabel!
    @IBOutlet var cartTitleLabel: UILabel!
    @IBOutlet var cartTotalLabel: UILabel!
    
    init(card:CreditCard?, address: ShippingModel) {
        super.init(nibName: "CheckoutReviewViewController", bundle: nil)
        self.card = card
        self.address = address
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.setKlinkTitleView("REVIEW")
        
        nameLabel.text = address.name
        phoneLabel.text = address.phone
        titleAddress.text = address.address1
        subtitleAddress.text = "\(address.city), \(address.state), \(address.zip)"
        
        instructionsLabel.text = address.instructions
        
        cardnameLabel.text = card.brand
        cardNumberLabel.text = "**** \(card.last4digits)"
        
        cartTitleLabel.text = "Cart Total"
        cartTotalLabel.text = "$\(Cart.getCart()!.total!.prettyPriceInDollars())"
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func finishDeliveryPressed(sender: AnyObject) {
        let shippingAddress:[String:AnyObject] = [
            "full_name" : address.name!,
            "country_code": "US",
            "locality": address.city!,
            "postal_code": address.zip!,
            "administrative_area": "US-\(address.stateCode)",
            "address_line1": address.address1,
            "address_line2": address.address2
        ]
        
        let parameters:[String:AnyObject] = [
            "shippingAddress" : shippingAddress,
            "additional_information" : address.instructions,
            "phone_number" : address.phone
        ]
        
        print("params: \(parameters)")
        
        KlinkAlert.sharedInstance.showLoadingWindow()
        
        APIClient.sharedClient.klinkRequest2(.PUT, URLString: "cart/checkout/", parameters: parameters, authorized: true) { (response) -> Void in
            let result = response.result
            switch result {
            case .Success(_):
                print("success, go to next step")
                APIClient.sharedClient.klinkRequest2(.PUT, URLString: "cart/checkout/finalize/", parameters: parameters, authorized: true) { (response) -> Void in
                    let result = response.result
                    switch result {
                    case .Success(_):
                        KlinkAlert.sharedInstance.hide(0.0, message: "", color: .Success)
                        NSNotificationCenter.defaultCenter().postNotificationName(CheckoutReviewViewController.notif, object: nil)
                        print("gotovo")
                        break
                    case .Failure(let error):
                        if let rawError = error.localizedDescription.dataUsingEncoding(NSUTF8StringEncoding) {
                            let errorLocalized = JSON(data: rawError)
                            KlinkAlert.sharedInstance.hide(.Long, message: errorLocalized["message"].stringValue, color: .Fail)
                        }
                        break
                    }
                }
                
                break

            case .Failure(let error):
                if let rawError = error.localizedDescription.dataUsingEncoding(NSUTF8StringEncoding) {
                    let errorLocalized = JSON(data: rawError)
                    KlinkAlert.sharedInstance.hide(.Long, message: errorLocalized["message"].stringValue, color: .Fail)
                }
                break
            }
            
            
        }
        
    }

}
