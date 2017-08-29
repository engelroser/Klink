//
//  FeaturedViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 22/09/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit

class FeaturedViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var cartContainer: UIView!
    let cartVC = CartViewController()
    let FeaturedCellIdentifier = "FeaturedCellIdentifier"
    
    init() {
        super.init(nibName: "FeaturedViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.navigationController?.navigationBar.translucent = false
//        addBlurEffect()
        
        self.navigationItem.setKlinkTitleView("FEATURED")
        
        setUpTableView()
        let searchIcon = UIBarButtonItem(image: UIImage(named: "navigation-search-icon"), style: UIBarButtonItemStyle.Plain, target: self, action: "searchTapped")
        
        self.navigationItem.rightBarButtonItem = searchIcon
        
        cartVC.view.frame = cartContainer.bounds
        cartContainer.addSubview(cartVC.view)
        cartVC.view.backgroundColor = UIColor.clearColor()
        self.addChildViewController(cartVC)
        cartVC.didMoveToParentViewController(self)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper Methods
    
    func setUpTableView() {
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 48, 0)
//        tableView.contentOffset = CGPointMake(0, -64)
        tableView.dataSource = self
        tableView.registerNib(UINib(nibName: "FeaturedTableViewCell", bundle: nil), forCellReuseIdentifier: FeaturedCellIdentifier)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 180
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
    }
    
    func searchTapped() {
        self.presentViewController(SearchViewController(), animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(FeaturedCellIdentifier, forIndexPath: indexPath) as! FeaturedTableViewCell
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
