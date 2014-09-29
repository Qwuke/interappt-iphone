//
//  LocationSearchController.swift
//  InterAPPt
//
//  Created by Ryan Norman on 9/23/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import UIKit

class LocationSearchController: UIViewController, UISearchBarDelegate {
    var currentUser: User!
    var searchField: UISearchBar!
    
    override func viewDidLoad() {
        self.currentUser = User.current()
        addNavigationBar()
        addSearchField()
    }
    
    func addNavigationBar() {
        self.title = "InterAPPt"
        self.navigationController.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Mohave-Bold", size: 24), NSForegroundColorAttributeName: UIColor(red: 167/255, green: 224/255, blue: 9/255, alpha: 1)]
        
        var profileImage: UIImageView = UIImageView(image: self.currentUser.profileImage())
        profileImage.frame = CGRectMake(0, 0, 30, 30)
        profileImage.layer.cornerRadius = 15
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor.whiteColor().CGColor
        profileImage.clipsToBounds = true
        
        var profileButton: UIBarButtonItem = UIBarButtonItem(customView: profileImage)
        self.navigationItem.leftBarButtonItem = profileButton;
    }
    
    func addSearchField() {
        self.searchField = UISearchBar(frame: CGRectMake(0, 0, 300, 60))
        self.searchField.center = self.view.center
        self.searchField.placeholder = "Search Locations…"
        self.searchField.searchBarStyle = UISearchBarStyle.Minimal;
        self.searchField.delegate = self
        self.view.addSubview(self.searchField)
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar!) {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.searchField.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height + 20, self.view.frame.size.width, 40)
        })
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar!) {
        
    }
}
