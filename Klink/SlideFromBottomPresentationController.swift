//
//  SlideFromBottom.swift
//  Klink
//
//  Created by Mobile App Dev on 28/09/15.
//  Copyright © 2015 Ars Futura. All rights reserved.
//

import UIKit

class SlideFromBottomPresentationController: UIPresentationController {

    var dimmingView: UIView?
    
    override func presentationTransitionWillBegin() {
        // Add the dimming view and the presented view to the heirarchy
        self.dimmingView = UIView(frame: (self.containerView?.bounds)!)
        dimmingView?.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        self.dimmingView!.alpha = 0.0
        
        self.containerView!.addSubview(self.dimmingView!)
        self.containerView!.addSubview(self.presentedView()!)
        
        // Fade in the dimming view alongside the transition
        let transitionCoordinator = self.presentingViewController.transitionCoordinator()
        transitionCoordinator!.animateAlongsideTransition({(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
            self.dimmingView!.alpha  = 1.0
            }, completion:nil)
    }
    
    override func presentationTransitionDidEnd(completed: Bool)  {
        // If the presentation didn't complete, remove the dimming view
        if !completed {
            self.dimmingView!.removeFromSuperview()
        }
    }
    
    override func dismissalTransitionWillBegin()  {
        // Fade out the dimming view alongside the transition
        let transitionCoordinator = self.presentingViewController.transitionCoordinator()
        transitionCoordinator!.animateAlongsideTransition({(context: UIViewControllerTransitionCoordinatorContext!) -> Void in
            self.dimmingView!.alpha  = 0.0
            }, completion:nil)
    }
    
    override func dismissalTransitionDidEnd(completed: Bool) {
        // If the dismissal completed, remove the dimming view
        if completed {
            self.dimmingView!.removeFromSuperview()
        }
    }
    
    override func frameOfPresentedViewInContainerView() -> CGRect {
        // We don't want the presented view to fill the whole container view, so inset it's frame
        var frame = self.containerView!.bounds;
        frame = CGRectInset(frame, 20.0, 0)
        return frame
    }
    

    
}
