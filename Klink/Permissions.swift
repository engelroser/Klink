//
//  Permissions.swift
//  Klink
//
//  Created by Mobile App Developer on 07/10/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import Foundation
import AVFoundation

class Permissions {
    
    class func cameraPermissions(controller: UIViewController!, completion:(approved: Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatusForMediaType(AVMediaTypeVideo)
        if(status == .Authorized) { // authorized
            completion(approved: true)
        }
        else if(status == .Denied){ // denied
            completion(approved: false)
        }
        else if(status == .Restricted){ // restricted
            completion(approved: false)
        }
        else if(status == .NotDetermined){ // not determined
            
            AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: { (granted) -> Void in
                if granted {
                    completion(approved: true)
                } else {
                    completion(approved: false)
                }
            })
        }
    }
    
    class func alertPermissionNotAllowed(controller: UIViewController!, message: String?) -> Void {
        let alertVC = UIAlertController(title: "", message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertVC.addAction(okAction)
        controller.presentViewController(alertVC, animated: true, completion: nil)
    }
    
}
