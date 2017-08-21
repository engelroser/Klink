//
//  ChangePasswordViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 23/09/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet var currentPasswordTextField: KlinkTextField!
    @IBOutlet var newPasswordTextField: KlinkTextField!
    @IBOutlet var newPasswordRepeatTextField: KlinkTextField!
    
    
    init() {
        super.init(nibName: "ChangePasswordViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.setKlinkTitleView("CHANGE PASSWORD")
        
        let saveButton = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: "saveTapped")
        navigationItem.rightBarButtonItem = saveButton
    }
    
    override func viewDidAppear(animated: Bool) {
        currentPasswordTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper Methods
    
    // MARK: - UIBarButton Actions
    
    func saveTapped() {
        KlinkAlert.sharedInstance.showLoadingWindow()
        if !(currentPasswordTextField.text?.characters.count > 0 &&
            newPasswordTextField.text?.characters.count > 0 &&
            newPasswordRepeatTextField.text?.characters.count > 0) {
                KlinkAlert.sharedInstance.hide(1.5, message: "Please fill out all fields.", color: .Fail)
                return
        }
        
        let passValidator = InputValidator.validPassword(newPasswordTextField.text, pass2: newPasswordRepeatTextField.text)
        if !passValidator.valid {
            KlinkAlert.sharedInstance.hide(1.5, message: passValidator.message, color: .Fail)
            return
        }
        
        SessionManager.currentUser()!.changePassword(currentPasswordTextField.text!, newPassword: newPasswordTextField.text!, newPasswordConfirm: newPasswordRepeatTextField.text!) { (success, message) -> Void in
            if success {
                KlinkAlert.sharedInstance.hide(.Long, message: message, color: .Success)
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                KlinkAlert.sharedInstance.hide(.Long, message: message, color: .Fail)
            }
        }
    }

}
