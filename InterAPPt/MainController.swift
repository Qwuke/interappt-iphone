//
//  MainController.swift
//  InterAPPt
//
//  Created by Ryan Norman on 9/21/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

class MainController: UINavigationController {    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationBar.barTintColor = UIColor.blackColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        var locationSearchController = LocationSearchController();
        self.pushViewController(locationSearchController, animated: false)
    }
}
