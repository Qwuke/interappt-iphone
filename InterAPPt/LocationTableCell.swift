//
//  LocationTableCell.swift
//  InterAPPt
//
//  Created by Ryan Norman on 10/2/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import Foundation

class LocationTableCell: UITableViewCell {
    var nameLabel: UILabel
    var companyLabel: UILabel
    var locationImageView: UIImageView
    var location: Location!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {

        self.nameLabel = UILabel(frame: CGRectMake(120, 12, 204, 21))
        self.nameLabel.font = UIFont.boldSystemFontOfSize(17.0)
        self.nameLabel.backgroundColor = UIColor.whiteColor()
        
        self.companyLabel = UILabel(frame: CGRectMake(120, 35, 204, 21))
        self.companyLabel.font = UIFont.systemFontOfSize(14.0)
        self.companyLabel.textColor = UIColor.darkTextColor()
        self.companyLabel.backgroundColor = UIColor.whiteColor()
        
        self.locationImageView = UIImageView()
        self.locationImageView.frame = CGRectMake(0, 0, 100, 70)
        self.locationImageView.clipsToBounds = true
        
        super.init(style: UITableViewCellStyle.Value1, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(self.nameLabel)
        self.addSubview(self.companyLabel)
        self.addSubview(self.locationImageView)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLocation(location: Location) -> Void {
        self.location = location
        
        self.nameLabel.text = location.name
        self.companyLabel.text = location.company
        self.locationImageView.image = location.thumbnailImage()
    }
}