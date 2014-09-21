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
    var mContext: NSManagedObjectContext!
    
    func managedObjectContext() -> NSManagedObjectContext {
        if (mContext == nil) {
            mContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
        }
        return mContext
    }
    
    func save(completion: (BaseModel) -> ()) {
        saveToApi(completion)
    }
    
    func destroy(completion: () -> ()) {
        deleteFromApi({ (BaseModel) -> () in
            self.managedObjectContext().deleteObject(self)
            self.managedObjectContext().save(nil)
            completion()
        })
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
    
    func getAccessToken() -> String {
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        return dict.objectForKey("InterAPPt Access Token") as String
    }
    
    func getURL() -> NSURL {
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let urlAsString = dict.objectForKey("DevelopmentApiUrl") as String
        return NSURL(string: urlAsString + "/\(self.classForCoder.className().lowercaseString)s")
    }
    
    func getURL(baseModelId: String) -> NSURL {
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let urlAsString = dict.objectForKey("DevelopmentApiUrl") as String
        return NSURL(string: urlAsString + "/\(self.classForCoder.className().lowercaseString)s/\(baseModelId)")
    }
    
    func saveToApi(completion: (BaseModel) -> ()) {
        let requestBodyData = (self.toDataString() as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        var request = createRequest("POST")
        request.HTTPBody = requestBodyData
        NSURLProtocol.setProperty(requestBodyData?.length, forKey: "Content-Length", inRequest: request)
        
        // Sending Asynchronous request using NSURLConnection
        sendRequest(request, completion:{(response:NSURLResponse!, responseData:NSData!, error: NSError!) -> Void in
            
            let jsonResult: Dictionary = NSJSONSerialization.JSONObjectWithData(responseData!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
            
            for (name, value) in jsonResult {
                if self.respondsToSelector(Selector(name as String)) {
                    println("\(name): \(value)")
                    self.setValue(value, forKeyPath: name as String)
                }
            }
            
            completion(self)
        })
    }
    
    func createRequest(method: String) -> NSMutableURLRequest {
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        var url = self.valueForKey("id") == nil ? self.getURL() : self.getURL(self.valueForKey("id") as String)
        println("URL: \(url)")
        
        let request = NSMutableURLRequest(URL: url, cachePolicy: cachePolicy, timeoutInterval: 2.0)
        request.HTTPMethod = method
        NSURLProtocol.setProperty("application/x-www-form-urlencoded", forKey: "Content-Type", inRequest: request)
        request.addValue(getAccessToken(), forHTTPHeaderField: "TOKEN")
        
        return request
    }
    
    func sendRequest(request: NSURLRequest, completion: (response:NSURLResponse!, responseData:NSData!, error:NSError!) -> ()) {
        var error: NSError? = nil
        var response: NSURLResponse? = nil
        var queue: NSOperationQueue = NSOperationQueue()
        // Sending Asynchronous request using NSURLConnection
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{(response:NSURLResponse!, responseData:NSData!, error: NSError!) -> Void in
            completion(response: response, responseData: responseData, error: error)
        })
    }
    
    func deleteFromApi(completion: (BaseModel) -> ()) {
        let request = createRequest("DELETE")
        
        // Sending Asynchronous request using NSURLConnection
        sendRequest(request, completion: {(response:NSURLResponse!, responseData:NSData!, error: NSError!) -> Void in
            completion(self)
        })
    }
    
    func getAttributes() -> Dictionary<String, AnyObject?> {
        var dict: Dictionary<String, AnyObject?> = [:]
        for (name, attribute) in entity.attributesByName {
            let _name: String = name as String
            let _value: AnyObject? = self.valueForKey(_name)
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
