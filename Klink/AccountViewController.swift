//
//  AccountViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 23/09/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UpdateAddressViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    let UserInfoCellIdentifier = "UserInfoCellIdentifier"
    let SimplyCellIdentifier = "SimplyCellIdentifier"
    let AccountTitleSubtitleCellIdentifier = "AccountTitleSubtitleCellIdentifier"
    let AccountAddNewCellIdentifier = "AccountAddNewCellIdentifier"
    
    let currentUser = SessionManager.currentUser()
    var creditCards:[CreditCard] = []
    var addresses:[Address] = []
    
    let simplyCellTitles = [
        "PASSWORD",
        "KLINK CREDITS: $"
    ]
    
    init() {
        super.init(nibName: "AccountViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setUpTableView()
        
        navigationItem.setKlinkTitleView("ACCOUNT")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print(currentUser)
        print(currentUser?.creditCards)
        creditCards = currentUser?.creditCards?.allObjects as! [CreditCard]
        addresses = (currentUser?.getUserAddresses())!
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper Methods
    
    func setUpTableView() {
        tableView.estimatedRowHeight = 220
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.registerNib(UINib(nibName: "AccountUserInfoTableViewCell", bundle: nil), forCellReuseIdentifier: UserInfoCellIdentifier)
        
        tableView.registerNib(UINib(nibName: "AddressSearchTableViewCell", bundle: nil), forCellReuseIdentifier: SimplyCellIdentifier)
        
        tableView.registerNib(UINib(nibName: "AccountTitleSubtitleTableViewCell", bundle: nil), forCellReuseIdentifier: AccountTitleSubtitleCellIdentifier)
        
        tableView.registerNib(UINib(nibName: "AccountAddNewTableViewCell", bundle: nil), forCellReuseIdentifier: AccountAddNewCellIdentifier)
        
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.backgroundColor = nil
        tableView.separatorColor = UIColor.whiteColor().colorWithAlphaComponent(0.25)
        tableView.separatorStyle = .None
        
        let logoutButtonHolder = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 90))
        let border = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 1))
        border.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.25)
        logoutButtonHolder.addSubview(border)
        
        let logoutButton = BorderedButton(type: UIButtonType.Custom)
        logoutButton.setTitle("LOG OUT", forState: .Normal)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButtonHolder.addSubview(logoutButton)
        logoutButton.addTarget(self, action: "logoutPressed", forControlEvents: .TouchUpInside)
        
        logoutButton.addConstraint(NSLayoutConstraint(item: logoutButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 41))
        
        logoutButton.addConstraint(NSLayoutConstraint(item: logoutButton, attribute: NSLayoutAttribute.Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 121))
        
        logoutButtonHolder.addConstraint(NSLayoutConstraint(item: logoutButton, attribute: .CenterX, relatedBy: .Equal, toItem: logoutButtonHolder, attribute: .CenterX, multiplier: 1, constant: 0))
        
        logoutButtonHolder.addConstraint(NSLayoutConstraint(item: logoutButton, attribute: .CenterY, relatedBy: .Equal, toItem: logoutButtonHolder, attribute: .CenterY, multiplier: 1, constant: 0))
        
        
        tableView.tableFooterView = logoutButtonHolder
    }
    
    // MARK: - Button Actions
    
    func logoutPressed() {
        KlinkAlert.sharedInstance.showLoadingWindow()
        SessionManager.logout { (finished) -> Void in
            KlinkAlert.sharedInstance.hide(.Medium, message: "You are logged out.", color: .Success)
            let navVC = RevealNavigationViewController(rootViewController: AddressSearchViewController())
            self.revealViewController().setFrontViewController(navVC, animated: true)
            (self.revealViewController() as! KlinkRevealViewController).selectedIndex = 0
            
            self.resetDisclaimer()
        }
    }
    
    private func resetDisclaimer() {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setInteger(0, forKey: "DisclaimerHidden")
        userDefaults.synchronize()
        
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            //            return 3 // removed klink credits
            return 2
        }
            // Payment rows
        else if section == 1 {
            return 1 + (creditCards.count)
        } else if section == 2 {
            return 1 + (addresses.count)
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(UserInfoCellIdentifier, forIndexPath: indexPath) as! AccountUserInfoTableViewCell
                cell.backgroundColor = UIColor.clearColor()
                cell.setupView(SessionManager.currentUser()!)
                return cell
            }
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCellWithIdentifier(SimplyCellIdentifier, forIndexPath: indexPath) as! AddressSearchTableViewCell
                cell.titleLabel.text = "PASSWORD"
                cell.bottomBorder.hidden = true
                cell.backgroundColor = UIColor.clearColor()
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell.layoutMargins = UIEdgeInsetsZero
                return cell
            }
            //            if indexPath.row == 2 {
            //                let cell = tableView.dequeueReusableCellWithIdentifier(SimplyCellIdentifier, forIndexPath: indexPath) as! AddressSearchTableViewCell
            //                cell.titleLabel.text = "KLINK CREDITS: $50"
            //                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            //                cell.backgroundColor = UIColor.clearColor()
            //                cell.layoutMargins = UIEdgeInsetsZero
            //                return cell
            //            }
        }
        
        // PAYMENT
        if indexPath.section == 1 {
            if indexPath.row == creditCards.count {
                let cell = tableView.dequeueReusableCellWithIdentifier(AccountAddNewCellIdentifier, forIndexPath: indexPath) as! AccountAddNewTableViewCell
                cell.backgroundColor = UIColor.clearColor()
                cell.layoutMargins = UIEdgeInsetsZero
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(AccountTitleSubtitleCellIdentifier, forIndexPath: indexPath) as! AccountTitleSubtitleTableViewCell
                cell.backgroundColor = UIColor.clearColor()
                cell.setupCreditCardView(creditCards[indexPath.row])
                return cell
            }
        }
        
        // ADDRESSES
        if indexPath.section == 2 {
            
            if indexPath.row == addresses.count {
                let cell = tableView.dequeueReusableCellWithIdentifier(AccountAddNewCellIdentifier, forIndexPath: indexPath) as! AccountAddNewTableViewCell
                cell.backgroundColor = UIColor.clearColor()
                cell.layoutMargins = UIEdgeInsetsZero
                cell.titleLabel.text = "Add new address"
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(AccountTitleSubtitleCellIdentifier, forIndexPath: indexPath) as! AccountTitleSubtitleTableViewCell
                cell.backgroundColor = UIColor.clearColor()
                cell.setupAddressView(addresses[indexPath.row])
                return cell
            }
        }
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier(AccountTitleSubtitleCellIdentifier, forIndexPath: indexPath) as! AccountTitleSubtitleTableViewCell
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 {
            let view:AccountSectionHeaderView = AccountSectionHeaderView(frame: CGRectMake(0, 0, tableView.frame.size.width, 49))
            view.titleLabel.text = "PAYMENT"
            return view
        }
        if section == 2 {
            let view:AccountSectionHeaderView = AccountSectionHeaderView(frame: CGRectMake(0, 0, tableView.frame.size.width, 49))
            view.titleLabel.text = "ADDRESSES"
            return view
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 49
        }
        
        if section == 2 {
            return 49
        }
        
        return CGFloat.min
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let backItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backItem
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                self.navigationController?.pushViewController(UserDetailsViewController(), animated: true)
            } else if indexPath.row == 1 {
                self.navigationController?.pushViewController(ChangePasswordViewController(), animated: true)
            } else if indexPath.row == 2 {
                self.navigationController?.pushViewController(KlinkCreditViewController(), animated: true)
            }
            
        }
            // Credit Cards Section
        else if indexPath.section == 1 {
            if indexPath.row == creditCards.count {
                self.navigationController?.pushViewController(AddCardViewController(), animated: true)
            }else {
                self.navigationController?.pushViewController(CardInfoViewController(card: creditCards[indexPath.row]), animated: true)
            }
            
        }
            // Address Section
        else if indexPath.section == 2 {
            if indexPath.row == addresses.count {
                self.navigationController?.pushViewController(AddAddressViewController(), animated: true)
            } else {
                let updateAddressVC = UpdateAddressViewController(address: addresses[indexPath.row], index: indexPath)
                updateAddressVC.delegate = self
                self.navigationController?.pushViewController(updateAddressVC, animated: true)
            }
        }
    }
    
    // MARK: - UpdateAddressViewDelegate
    
    func deletedAddressAtIndex(address: Address, index: NSIndexPath!) {
        tableView.beginUpdates()
        addresses.removeAtIndex(addresses.indexOf(address)!)
        tableView.deleteRowsAtIndexPaths([index], withRowAnimation: .None)
        tableView.endUpdates()
    }
    
}
