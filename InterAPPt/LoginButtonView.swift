//
//  LoginButtonView.swift
//  InterAPPt
//
//  Created by Ryan Norman on 10/5/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import Foundation

protocol LoginButtonDelegate {
    func userDidLogin(user: User)
    func userDidBeginLogin()
}

class LoginButton : UIButton {
    var delegate: LoginButtonDelegate!
    
    init(name: String, frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 24)
        titleLabel.textColor = UIColor.whiteColor()
        backgroundColor = UIColor.clearColor()
        titleLabel.textAlignment = NSTextAlignment.Left
        setTitle("Log in with \(name)", forState: UIControlState.Normal)
        contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        alpha = 0
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
