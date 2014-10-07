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
        let containerController = source as ContainerController
        let loginController = containerController.loginController
        let mainController = containerController.mainController
        return LoginToMainControllerTransition(loginController: loginController, mainController: mainController)
    }
}

class LoginToMainControllerTransition: NSObject, UIViewControllerAnimatedTransitioning {
    var profileImage: UIImageView
    var interapptLabel: UILabel
    var bgImageView: UIView
    var navigationControllerView: UIView
    var animatingView: UIView!
    
    init(loginController: LoginController, mainController: MainController) {
        self.profileImage = loginController.profileImage
        self.interapptLabel = loginController.interAPPtLabel
        self.bgImageView = loginController.view
        
        self.navigationControllerView = mainController.view
        self.navigationControllerView.alpha = 0
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning!) {
        self.animatingView = transitionContext.containerView()
        
        self.animatingView.addSubview(self.bgImageView)
        self.animatingView.addSubview(self.navigationControllerView)
        self.animatingView.addSubview(self.profileImage)
        self.animatingView.addSubview(self.interapptLabel)
        
        UIView.animateWithDuration(0.75, delay: 0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
            self.profileImage.frame = CGRectMake(16, 27, 30, 30)
            self.interapptLabel.frame = CGRectOffset(self.interapptLabel.frame, 10.2, self.interapptLabel.frame.origin.y * -1 + 14.0)
            self.interapptLabel.transform = CGAffineTransformScale(self.interapptLabel.transform, 0.500, 0.500);
            
            }) { (completion: Bool) -> Void in
                
                self.profileImage.layer.cornerRadius = 15
                
                UIView.transitionWithView(self.interapptLabel, duration: 0.25, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                    self.interapptLabel.textColor = UIColor(red: 167/255, green: 224/255, blue: 9/255, alpha: 1)
                    self.bgImageView.alpha = 0
                    self.navigationControllerView.alpha = 1
                    }) { (completion: Bool) -> Void in
                        transitionContext.completeTransition(true)
                }
        }
        
        var cornerRadiusAnim: CABasicAnimation = CABasicAnimation(keyPath: "cornerRadius")
        cornerRadiusAnim.fromValue = self.profileImage.layer.cornerRadius
        cornerRadiusAnim.toValue = 15
        
        var borderWidthAnim: CABasicAnimation = CABasicAnimation(keyPath: "borderWidth")
        borderWidthAnim.fromValue = self.profileImage.layer.borderWidth
        borderWidthAnim.toValue = 1
        
        var group: CAAnimationGroup = CAAnimationGroup()
        group.fillMode = kCAFillModeForwards
        group.removedOnCompletion = false
        group.duration = 0.75
        group.animations = [cornerRadiusAnim, borderWidthAnim];
        group.delegate = self
        
        self.profileImage.layer.addAnimation(group, forKey: "ProfileImageAnim")
    }
    
    func animationEnded(transitionCompleted: Bool) {
        self.animatingView.hidden = true;
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning!) -> NSTimeInterval {
        return NSTimeInterval(1)
    }
}
