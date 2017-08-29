//
//  FirstRunViewController.swift
//  Klink
//
//  Created by Mobile App Dev on 24/08/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit

class FirstRunViewController: BaseViewController, UIPageViewControllerDataSource {

    var pageViewController: UIPageViewController = UIPageViewController()
    
    init() {
        super.init(nibName: "FirstRunViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.view!.frame = self.view.bounds
        // Do any additional setup after loading the view.
        pageViewController.setViewControllers([TutorialChildViewController(text: nil, image: nil, foregroundImage: nil)], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        
        self.addChildViewController(pageViewController)
        self.view!.addSubview(pageViewController.view!)
        pageViewController.didMoveToParentViewController(self)
        
        pageViewController.view.backgroundColor = UIColor.redColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIPageViewControllerDataSource
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let childController = viewController as! TutorialChildViewController
        
        var index = childController.index
        
        if(index == 3) {
            return nil
        }
        index++
//        print("return \(index)")
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let childController = viewController as! TutorialChildViewController
        
        var index = childController.index
        
        if(index == 0) {
            return nil
        }
        index--
//        print("return \(index)")
        return viewControllerAtIndex(index)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 4
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    // MARK: - Helper Methods
    
    func viewControllerAtIndex(index: Int) -> TutorialChildViewController {
        return TutorialChildViewController(text: nil, image: nil, foregroundImage: nil)
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
