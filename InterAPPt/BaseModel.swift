//
//  BaseModel.swift
//  InterAPPt
//
//  Created by Ryan Norman on 9/7/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import Foundation

import Foundation
import CoreData

class BaseModel: NSManagedObject {
    func save() {
        saveToApi()
        self.managedObjectContext?.save(nil)
    }
    
    func toDataString() -> String {
        var dataString = ""
        
        for (name, attribute) in entity.attributesByName  {
            dataString += "\(self.className().lowercaseString)[\(name)]=\(self.valueForKey(name as String))&"
        }
        
        return dataString
    }
    
    func className() -> String {
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let bundleName = dict.objectForKey("CFBundleName") as String
        var _className = NSStringFromClass(self.classForCoder)
        return _className.componentsSeparatedByString("\(bundleName).")[1] as String
    }
    
    func getURL() -> NSURL {
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let urlAsString = dict.objectForKey("DevelopmentApiUrl") as String
        return NSURL(string: urlAsString + "/\(self.className().lowercaseString)s")
    }
    
    func saveToApi() {
        var error: NSError? = nil
        var response: NSURLResponse? = nil
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        var request = NSMutableURLRequest(URL: getURL(), cachePolicy: cachePolicy, timeoutInterval: 2.0)
        let requestBodyData = (self.toDataString() as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        
        request.HTTPBody = requestBodyData
        request.HTTPMethod = "POST"
        
        NSURLProtocol.setProperty(requestBodyData?.length, forKey: "Content-Length", inRequest: request)
        NSURLProtocol.setProperty("application/x-www-form-urlencoded", forKey: "Content-Type", inRequest: request)
        
        let reply = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&error)
        var jsonResult: Dictionary = NSJSONSerialization.JSONObjectWithData(reply!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        
        for (name, value) in jsonResult {
            self.setValue(value, forKeyPath: name as String)
        }
    }
    
    func getAttributes() -> Dictionary<String, AnyObject?> {
        var dict: Dictionary<String, AnyObject?> = [:]
        for (name, attribute) in entity.attributesByName {
            var _name: String = name as String
            var _value: AnyObject? = self.valueForKeyPath(_name)
            dict[_name] = _value
        }
        
        return dict
    }

    
    func saveManagedObjectContext() {
        
    }
    
    class func className() -> String {
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let bundleName = dict.objectForKey("CFBundleName") as String
        var _className = NSStringFromClass(self)
        return _className.componentsSeparatedByString("\(bundleName).")[1] as String
    }
    
}
