//
//  LoginAnimations.swift
//  InterAPPt
//
//  Created by Ryan Norman on 10/5/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import Foundation

class LoginAnimations {
    var loginController: LoginController
    var view: UIView
    
    init(loginController: LoginController) {
        self.loginController = loginController
        self.view = loginController.view
    }
    
    func showLoginViews(duration: NSTimeInterval = 1.2, completion: (complete: Bool) -> () = {(value: Bool) in}) {
        let stagger = 0.1
        let slideDuration = duration - stagger * 4
        slideInView(loginController.interAPPtLabel, duration: slideDuration, delay: 0)
        slideInView(loginController.facebookLoginView, duration: slideDuration, delay: stagger * 2)
        slideInView(loginController.twitterLoginView, duration: slideDuration, delay: stagger * 3)
        slideInView(loginController.emailLoginView, duration: slideDuration, delay: stagger * 4, completion: completion)
    }
    
    func slideInView(view: UIView, duration: NSTimeInterval, delay: NSTimeInterval, completion: (complete: Bool) -> () = {(value: Bool) in}) {
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            let frame = view.frame;
            view.frame = CGRectMake(25, frame.origin.y, frame.size.width, frame.size.height)
            view.alpha = 1
        }, completion: completion)
    }
    
    func slideOutView(view: UIView) {
        UIView.animateWithDuration(0.6, animations: { () -> Void in
            let frame = view.frame;
            view.frame = CGRectMake(frame.size.width * -1, frame.origin.y, frame.size.width, frame.size.height)
            view.alpha = 0
            })
    }
    
    func showSigningIn(completion: (complete: Bool) -> () = {(value: Bool) in}) {
        loginController.signingInShimmer.shimmering = true
        loginController.signingInLabel.hidden = false
        
        slideOutView(loginController.facebookLoginView)
        slideOutView(loginController.twitterLoginView)
        slideOutView(loginController.emailLoginView)
        
        UIView.animateWithDuration(0.5, delay: 0.2, options: UIViewAnimationOptions.CurveLinear, animations: {
            let lFrame = self.loginController.signingInLabel.frame
            self.loginController.signingInLabel.alpha = 1
            }, completion: completion)
    }
    
    func showSignedIn(visibleLogo: Bool, completion: (complete: Bool) -> () = {(value: Bool) in}) {
        let lController = loginController
        let frame = lController.interAPPtLabel.frame;
        
        if visibleLogo {
            lController.interAPPtLabel.frame = CGRectMake(view.frame.width, 60, frame.width, frame.height)
        }
        
        lController.signingInShimmer.shimmering = false
        UIView.animateWithDuration(0.8, animations: {
            lController.interAPPtLabel.alpha = 1.0
            lController.interAPPtLabel.frame = CGRectMake(25, 60, frame.size.width, frame.size.height)
            
            lController.profileImage.alpha = 1.0
            lController.profileImage.frame = CGRectMake(25, self.view.center.y - 40, 80, 80)
            
            lController.signingInLabel.alpha = 0
            
            lController.facebookLoginView.alpha = 0
        })
        
        lController.welcomeLabel.text = "Welcome\n\(lController.currentUser.name)"
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            
            lController.welcomeLabel.alpha = 1.0
            let frame = lController.welcomeLabel.frame
            lController.welcomeLabel.frame = CGRectMake(25, self.view.center.y + 100, frame.size.width, frame.size.height)
            }, completion: completion)
    }
}
