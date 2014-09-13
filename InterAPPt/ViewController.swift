//
//  ViewController.swift
//  InterAPPt
//
//  Created by Ryan Norman on 8/31/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FBLoginViewDelegate {
    
    var interAPPtLabel: UILabel!
    var interAPPtLogo: UIImageView!
    var facebookLoginView: FBLoginView!
    var currentUser: User!
    var savingFacebookUser: Bool!;
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        savingFacebookUser = false
        
        addFacebookButton()
        addInterAPPtLabel()
        addInterAPPtLogo()
    }
    
    func addInterAPPtLogo() {
        self.interAPPtLogo = UIImageView(image: UIImage(named: "logo.png"))
        self.interAPPtLogo.frame = CGRectMake(self.view.center.x - 40, self.view.center.y - 40, 80, 80)
        self.view.addSubview(self.interAPPtLogo)
    }
    
    func addInterAPPtLabel() {
        self.interAPPtLabel = UILabel()
        self.interAPPtLabel.frame = CGRectMake(self.view.center.x - 75, self.view.center.y - 25, 150, 50)
        self.interAPPtLabel.text = "InterAPPt"
        self.interAPPtLabel.textColor = UIColor.whiteColor()
        self.interAPPtLabel.font = UIFont(name: "Mohave", size: 36.0)
        self.interAPPtLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(self.interAPPtLabel)
        
        self.interAPPtLabel.alpha = 0.0
        UIView.animateWithDuration(0.5, animations: {
            self.interAPPtLabel.alpha = 1.0
            self.interAPPtLabel.frame = CGRectOffset(self.interAPPtLabel.frame, 0.0, -100)
            }, completion: {
                (value: Bool) in
                
        })
    }
    
    func addFacebookButton() {
        self.facebookLoginView = FBLoginView()
        self.facebookLoginView.frame = CGRectOffset(self.facebookLoginView.frame, self.view.center.x - (self.facebookLoginView.frame.size.width / 2), self.view.center.y - (self.facebookLoginView.frame.size.height / 2))
        self.facebookLoginView.delegate = self
        self.facebookLoginView.hidden = true
        self.facebookLoginView.readPermissions = ["public_profile", "email", "user_friends"]
        self.view.addSubview(self.facebookLoginView)
    }
    
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        println("User Logged In")
        self.facebookLoginView.hidden = false
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser) {
        if !savingFacebookUser {
            savingFacebookUser = true
            self.currentUser = User.current()
            if self.currentUser == nil {
                println("Try to save user")
                User.createFromFacebookInfo(user, completion: { (user) -> Void in
                    self.currentUser = user
                    println("Saved user with id: \(self.currentUser.getAttributes())")
                })
            }
        }
    }
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        println("User Logged Out")
        loginView.hidden = false
        loginView.alpha = 0.0
        UIView.animateWithDuration(0.5, animations: {
            loginView.alpha = 1.0
            loginView.frame = CGRectOffset(loginView.frame, 0.0, 100)
            }, completion: {
                (value: Bool) in
                
        })
    }
    
    func loginView(loginView : FBLoginView!, handleError: NSError) {
        println("Error: \(handleError.localizedDescription)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

