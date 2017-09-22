//
//  MenuViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 24/08/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit

class MenuViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, MenuHeaderDelegate, LoginViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    var revealController:KlinkRevealViewController!
    
    var userLoggedIn = true
    var addressSeclected = false
    
    let MenuCellIdentifier = "MenuCellIdentifier"
    let AddressCellIdentifier = "AddressCellIdentifier"
    
    let loggedOutCellTitles = [
        "Home",
//        "Request a Drink",
        "Log in",
        "Support",
        "About"
    ]
    let loggedInCellTitles = [
        "Home", "Account",
        "Support",
        "About" //, "Favourites", "Order History", "Request a Drink", "Klink Credits:"
    ]
    
    let logInDescription:String = "Log in to save your favourite items, see your order history and earn credits toward free drinks."
    
    init() {
        super.init(nibName: "MenuViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor ( red: 0.1059, green: 0.1137, blue: 0.1137, alpha: 1.0 )
        setUpTableView()
        
        revealController = (self.revealViewController() as! KlinkRevealViewController)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MenuViewController.userLoggedOut), name:SessionManager.USER_LOGGED_OUT, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        userLoggedIn = SessionManager.userLoggedIn()
        tableView.reloadData()
    }

    override func viewDidAppear(animated: Bool) {
        
//        println("Menu appeared")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Helper Methods
    
    func userLoggedOut() {
        print("user logged out")
        userLoggedIn = false
        tableView.reloadData()
    }
    
    func setUpTableView() {
        tableView.backgroundColor = UIColor ( red: 0.1059, green: 0.1137, blue: 0.1137, alpha: 1.0 )
//        tableView.contentInset.top = 30
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.registerNib(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: MenuCellIdentifier)
        tableView.registerNib(UINib(nibName: "MenuHeaderTableCell", bundle: nil), forCellReuseIdentifier: AddressCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.bounces = false
        tableView.reloadData()
        
    }
    
    func loggedInCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:MenuTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(MenuCellIdentifier) as! MenuTableViewCell
        let index = addressSeclected ? indexPath.row : indexPath.row - 1
        cell.titleLabel.text = loggedInCellTitles[index]
        
        if index == revealController.selectedIndex {
            cell.setSelected(true, animated: false)
            cell.titleLabel.textColor = UIColor.whiteColor()
        } else {
            cell.titleLabel.textColor = UIColor ( red: 0.6588, green: 0.6588, blue: 0.6588, alpha: 1.0 )
        }
        
        cell.descLabel.text = ""
        
        return cell
    }
    
    func loggedOutCell(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:MenuTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(MenuCellIdentifier) as! MenuTableViewCell
        let index = addressSeclected ? indexPath.row : indexPath.row - 1
        cell.titleLabel.text = loggedOutCellTitles[index]
//        
//        if index == 1 {
//            
//            let style = NSMutableParagraphStyle()
//            style.lineSpacing = 3.0
//            let attText = NSMutableAttributedString(string: logInDescription, attributes: [NSForegroundColorAttributeName: UIColor.unselectedCellText(), NSFontAttributeName: UIFont(name: "Gotham-Book", size: 13.0)!, NSParagraphStyleAttributeName: style])
//            
//            cell.descLabel.attributedText = attText
//        }
        
        if index == revealController.selectedIndex {
            cell.setSelected(true, animated: false)
            cell.titleLabel.textColor = UIColor.whiteColor()
        } else {
            cell.titleLabel.textColor = UIColor ( red: 0.6588, green: 0.6588, blue: 0.6588, alpha: 1.0 )
        }
        
        return cell
    }
    
    func loggedInDidSelectCell(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let index = indexPath.row - 1
        switch(index){
            //Home
        case 0:
            if let _ = SessionManager.currentDeliveryAddress() {
                if index != revealController.selectedIndex {
                    let navVC = RevealNavigationViewController(navigationBarClass: KlinkNavigationBar.self, toolbarClass: nil)
                    navVC.setViewControllers([DiscoverViewController()], animated: false)
                    self.revealViewController().setFrontViewController(navVC, animated: false)
                }
            } else {
                let navVC = RevealNavigationViewController(rootViewController: AddressSearchViewController())
                self.revealViewController().setFrontViewController(navVC, animated: false)
            }
            self.revealViewController().setFrontViewPosition(FrontViewPosition.Left, animated: true)
            revealController.selectedIndex = index
            break
            //Request a Drink
        case 1:
//            if index != revealController.selectedIndex {
                let navVC = RevealNavigationViewController(rootViewController: AccountViewController())
                self.revealViewController().setFrontViewController(navVC, animated: false)
//            }
            self.revealViewController().setFrontViewPosition(FrontViewPosition.Left, animated: true)
            revealController.selectedIndex = index
            break
        case 2:
            revealController.selectedIndex = index
            supportPressed(self)
            break
        case 3:
            revealController.selectedIndex = index
            aboutPressed(self)
            break
        case 4:
            if index != revealController.selectedIndex {
                let navVC = RevealNavigationViewController(rootViewController: RequestDrinkViewController())
                self.revealViewController().setFrontViewController(navVC, animated: false)
            }
            self.revealViewController().setFrontViewPosition(FrontViewPosition.Left, animated: true)
            revealController.selectedIndex = index
            break
        case 5:
            if index != revealController.selectedIndex {
                let navVC = RevealNavigationViewController(rootViewController: KlinkCreditViewController())
                self.revealViewController().setFrontViewController(navVC, animated: false)
            }
            self.revealViewController().setFrontViewPosition(FrontViewPosition.Left, animated: true)
            revealController.selectedIndex = index
            break
        default:
            self.revealViewController().setFrontViewPosition(FrontViewPosition.Left, animated: true)
            revealController.selectedIndex = index
            break
        }
        tableView.reloadData()
    }
    
    func loggedOutDidSelectCell(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let index = indexPath.row - 1
        switch(index){
            //Home
        case 0:
            if let _ = SessionManager.currentDeliveryAddress() {
                if index != revealController.selectedIndex {
                    let navVC = RevealNavigationViewController(navigationBarClass: KlinkNavigationBar.self, toolbarClass: nil)
                    navVC.setViewControllers([DiscoverViewController()], animated: false)
                    self.revealViewController().setFrontViewController(navVC, animated: false)
                }
            } else {
                let navVC = RevealNavigationViewController(rootViewController: AddressSearchViewController())
                 self.revealViewController().setFrontViewController(navVC, animated: false)
            }
            
            self.revealViewController().setFrontViewPosition(FrontViewPosition.Left, animated: true)
            revealController.selectedIndex = index
            break
            //Request a Drink
//        case 1:
//            if index != revealController.selectedIndex {
//                let navVC = RevealNavigationViewController(rootViewController: RequestDrinkViewController())
//                self.revealViewController().setFrontViewController(navVC, animated: false)
//            }
//            self.revealViewController().setFrontViewPosition(FrontViewPosition.Left, animated: true)
//            revealController.selectedIndex = index
//            break
        case 1:
            let loginVC = LoginViewController()
            loginVC.delegate = self
            loginVC.navigationItem.title = "LOG IN"
            let navVC = LoginNavigationController(rootViewController: loginVC)
            self.presentViewController(navVC, animated: true, completion: nil)
            revealController.selectedIndex = index
            break
        case 2:
            supportPressed(self)
            revealController.selectedIndex = index
            break
        case 3:
            aboutPressed(self)
            revealController.selectedIndex = index
            break
        default:
            self.revealViewController().setFrontViewPosition(FrontViewPosition.Left, animated: true)
            revealController.selectedIndex = index
            break
        }
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // TODO if address selected add + 1 for first cell
        var addressSelecetd = 1
//        if let _ = SessionManager.currentDeliveryAddress() {
//            addressSelecetd = 1
//            addressSeclected = true
//            print("have address")
//        } else {
//            addressSeclected = false
//            print("no address")
//            addressSelecetd = 0
//        }
        
        
        if userLoggedIn {
            return loggedInCellTitles.count + addressSelecetd
        }
        
        return loggedOutCellTitles.count + addressSelecetd
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        if addressSeclected {
            if indexPath.row == 0 {
                let cell:MenuHeaderTableCell = self.tableView.dequeueReusableCellWithIdentifier(AddressCellIdentifier) as! MenuHeaderTableCell
                cell.delegate = self
                cell.setupView()
                return cell
            }
//        }
        
        if userLoggedIn {
            
            return loggedInCell(tableView, cellForRowAtIndexPath: indexPath)
        }
        return loggedOutCell(tableView, cellForRowAtIndexPath: indexPath)
    }
    
    // MARK: - UITableView Delegate Methods
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            return
        }
        if userLoggedIn {
            loggedInDidSelectCell(tableView, didSelectRowAtIndexPath: indexPath)
        } else {
            loggedOutDidSelectCell(tableView, didSelectRowAtIndexPath: indexPath)
        }
    }
    
    // MARK: - MenuHeaderDelegate
    
    func didPressEditAddress() {
        let vc = AddressSearchViewController()
        let leftButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "dismissEditAddress")
        vc.navigationItem.leftBarButtonItem = leftButton
        let navVC = UINavigationController(rootViewController: vc)
        
        self.presentViewController(navVC, animated: true, completion: nil)
    }
    
    func didPressShowStoreHours() {
        
    }
    
    func dismissEditAddress() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Button Actions
    
    @IBAction func aboutPressed(sender: AnyObject) {
        let navVC = RevealNavigationViewController(rootViewController: AboutViewController())
        revealController.setFrontViewController(navVC, animated: false)
    
        revealController.setFrontViewPosition(FrontViewPosition.Left, animated: true)
        
//        revealController.selectedIndex = -1
    }

    @IBAction func supportPressed(sender: AnyObject) {
        let navVC = RevealNavigationViewController(rootViewController: SupportViewController())
        revealController.setFrontViewController(navVC, animated: false)
        
        revealController.setFrontViewPosition(FrontViewPosition.Left, animated: true)
        
//        revealController.selectedIndex = -1
    }
    
    // MARK: - LoginViewDelegate
    
    func userDidLoggedIn() {
        self.revealViewController().setFrontViewPosition(FrontViewPosition.Left, animated: true)
        revealController.selectedIndex = 0
        tableView.reloadData()
    }

    func userDidSignedUp() {
        self.revealViewController().setFrontViewPosition(FrontViewPosition.Left, animated: true)
        revealController.selectedIndex = 0
        tableView.reloadData()
    }

}
