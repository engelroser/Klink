//
//  ProductFilterViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 13/11/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit

protocol ProductFilterViewDelegate {
    func didChangeSubcategories()
}

class ProductFilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var navigationBackground: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var navigationTitle: UINavigationItem!
    
    let ProductFilterCellIdentifier = "ProductFilterCellIdentifier"
    
    var category:CategoryModel!
    var selectedSubcategories:[Int] = []
    
    var delegate:ProductFilterViewDelegate?
    
    init(category: CategoryModel!) {
        super.init(nibName: "ProductFilterViewController", bundle: nil)
        self.category = category
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationBackground.backgroundColor = UIColor.kvfKlinkOrangeColor()
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: "cancelPressed")
        
        navigationTitle.leftBarButtonItem = cancelButton
        navigationTitle.setKlinkTitleView(category.name)
        
        setUpTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerNib(UINib(nibName: "ProductFilterTableViewCell", bundle: nil), forCellReuseIdentifier: ProductFilterCellIdentifier)
        tableView.backgroundColor = UIColor.clearColor()
        tableView.backgroundView = nil
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        tableView.separatorColor = UIColor.whiteColor().colorWithAlphaComponent(0.25)
        tableView.allowsMultipleSelection = true
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        
//        for (index, c) in self.category.subcategories.enumerate() {
//            if c.selectedAsSubcategory {
//                
//                
//                let path = NSIndexPath(forRow: index, inSection: 0)
//                tableView.selectRowAtIndexPath(path, animated: false, scrollPosition: .Top)
//            }
//        }
        
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.category.subcategories.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell: ProductFilterTableViewCell = tableView.dequeueReusableCellWithIdentifier(ProductFilterCellIdentifier, forIndexPath: indexPath) as! ProductFilterTableViewCell
            cell.titleLabel.text = "Show all \(self.category.name)"
            cell.selectCircle.hidden = true
            return cell

        }
        
        let cell: ProductFilterTableViewCell = tableView.dequeueReusableCellWithIdentifier(ProductFilterCellIdentifier, forIndexPath: indexPath) as! ProductFilterTableViewCell
        
        let c = self.category.subcategories[indexPath.row - 1]
        
        cell.setupView(c)
        cell.selectCircle.hidden = false
        
        if c.selectedAsSubcategory {
            cell.fillCircleView()
            print("Set selevted \(c.name)")
        } else {
            cell.emptyCircleView()
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            print("show all")
            
            for c in self.category.subcategories {
                c.selectedAsSubcategory = false
            }
            
            donePressed("")
            
        } else {
            let c = self.category.subcategories[indexPath.row - 1]
            c.selectedAsSubcategory = !c.selectedAsSubcategory
            tableView.reloadData()
        }
    }
    
    func cancelPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func donePressed(sender: AnyObject) {
        delegate?.didChangeSubcategories()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
