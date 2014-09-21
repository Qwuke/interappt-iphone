//
//  ContainerController.swift
//  InterAPPt
//
//  Created by Ryan Norman on 9/21/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

class ContainerController: UIViewController {
    var loginController: LoginController!
    var mainController: MainController!
    var transitionControllerDelegate: LoginToMainControllerTransitionDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginController = LoginController()
        self.addChildViewController(loginController)
        self.view.addSubview(loginController.view)
        self.loginController.didMoveToParentViewController(self)
        
        transitionControllerDelegate = LoginToMainControllerTransitionDelegate()
        mainController = MainController()
        mainController.modalPresentationStyle = UIModalPresentationStyle.Custom
        mainController.transitioningDelegate = transitionControllerDelegate
    }
    
    func showMainController() {
        self.presentViewController(mainController, animated: true) { () -> Void in
            
        }
    }
}
