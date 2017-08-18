//
//  CartTabBarController.swift
//  Klink
//
//  Created by Mobile App Dev on 24/09/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit

class CartTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tabBar.tintColor = UIColor.clearColor()
        
        let cartVC = CartViewController()
        cartVC.view.backgroundColor = UIColor.clearColor()
        cartVC.view.frame = tabBar.bounds
        
        tabBar.addSubview(cartVC.view)
        
        tabBar.translucent = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
