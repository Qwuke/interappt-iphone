//
//  LocationsListController.swift
//  InterAPPt
//
//  Created by Ryan Norman on 9/30/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import Foundation

class LocationsListController: UITableViewController {
    var locations: [Location]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(LocationTableCell.classForCoder(), forCellReuseIdentifier: "LocationTableCell")
        self.tableView.separatorInset = UIEdgeInsetsZero
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    
    override func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
        
        var cell:LocationTableCell = self.tableView?.dequeueReusableCellWithIdentifier("LocationTableCell") as LocationTableCell
        
        let row = indexPath?.row
        cell.setLocation(locations[row!])
        
        return cell
    }
    
    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 70.0
    }
}
