//
//  AppDelegate.swift
//  Klink
//
//  Created by Mobile App Dev on 24/08/15.
//  Copyright (c) 2015 Ars Futura. All rights reserved.
//

import UIKit
import CoreData

import Fabric
import Crashlytics
import Alamofire
import SwiftyJSON
import GoogleMaps
import MagicalRecord
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let updateCheckURLString = Constants.getAPIEndpoint()+"/update-check/"
  
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setUpAppearance()
        showNewVersionController(showAlertOnAppear: false)
        return true
    }
  
    internal func beginNormalFlow() {
        debugPrint("API ENDPOINT: "+Constants.getAPIEndpoint())
        setupFrameworks()
        if let token = SessionManager.getAccessToken() {
          debugPrint("Token is: \(token)")
          User.getUserProfile({ (success) -> Void in
          })
          Cart.syncCart()
        } else {
          Cart.createLocalCart()
        }
        if let refToken = SessionManager.getRefreshToken() {
          debugPrint("Refresh is: \(refToken)")
        }
        
        if let _ = SessionManager.firstTimeRun() {
          window?.rootViewController = KlinkRevealViewController()
        } else {
          window?.rootViewController = TutorialMainViewController()
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        checkForUpdates()
        // FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        MagicalRecord.cleanUp()
        self.saveContext()
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return true
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "co.arsfutura.CoreDataSample" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Klink", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Klink")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch  {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    // MARK: - Helper Methods
    
    func setUpAppearance() {
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().barTintColor = UIColor.kvfKlinkOrangeColor()
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().setBackgroundImage(
            UIImage(),
            forBarPosition: .Any,
            barMetrics: .Default)
        UINavigationBar.appearance().shadowImage = UIImage()
        
        let font = UIFont(name: "Gotham-Medium", size: 16.0)!
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName: font]
        UIBarButtonItem.appearance()
            .setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Gotham-Book", size: 14.0)!],
                forState: UIControlState.Normal)
        
        let attr = NSDictionary(object: UIFont(name: "Gotham-Book", size: 13.0)!, forKey: NSFontAttributeName)
        UISegmentedControl.appearance().setTitleTextAttributes((attr as! [NSObject : AnyObject]), forState: .Normal)
        
        UITextField.appearance().keyboardAppearance = .Dark
    }
    
    func currentAppVersion() -> String {
        return NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as! String
    }
  
    func currentShortAppVersion() -> String {
      return NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
    }
  
    func setupFrameworks() {
        Fabric.with([Crashlytics()])
        GMSServices.provideAPIKey("AIzaSyD4g7brGFGx4zVHnWrqGMohFp4hsFB1A8g")
        MagicalRecord.setupCoreDataStack()
        Stripe.setDefaultPublishableKey(Constants.getStripeLiveKey())
    }
  
    // This function doesn't use APIClient in order to avoid setting API Endpoint 
    func checkForUpdates() {
      Alamofire.request(.GET, updateCheckURLString, parameters: nil)
        .validate()
        .responseJSON { response in
          switch response.result {
          case .Success(let json):
            if let dictionary = json as? [String: AnyObject]{
              if let minSupportedAPIVersion = dictionary[Constants.tagJSONIOS] as? String {
                let compareResult = minSupportedAPIVersion.compare(self.currentShortAppVersion(), options: NSStringCompareOptions.NumericSearch)
                if compareResult == .OrderedDescending {
                  self.showNewVersionController(showAlertOnAppear: true)
                  return
                }
                if let devOverridesDictionary = dictionary[Constants.tagJSONDevOverrides] as? [String: AnyObject] {
                  if let devVersions = devOverridesDictionary[Constants.tagJSONIOS] as? [String] {
                    if devVersions.contains(self.currentShortAppVersion()) {
                      // MARK: Very important point. Change appMode only for itunesconnect review.
                      Constants.appMode = .DEV
                    }
                  }
                }
              }
            }
            NSNotificationCenter.defaultCenter().postNotificationName(Constants.klinkAppHasNoUpdatesNotification,object: nil)
          case .Failure(let error):
            NSNotificationCenter.defaultCenter().postNotificationName(Constants.klinkAppHasNoUpdatesNotification,object: nil)
            print(error)
          }
      }
    }
    
    func showNewVersionController(showAlertOnAppear showAlert: Bool) {
      let navigationController = UINavigationController()
      let controller = NewVersionViewController(nibName: "NewVersionViewController", bundle: nil)
      controller.showAlertOnAppear = showAlert
      navigationController.viewControllers = [controller]
      window?.rootViewController = navigationController
    }

}

