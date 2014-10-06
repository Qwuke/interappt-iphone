//
//  Location.swift
//  InterAPPt
//
//  Created by Ryan Norman on 9/7/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import Foundation
import CoreData

class Location: BaseModel {
    
    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var company: String
    var logoURL: String!
    var thumbnailURL: String!
    
    override class func build(attributes: Dictionary<String, AnyObject?>) -> Location {
        let instance = super.build(attributes) as Location
        instance.logoURL = ((attributes["logo"] as NSDictionary)["logo"] as NSDictionary)["url"] as String
        instance.thumbnailURL = (((attributes["logo"] as NSDictionary)["logo"] as NSDictionary)["thumb"] as NSDictionary)["url"] as String
        
        return instance
    }
    
    class func search(searchTerm: String, completion: (NSArray) -> ()) {
        let replaceSet = NSCharacterSet(charactersInString:" =\"#%/<>?@\\^`{|}").invertedSet
        let encodedSearchTerm = searchTerm.stringByAddingPercentEncodingWithAllowedCharacters(replaceSet)
        var url = "\(self.getURL())?q=\(encodedSearchTerm!)"
        println(url)
        var request = createRequest("GET", url: NSURL(string: url))
        
        sendRequest(request, completion:{(response:NSURLResponse!, responseData:NSData!, error: NSError!) -> Void in
            
            let jsonResult: NSArray = NSJSONSerialization.JSONObjectWithData(responseData!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSArray
            
            
            NSOperationQueue.mainQueue().addOperationWithBlock {
                completion(self.parseJSONArray(jsonResult))
            }
        })
    }
    
    func logoImage() -> UIImage {
        return ImageCache.get(NSURL(string: self.logoURL))
    }
    
    func thumbnailImage() -> UIImage {
        return ImageCache.get(NSURL(string: self.thumbnailURL))
    }
}
