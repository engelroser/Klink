//
//  RevealNavigationViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 03/09/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit

class RevealNavigationViewController: BaseNavigationViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
    }

    override init(rootViewController: UIViewController) {
        
        super.init(rootViewController: rootViewController)
        self.setLeftMenuButton(rootViewController.navigationItem)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        for controller in self.viewControllers {
            setLeftMenuButton(controller.navigationItem)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper Methods
    
    func setLeftMenuButton(item: UINavigationItem) {
        if item.leftBarButtonItem == nil {
            item.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu-icon"), style: UIBarButtonItemStyle.Done , target: self, action: "menuButtonPressed:")
            item.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        }
    }
    
    
    func menuButtonPressed(button: UIBarButtonItem) {
        self.revealViewController().revealToggle(self)
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
