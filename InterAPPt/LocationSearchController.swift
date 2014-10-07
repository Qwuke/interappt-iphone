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
    var locationsTable: LocationsListController!
    var loadingLocationsShimmer: FBShimmeringView!
    
    override func viewDidLoad() {
        self.currentUser = User.current()
        addNavigationBar()
        addSearchField()
        addLocationsTable()
        addLocationsShimmer()
    }
    
    func addLocationsTable() {
        self.locationsTable = LocationsListController(style: UITableViewStyle.Plain)
        self.view.addSubview(self.locationsTable.view)
        self.locationsTable.locations = []
        self.locationsTable.tableView.hidden = true
        self.locationsTable.tableView.frame = CGRectOffset(self.locationsTable.tableView.frame, 0, self.view.frame.size.height)
    }
    
    func addLocationsShimmer() {
        var loadingLabel = UILabel(frame: CGRectMake(0, 0, 200, 40))
        loadingLabel.center = self.view.center
        loadingLabel.text = "Searching For Locations…"
        self.loadingLocationsShimmer = FBShimmeringView(frame: loadingLabel.frame)
        self.loadingLocationsShimmer.contentView = loadingLabel
        self.loadingLocationsShimmer.shimmering = true
        self.loadingLocationsShimmer.alpha = 0.0
        self.view.addSubview(self.loadingLocationsShimmer)
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
        self.searchField.backgroundColor = UIColor.clearColor()
        self.searchField.delegate = self
        
        for view in self.searchField.subviews {
            if view.isKindOfClass(UITextField) {

            }
        }
        self.view.addSubview(self.searchField)
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar!) {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.searchField.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height + 20, self.view.frame.size.width, 40)
        })
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar!) {
        
        UIView.animateWithDuration(0.25, animations: { () -> Void in
          self.loadingLocationsShimmer.alpha = 1.0
          self.locationsTable.tableView.alpha = 0.0
        })

        Location.search(searchField.text) { (locations) -> () in
            self.locationsTable.locations = locations as [Location]
            self.locationsTable.tableView.reloadData()
            
            UIView.animateWithDuration(0.25, delay: 1.5, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.loadingLocationsShimmer.alpha = 0.0
                self.locationsTable.tableView.alpha = 1.0
                }, completion: { (complete) -> Void in
            })
            
            if self.locationsTable.tableView.hidden {
                self.locationsTable.tableView.hidden = false
                
                UIView.animateWithDuration(0.75, delay: 1.5, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    
                    self.locationsTable.tableView.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height + 20 + self.searchField.frame.size.height, self.locationsTable.tableView.frame.size.width, self.locationsTable.tableView.frame.size.height)
                    
                    }, completion: { (complete) -> Void in
                        
                        self.locationsTable.tableView.tableHeaderView = self.searchField
                        self.locationsTable.tableView.frame = CGRectOffset(self.locationsTable.tableView.frame, 0, self.searchField.frame.size.height * -1)
                        
                })
            }
        }

    }
}

