//
//  CheckoutPaymentViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 02/10/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit
import Stripe

class CheckoutPaymentViewController: UIViewController, UITextFieldDelegate, MonthYearPickerDelegate, SavedCardsViewDelegate {
    
    @IBOutlet var cardNumberTextField: KlinkTextField!
    @IBOutlet var ccvTextField: KlinkTextField!
    @IBOutlet var expirationDateTextField: KlinkTextField!
    
    var selectedCard:CreditCard?
    var address:ShippingModel?
    
    init(address: ShippingModel) {
        super.init(nibName: "CheckoutPaymentViewController", bundle: nil)
        self.address = address
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.setKlinkTitleView("PAYMENT INFO")
        
        let nextButton = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: "nextPressed")
        navigationItem.rightBarButtonItem = nextButton
        
        let backItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        
        expirationDateTextField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        CardIOUtilities.preload()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nextStep(card: CreditCard) {
        self.navigationController?.pushViewController(CheckoutReviewViewController(card: card, address: address!), animated: true)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == expirationDateTextField {
            view.endEditing(true)
            let vc = MonthYearPickerViewController()
            vc.delegate = self
            presentViewController(vc, animated: true, completion:nil)
            return false
        }
        
        return true
    }
    
    // MARK: - MonthYearPickerDelegate
    
    func monthYearPicker(controller: MonthYearPickerViewController, didSelectDate date: String?) {
        expirationDateTextField.text = date
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Button Actions
    
    func nextPressed() {
        KlinkAlert.sharedInstance.showLoadingWindow()
        
        let card = STPCardParams()
        card.number = cardNumberTextField.text
        
        let expirationDate = expirationDateTextField.text!.componentsSeparatedByString("/")
        
        if expirationDate.count == 2 {
            card.expMonth = UInt(Int(expirationDate[0])!)
            card.expYear = UInt(Int(expirationDate[1])!)
        }
        
//        card.name = cardNameTextField.text
        
//        if card.name == "" {
//            card.name = SessionManager.currentUser()?.fullName
//        }
        
        card.cvc = ccvTextField.text
        
        
        STPAPIClient.sharedClient().createTokenWithCard(card) { (token, error) -> Void in
            if error == nil {
                print("Stripe token: \(token)")
                User.addCreditCard(token!, completion: { (success, card, message) -> Void in
                    if success {
                        let parameters:[String:AnyObject] = [
                            "cardId" : card!.id!
                        ]
                        
                        APIClient.sharedClient.klinkRequest(.POST, URLString: "user/credit-cards/default/", parameters: parameters, authorized: true, completionHandler: { (response) -> Void in
                            
                            let result = response.result
                            switch result {
                            case .Success(_):
                                KlinkAlert.sharedInstance.hide(0.0, message: "", color: .Neutral)
                                print("go next")
                                self.nextStep(card!)
                                break
                            case .Failure(_):
                                KlinkAlert.sharedInstance.hide(.Long, message: "Error occured", color: .Fail)
                                break
                            }
                            
                            
                        })
                    } else {
                        KlinkAlert.sharedInstance.hide(.Long, message: "Error occured.", color: .Fail)
                    }
                })
            } else {
                print("Stripe error: \(error)")
                KlinkAlert.sharedInstance.hide(.Long, message: error?.localizedDescription, color: .Fail)
            }
            
            
        }
    }
    
    @IBAction func useSavedCardPressed(sender: AnyObject) {
        let vc = SavedCardsViewController()
        vc.delegate = self
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    // MARK: - SavedCardsViewDelegate
    
    func didSelectCard(card: CreditCard?) {
        print("delegate")
        
        if let c = card {
            
            KlinkAlert.sharedInstance.showLoadingWindow()
            
            let parameters:[String:AnyObject] = [
                "cardId" : c.id!
            ]
            print("delegatesafsfsdf")
            APIClient.sharedClient.klinkRequest(.POST, URLString: "user/credit-cards/default/", parameters: parameters, authorized: true, completionHandler: { (response) -> Void in
                let result = response.result
                switch result {
                case .Success(_):
                    KlinkAlert.sharedInstance.hide(0.0, message: "", color: .Neutral)
                    print("go next")
                    self.nextStep(card!)
                    break
                case .Failure(_):
                    KlinkAlert.sharedInstance.hide(.Long, message: "Error occured", color: .Fail)
                    break
                }
            })
        }
    }
    

}
