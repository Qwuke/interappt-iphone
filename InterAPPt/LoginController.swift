//
//  ViewController.swift
//  InterAPPt
//
//  Created by Ryan Norman on 8/31/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

class LoginController: UIViewController, FBLoginViewDelegate {
    
    var interAPPtLabel: UILabel!
    var interAPPtLogo: UIImageView!
    var backgroundImage: UIImageView!
    var facebookLoginView: FBLoginView!
    var profileImage: UIImageView!
    var welcomeLabel: UILabel!
    var signingInShimmer: FBShimmeringView!
    var signingInLabel: UILabel!
    var currentUser: User!
    var savingFacebookUser: Bool!
    var mainController: MainController!
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        savingFacebookUser = false
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.0, target: self, selector: Selector("showLoginView"), userInfo: nil, repeats: false)
        
        addInterAPPtLabel()
        addBackground()
        
        addLogoutGestures();
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
        savingFacebookUser = false
    }
    
    func logoutAndDelete() {
        self.currentUser.destroy({
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.logout();
            }
        })
    }
    
    func showLoginView() {
        addFacebookButton()
        addWelcomeLabel()
        addSigningInIndicator()
        self.view.sendSubviewToBack(self.backgroundImage)
    }
    
    func addSigningInIndicator() {
        self.signingInLabel = UILabel(frame: CGRectMake(self.view.center.x - 45, self.view.center.y - 20, 90, 40))
        self.signingInLabel.text = "Signing In"
        self.signingInLabel.textColor = UIColor.whiteColor()
        self.signingInLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 18)
        self.signingInLabel.textAlignment = NSTextAlignment.Center
        self.signingInLabel.hidden = true
        self.signingInLabel.alpha = 0
        
        self.signingInShimmer = FBShimmeringView(frame: self.signingInLabel.frame)
        self.signingInShimmer.contentView = self.signingInLabel
        self.signingInShimmer.shimmering = false;
        self.view.addSubview(self.signingInShimmer)
    }
    
    func addInterAPPtLogo() {
        self.interAPPtLogo = UIImageView(image: UIImage(named: "logo.png"))
        self.interAPPtLogo.frame = CGRectMake(self.view.center.x - 40, self.view.center.y - 40, 80, 80)
        self.view.addSubview(self.interAPPtLogo)
    }
    
    func addBackground() {
        self.backgroundImage = UIImageView(image: UIImage(named: "Interappt BG2.jpg"))
        self.backgroundImage.frame = self.view.frame
        self.view.addSubview(self.backgroundImage)
    }
    
    func addWelcomeLabel() {
        self.welcomeLabel = UILabel()
        self.welcomeLabel.frame = CGRectMake(self.view.frame.size.width, self.view.center.y + 60, 150, 100)
        self.welcomeLabel.text = "Welcome"
        self.welcomeLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.welcomeLabel.numberOfLines = 0
        self.welcomeLabel.textColor = UIColor.whiteColor()
        self.welcomeLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 24)
        self.welcomeLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(self.welcomeLabel)
        self.welcomeLabel.alpha = 0.0
    }
    
    func addInterAPPtLabel() {
        self.interAPPtLabel = UILabel()
        self.interAPPtLabel.frame = CGRectMake(self.view.center.x - 75, self.view.center.y - 25, 150, 50)
        self.interAPPtLabel.text = "InterAPPt"
        self.interAPPtLabel.textColor = UIColor.whiteColor()
        self.interAPPtLabel.font = UIFont(name: "Mohave-Bold", size: 36.0)
        self.interAPPtLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(self.interAPPtLabel)
        self.interAPPtLabel.alpha = 0.0
    }
    
    func addFacebookButton() {
        self.facebookLoginView = FBLoginView()
        self.facebookLoginView.frame = CGRectMake(self.view.center.x - (self.facebookLoginView.frame.size.width / 2), self.view.center.y + 25, self.facebookLoginView.frame.size.width, self.facebookLoginView.frame.size.height)
        self.facebookLoginView.delegate = self
        self.facebookLoginView.hidden = true
        self.facebookLoginView.readPermissions = ["public_profile", "email", "user_friends"]
        self.view.addSubview(self.facebookLoginView)
        self.facebookLoginView.alpha = 0.0
    }
    
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        println("User Logged In")
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser) {
        if !savingFacebookUser {
            savingFacebookUser = true
            self.currentUser = User.current()
            
            if self.currentUser == nil {
                self.facebookLoginView.hidden = true
                self.signingInShimmer.shimmering = true
                self.signingInLabel.hidden = false

                UIView.animateWithDuration(0.5, delay: 0.2, options: UIViewAnimationOptions.CurveLinear, animations: {
                    self.signingInLabel.alpha = 1
                    }, completion: {
                        (value: Bool) in
                        User.createFromFacebookInfo(user, completion: { (user) -> Void in
                            NSOperationQueue.mainQueue().addOperationWithBlock {
                                self.currentUser = user
                                self.showLoggedInView()
                            }
                        })
                })
                
            } else {
                self.showLoggedInView()
            }
        }
    }
    
    func showLoggedOutView() {
        self.facebookLoginView.hidden = false
        UIView.animateWithDuration(0.8, animations: {
            let interapptFrame = self.interAPPtLabel.frame;
            self.interAPPtLabel.alpha = 1.0
            self.interAPPtLabel.frame = CGRectMake(interapptFrame.origin.x, self.view.center.y - 100, interapptFrame.size.width, interapptFrame.size.height)
            
            let loginFrame = self.facebookLoginView.frame
            self.facebookLoginView.alpha = 1.0
            self.facebookLoginView.frame = CGRectMake(loginFrame.origin.x, self.view.center.y + 100, loginFrame.size.width, loginFrame.size.height)
            
            if (self.currentUser != nil) {
                self.currentUser = nil
                self.profileImage.alpha = 0.0
                let welcomeFrame = self.welcomeLabel.frame
                self.welcomeLabel.frame = CGRectMake(self.view.frame.size.width, welcomeFrame.origin.y, welcomeFrame.size.width, welcomeFrame.size.height)
                self.welcomeLabel.alpha = 0.0;
            }
        })
    }
    
    func showLoggedInView() {
        self.signingInShimmer.shimmering = false
        self.addProfileImage()
        
        UIView.animateWithDuration(0.8, animations: {
            self.interAPPtLabel.alpha = 1.0
            let frame = self.interAPPtLabel.frame;
            self.interAPPtLabel.frame = CGRectMake(frame.origin.x, 60, frame.size.width, frame.size.height)
            
            self.profileImage.alpha = 1.0
            self.profileImage.frame = CGRectMake(self.view.center.x - 40, self.view.center.y - 40, 80, 80)
            
            self.signingInLabel.alpha = 0
            
            self.facebookLoginView.alpha = 0
            }, completion: {
                (value: Bool) in
                self.facebookLoginView.hidden = true
        })
        
        self.welcomeLabel.text = "Welcome\n\(self.currentUser.name)"
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.welcomeLabel.alpha = 1.0
            let frame = self.welcomeLabel.frame
            self.welcomeLabel.frame = CGRectMake(self.view.center.x - (frame.size.width / 2), frame.origin.y, frame.size.width, frame.size.height)
            }, completion: {
                (value: Bool) in
                (self.parentViewController as ContainerController).showMainController()
        })
    }
    
    func addProfileImage() {
        self.profileImage = UIImageView(image: self.currentUser.profileImage())
        self.profileImage.frame = CGRectMake(self.view.center.x - 40, self.view.frame.size.height - 200, 80, 80)
        self.profileImage.alpha = 0.0
        self.profileImage.clipsToBounds = true
        self.profileImage.layer.cornerRadius = 40
        self.profileImage.layer.borderColor = UIColor.whiteColor().CGColor
        self.profileImage.layer.borderWidth = 2.0
        self.view.addSubview(self.profileImage)
    }
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        showLoggedOutView()
    }
    
    func loginView(loginView : FBLoginView!, handleError: NSError) {
        println("Error: \(handleError.localizedDescription)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

