//
//  LoginNavigationController.swift
//  Klink
//
//  Created by Mobile App Dev on 02/09/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit

class LoginNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.edgesForExtendedLayout = UIRectEdge.Top
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
