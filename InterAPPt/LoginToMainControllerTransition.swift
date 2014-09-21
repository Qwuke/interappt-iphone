//
//  LoginToMainControllerTransition.swift
//  InterAPPt
//
//  Created by Ryan Norman on 9/21/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

class LoginToMainControllerTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController!, presentingController presenting: UIViewController!, sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        return LoginToMainControllerTransition()
    }
}

class LoginToMainControllerTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func animateTransition(transitionContext: UIViewControllerContextTransitioning!) {
        
    }
    
    func animationEnded(transitionCompleted: Bool) {
        
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning!) -> NSTimeInterval {
        return NSTimeInterval(1)
    }
}
