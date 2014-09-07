//
//  ViewController.swift
//  InterAPPt
//
//  Created by Ryan Norman on 8/31/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FBLoginViewDelegate {
    
    var interAPPtLogoView: UILabel!
    var facebookLoginView: FBLoginView!
    var currentUser: User!
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        addFacebookButton()
        addInterAPPtLogo()
    }
    
    func addInterAPPtLogo() {
        self.interAPPtLogoView = UILabel()
        self.interAPPtLogoView.frame = CGRectMake(self.view.center.x - 75, self.view.center.y - 25 - 100, 150, 50)
        self.interAPPtLogoView.layer.cornerRadius = 25.0
        self.interAPPtLogoView.text = "InterAPPt"
        self.interAPPtLogoView.textColor = UIColor.whiteColor()
        self.interAPPtLogoView.textAlignment = NSTextAlignment.Center
        self.interAPPtLogoView.font = UIFont.systemFontOfSize(36.0)
        self.view.addSubview(self.interAPPtLogoView)
    }
    
    func addFacebookButton() {
        self.facebookLoginView = FBLoginView()
        self.facebookLoginView.frame = CGRectOffset(self.facebookLoginView.frame, self.view.center.x - (self.facebookLoginView.frame.size.width / 2), self.view.center.y - (self.facebookLoginView.frame.size.height / 2))
        self.facebookLoginView.delegate = self
        self.facebookLoginView.readPermissions = ["public_profile", "email", "user_friends"]
        self.view.addSubview(self.facebookLoginView)
    }
    
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        println("User Logged In")
        self.facebookLoginView.hidden = true
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser) {
        self.currentUser = User.current()
        if self.currentUser == nil {
            self.currentUser = User.createFromFacebookInfo(user)
        }
    }
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        println("User Logged Out")
    }
    
    func loginView(loginView : FBLoginView!, handleError: NSError) {
        println("Error: \(handleError.localizedDescription)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

