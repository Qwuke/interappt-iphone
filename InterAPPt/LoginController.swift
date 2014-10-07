//
//  ViewController.swift
//  InterAPPt
//
//  Created by Ryan Norman on 8/31/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

class LoginController: UIViewController, LoginButtonDelegate {
    
    var interAPPtLabel: UILabel!
    var interAPPtLogo: UIImageView!
    var backgroundImage: UIImageView!
    var facebookLoginView: FacebookLoginButton!
    var twitterLoginView: LoginButton!
    var emailLoginView: LoginButton!
    var profileImage: UIImageView!
    var welcomeLabel: UILabel!
    var signingInShimmer: FBShimmeringView!
    var signingInLabel: UILabel!
    var currentUser: User!
    var mainController: MainController!
    var loginAnimations: LoginAnimations!
    var loginInterface: LoginViewBuilder!
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginInterface = LoginViewBuilder(loginController: self)
        loginAnimations = LoginAnimations(loginController: self)
        
        addLogoutGestures()
        
        self.currentUser = User.current()
        
        if self.currentUser == nil {
            loginAnimations.showLoginViews()
        } else {
            showLoggedInView(true)
        }
    }
    
    func userDidBeginLogin() {
        loginAnimations.showSigningIn()
    }
    
    func userDidLogin(user: User) {
        self.currentUser = user
        showLoggedInView(false)
    }
    
    func showLoggedInView(fromSignIn: Bool) {
        loginInterface.addProfileImage()
        loginAnimations.showSignedIn(fromSignIn) { (complete: Bool) in
            (self.parentViewController as ContainerController).showMainController()
        }
    }
    
    func addLogoutGestures() {
        var logoutGesture = UISwipeGestureRecognizer(target: self, action: Selector("logout"));
        logoutGesture.direction = UISwipeGestureRecognizerDirection.Down;
        self.view.addGestureRecognizer(logoutGesture);
        
        var logoutAndDeleteGesture = UISwipeGestureRecognizer(target: self, action: Selector("logoutAndDelete"));
        logoutAndDeleteGesture.direction = UISwipeGestureRecognizerDirection.Up;
        self.view.addGestureRecognizer(logoutAndDeleteGesture);
    }
    
    func logout() {
        FBSession.activeSession().closeAndClearTokenInformation()
    }
    
    func logoutAndDelete() {
        self.currentUser.destroy({
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.logout();
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

