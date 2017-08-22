//
//  CheckoutGiftViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 01/10/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit

class CheckoutGiftViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var messageTextView: UITextView!
    @IBOutlet var messageTextViewHeightConstraint: NSLayoutConstraint!
    
    let messageTextViewPlaceholderText = "Special Message (optional)"
    
    init() {
        super.init(nibName: "CheckoutGiftViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        messageTextView.delegate = self
        
        messageTextView.text = messageTextViewPlaceholderText
        messageTextView.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.4)

    }
    
    override func viewWillAppear(animated: Bool) {
        view.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidBeginEditing(textView: UITextView) {
        if messageTextView.textColor == UIColor.whiteColor().colorWithAlphaComponent(0.4) {
            textView.text = ""
            textView.textColor = UIColor.whiteColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.characters.count == 0{
            textView.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.4)
            textView.text = messageTextViewPlaceholderText
        } else {
            textView.textColor = UIColor.whiteColor()
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        var height = messageTextView.sizeThatFits(CGSizeMake(messageTextView.frame.size.width, CGFloat.max)).height
        
        if height < 72 {
            height = 72
        }
        messageTextViewHeightConstraint.constant = height
    }
}
