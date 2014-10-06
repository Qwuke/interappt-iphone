//
//  FacebookLoginButton.swift
//  InterAPPt
//
//  Created by Ryan Norman on 10/5/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import Foundation

class FacebookLoginButton : LoginButton {
 
    init(frame: CGRect) {
        super.init(name: "Facebook", frame: frame)
        
        addTarget(self, action: "loginToFacebook", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loginToFacebook() {
        println("Login to Facebook")
        FBSession.openActiveSessionWithReadPermissions(["public_profile", "email", "user_friends"], allowLoginUI: true, completionHandler: {session, state, error in
            println("completion handler: session \(session), state \(state), error \(error)")
            self.delegate.userDidBeginLogin()
            self.fetchMeInfo()
        })
    }
    
    func fetchMeInfo() {
        var request = FBRequest.requestForMe()
        request.session = FBSession.activeSession()
        var requestConnection = FBRequestConnection()
        
        requestConnection.addRequest(request, completionHandler: { (request, user, error) -> Void in
            
            self.createUser(user as [String : AnyObject])
            
        })
        
        requestConnection.start()
    }
    
    
    func createUser(user: [String : AnyObject]) {
        User.createFromFacebookInfo(user, completion: { (user) -> Void in
            self.delegate.userDidLogin(user)
        })
    }
}