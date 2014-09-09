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
            dataString += "\(self.classForCoder.className().lowercaseString)[\(name)]=\(self.valueForKey(name as String))&"
        }
        
        let stringLength = countElements(dataString)
        let substringIndex = stringLength - 1
        dataString.substringToIndex(advance(dataString.startIndex, substringIndex))

        return dataString
    }
    
    func getURL() -> NSURL {
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let urlAsString = dict.objectForKey("DevelopmentApiUrl") as String
        return NSURL(string: urlAsString + "/\(self.classForCoder.className().lowercaseString)s")
    }
    
    func saveToApi() {
        var error: NSError? = nil
        var response: NSURLResponse? = nil
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        let request = NSMutableURLRequest(URL: getURL(), cachePolicy: cachePolicy, timeoutInterval: 2.0)
        let requestBodyData = (self.toDataString() as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        
        request.HTTPBody = requestBodyData
        request.HTTPMethod = "POST"
        
        NSURLProtocol.setProperty(requestBodyData?.length, forKey: "Content-Length", inRequest: request)
        NSURLProtocol.setProperty("application/x-www-form-urlencoded", forKey: "Content-Type", inRequest: request)
        
        let reply = NSURLConnection.sendSynchronousRequest(request, returningResponse:&response, error:&error)
        let jsonResult: Dictionary = NSJSONSerialization.JSONObjectWithData(reply!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        
        for (name, value) in jsonResult {
            self.setValue(value, forKeyPath: name as String)
        }
    }
    
    func getAttributes() -> Dictionary<String, AnyObject?> {
        var dict: Dictionary<String, AnyObject?> = [:]
        for (name, attribute) in entity.attributesByName {
            let _name: String = name as String
            let _value: AnyObject? = self.valueForKeyPath(_name)
            dict[_name] = _value
        }
        
        return dict
    }
    
    class func className() -> String {
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let bundleName = dict.objectForKey("CFBundleName") as String
        let _className = NSStringFromClass(self)
        return _className.componentsSeparatedByString("\(bundleName).")[1] as String
    }
    
}
