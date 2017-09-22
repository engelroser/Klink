//
//  MenuLoggedInViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 08/09/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit

class MenuLoggedInViewController: BaseViewController, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    var revealController:KlinkRevealViewController!
    
    let tableCellTitles = [
        "Home", "Account", "Favourites", "Order History", "Request a Drink", "Klink Credits:"
    ]
    let MenuCellIdentifier = "MenuCellIdentifier"

    init() {
        super.init(nibName: "MenuLoggedInViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        revealController = (self.revealViewController() as! KlinkRevealViewController)
        
        setUpTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper Methods
    
    func setUpTableView() {
        tableView.backgroundColor = UIColor ( red: 0.1059, green: 0.1137, blue: 0.1137, alpha: 1.0 )
        //        tableView.contentInset.top = 30
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.registerNib(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: MenuCellIdentifier)
        tableView.dataSource = self
//        tableView.delegate = self
        tableView.bounces = false
        tableView.reloadData()
        
        let headerView = MenuHeaderView(frame: CGRectMake(0, 0, tableView.frame.size.width, 150))
        
        tableView.tableHeaderView = headerView
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableCellTitles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:MenuTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(MenuCellIdentifier) as! MenuTableViewCell
        
        cell.titleLabel.text = tableCellTitles[indexPath.row]
        
        if indexPath.row == revealController.selectedIndex {
            //            println("set selected \(indexPath.row)")
            
            cell.setSelected(true, animated: false)
            cell.titleLabel.textColor = UIColor.whiteColor()
        } else {
            cell.titleLabel.textColor = UIColor ( red: 0.6588, green: 0.6588, blue: 0.6588, alpha: 1.0 )
        }
        
        return cell
    }
    
}
