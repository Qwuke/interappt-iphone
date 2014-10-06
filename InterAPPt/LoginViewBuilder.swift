//
//  LoginViewBuilder.swift
//  InterAPPt
//
//  Created by Ryan Norman on 10/5/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import Foundation

class LoginViewBuilder {
    var loginController: LoginController
    var view: UIView
    var width: CGFloat
    var height: CGFloat
    
    init(loginController: LoginController) {
        self.loginController = loginController
        self.view = loginController.view
        self.width = self.view.frame.width
        self.height = self.view.frame.height
        
        addBackground()
        addInterAPPtLabel()
        addFacebookLoginButton()
        addTwitterLoginButton()
        addEmailLoginButton()
        addWelcomeLabel()
        addSigningInIndicator()
    }
    
    func addSigningInIndicator() {
        loginController.signingInLabel = UILabel(frame: CGRectMake(25, loginController.view.center.y - 20, 90, 40))
        loginController.signingInLabel.text = "Signing In"
        loginController.signingInLabel.textColor = UIColor.whiteColor()
        loginController.signingInLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 18)
        loginController.signingInLabel.textAlignment = NSTextAlignment.Center
        loginController.signingInLabel.hidden = true
        loginController.signingInLabel.alpha = 0
        
        loginController.signingInShimmer = FBShimmeringView(frame: loginController.signingInLabel.frame)
        loginController.signingInShimmer.contentView = loginController.signingInLabel
        loginController.signingInShimmer.shimmering = false;
        loginController.view.addSubview(loginController.signingInShimmer)
    }
    
    func addBackground() {
        loginController.backgroundImage = UIImageView(image: UIImage(named: "Interappt BG2.jpg"))
        loginController.backgroundImage.frame = loginController.view.frame
        loginController.view.addSubview(loginController.backgroundImage)
    }
    
    func addWelcomeLabel() {
        loginController.welcomeLabel = UILabel()
        loginController.welcomeLabel.frame = CGRectMake(25, view.center.y + 60, 150, 100)
        loginController.welcomeLabel.text = "Welcome"
        loginController.welcomeLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        loginController.welcomeLabel.numberOfLines = 0
        loginController.welcomeLabel.textColor = UIColor.whiteColor()
        loginController.welcomeLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 24)
        loginController.welcomeLabel.textAlignment = NSTextAlignment.Left
        loginController.view.addSubview(loginController.welcomeLabel)
        loginController.welcomeLabel.alpha = 0.0
    }
    
    func addInterAPPtLabel() {
        loginController.interAPPtLabel = UILabel()
        loginController.interAPPtLabel.frame = CGRectMake(width, view.center.y - 125, width, 50)
        loginController.interAPPtLabel.text = "InterAPPt"
        loginController.interAPPtLabel.textColor = UIColor.whiteColor()
        loginController.interAPPtLabel.font = UIFont(name: "Mohave", size: 48.0)
        loginController.interAPPtLabel.alpha = 0.0
        loginController.view.addSubview(loginController.interAPPtLabel)
    }
    
    func addFacebookLoginButton() {
        loginController.facebookLoginView = FacebookLoginButton(frame: CGRectMake(width, view.center.y - 25, height, 40))
        loginController.facebookLoginView.delegate = loginController
        view.addSubview(loginController.facebookLoginView)
    }
    
    func addTwitterLoginButton() {
        loginController.twitterLoginView = LoginButton(name: "Twitter", frame: CGRectMake(width, view.center.y + 25, width, 40))
        view.addSubview(loginController.twitterLoginView)
    }
    
    func addEmailLoginButton() {
        loginController.emailLoginView = LoginButton(name: "Email", frame: CGRectMake(width, view.center.y + 75, view.frame.size.width, 40))
        view.addSubview(loginController.emailLoginView)
    }
    
    func addProfileImage() {
        loginController.profileImage = UIImageView(image: loginController.currentUser.profileImage())
        loginController.profileImage.frame = CGRectMake(view.center.x - 40, view.frame.size.height - 200, 80, 80)
        loginController.profileImage.alpha = 0.0
        loginController.profileImage.clipsToBounds = true
        loginController.profileImage.layer.cornerRadius = 40
        loginController.profileImage.layer.borderColor = UIColor.whiteColor().CGColor
        loginController.profileImage.layer.borderWidth = 2.0
        view.addSubview(loginController.profileImage)
    }
}