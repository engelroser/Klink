//
//  AddressSearchTableViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 31/08/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit

@objc protocol AddressSearchTableViewDelegate {
    optional func addressSearchTableView(controller: AddressSearchTableViewController, didSelectAddress address: String)
}

class AddressSearchTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var delegate:AddressSearchTableViewDelegate?
    @IBOutlet var tableView: UITableView!
    let MenuCellIdentifier = "AddressCellIdentifier"
    
    private var suggestions:[String] = []
    private var savedAddresses:[Address] = []
    private var recentAddresses:[RecentAddress] = []
    
    init() {
        super.init(nibName: "AddressSearchTableViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpTableView()
        
        if let user = SessionManager.currentUser() {
            savedAddresses = user.addresses?.allObjects as! [Address]
        }
        
        recentAddresses = RecentAddress.MR_findAll() as! [RecentAddress]
        
        self.automaticallyAdjustsScrollViewInsets = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper Methods
    
    func setUpTableView() {
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, tableView.bounds.width, CGFloat.min))
        tableView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.70)
        tableView.estimatedRowHeight = 52.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = UIColor.whiteColor().colorWithAlphaComponent(0.25)
        tableView.registerNib(UINib(nibName: "AddressSearchTableViewCell", bundle: nil), forCellReuseIdentifier: MenuCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
        tableView.separatorStyle = .None
        tableView.contentInset = UIEdgeInsetsZero
    }
    
    func setSuggestions(suggestions: [String]) {
        self.suggestions = suggestions
        print("Set up suggestions: \(suggestions)")
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 0
        } else if section == 2 {
            return 0
        }
        return suggestions.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // saved addresses
        if indexPath.section == 1 {
            let cell:AddressSearchTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(MenuCellIdentifier) as! AddressSearchTableViewCell
            let address = savedAddresses[indexPath.row]
            cell.titleLabel.text = "\(address.addressLine1!), \(address.zipCode!), \(address.city!) "
            
            return cell
            
        }
        // recent addresses
        else if indexPath.section == 2 {
            let cell:AddressSearchTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(MenuCellIdentifier) as! AddressSearchTableViewCell
            let address = recentAddresses[indexPath.row]
            cell.titleLabel.text = "\(address.street!), \(address.postalCode!), \(address.locality!)"
            
            return cell
            
        }
        // suggestions from the API
        else {
            let cell:AddressSearchTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(MenuCellIdentifier) as! AddressSearchTableViewCell
            
            cell.titleLabel.text = suggestions[indexPath.row]
            
            return cell
            
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 && savedAddresses.count > 0 {
            return nil
            let view:AccountSectionHeaderView = AccountSectionHeaderView(frame: CGRectMake(0, 0, tableView.frame.size.width, 49))
            view.titleLabel.text = "SAVED ADDRESSES"
            return view
        }
        if section == 1 && recentAddresses.count > 0 {
            return nil
            let view:AccountSectionHeaderView = AccountSectionHeaderView(frame: CGRectMake(0, 0, tableView.frame.size.width, 49))
            view.titleLabel.text = "RECENT ADDRESSES"
            return view
        }
        
        return nil
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if section == 0 && savedAddresses.count > 0 {
//            return 49
//        }
//        
//        if section == 1  && recentAddresses.count > 0 {
//            return 49
//        }
        
        return CGFloat.min
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Did select address search cell at row \(indexPath.row)")
        if indexPath.section == 1 {
            
        } else if indexPath.section == 2 {
            
        } else {
            delegate?.addressSearchTableView!(self, didSelectAddress: suggestions[indexPath.row])
        }
    }
}
