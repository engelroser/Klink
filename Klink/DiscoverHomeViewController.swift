//
//  DiscoverHomeViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 07/09/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit

class DiscoverHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, DiscoverCollectionCellDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    let DiscoverCollectionTableCellIdentifier = "DiscoverCollectionTableCellIdentifier"
    let DiscoverFeaturedCellIdentifier = "DiscoverFeaturedCellIdentifier"
    let LoadingCellIdentifier = "LoadingCellIdentifier"
    var storeID:Int = -1
    var klinkCollections:[CollectionModel] = []
    var loadMore = true
    
    init() {
        super.init(nibName: "DiscoverHomeViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUpTableView()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadCollections", name:SessionManager.DELIVERY_ADDRESS_CHANGED, object: nil)
        loadCollections()
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Helper Methods
    
    func loadCollections() {
//        print("LOAD COLLECTIONS")
        if let id = SessionManager.getCurrentStoreID() {
            CollectionModel.getCollectionsByStore(id, completion: { (collections, error) -> Void in
                if error == nil {
                    self.loadMore = false
                    self.klinkCollections = collections!
                    self.tableView.reloadData()
                } else {
                    
                }
            })
        }
    }
    
    func setUpTableView() {
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(red:(51.0/255.0), green:(51.0/255.0), blue:(51.0/255.0), alpha: 1.0)
        tableView.estimatedRowHeight = 174
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerNib(UINib(nibName: "DiscoverCollectionTableViewCell", bundle: nil), forCellReuseIdentifier: DiscoverCollectionTableCellIdentifier)
        tableView.registerNib(UINib(nibName: "DiscoverFeaturedTableViewCell", bundle: nil), forCellReuseIdentifier:
            DiscoverFeaturedCellIdentifier)
        tableView.registerNib(UINib(nibName: "LoadingTableViewCell", bundle: nil), forCellReuseIdentifier: LoadingCellIdentifier)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.dataSource = self
        tableView.delegate = self
//        tableView.reloadData()
    }
    
    func klinkCollectionsCount() -> Int {
        return Int(ceilf(Float(klinkCollections.count)/Float(2)))
    }
    
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(ceilf(Float(klinkCollections.count)/Float(2))) + 1 // + loading cell
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (klinkCollections.count == 0 || klinkCollectionsCount() == indexPath.row) {
            let cell = tableView.dequeueReusableCellWithIdentifier(LoadingCellIdentifier, forIndexPath: indexPath) as! LoadingTableViewCell
            if loadMore {
                cell.spinner.startAnimating()
            } else {
                cell.spinner.hidden = true
            }
            return cell
        }
        
        let col1 = klinkCollections[indexPath.row * 2]
        var col2:CollectionModel?
        if !(klinkCollections.count - 1 < indexPath.row*2+1) {
            col2 = klinkCollections[indexPath.row * 2 + 1]
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(DiscoverCollectionTableCellIdentifier, forIndexPath: indexPath) as! DiscoverCollectionTableViewCell
        cell.delegate = self
        cell.setupView(col1, collection2: col2)
        return cell
    }
    
    // MARK: - UITableViewDelegate
   
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Did select address search cell at row \(indexPath.row)")
    }

    // MARK: - DiscoverCollectionCellDelegate
    
    func didSelectCollection(collection: CollectionModel!) {
        print("selected :\(collection.name)")
        let backItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        if let parentVC = self.parentViewController {
            parentVC.navigationItem.backBarButtonItem = backItem
        }
        
        self.navigationController?.pushViewController(PacksViewController(collectionModel: collection), animated: true)
    }
}