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
    
    required override init(entity: NSEntityDescription,
        insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    class func managedObjectContext() -> NSManagedObjectContext {
      return (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
    }
    
    class func className() -> String {
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let bundleName = dict.objectForKey("CFBundleName") as String
        let _className = NSStringFromClass(self)
        return _className.componentsSeparatedByString("\(bundleName).")[1] as String
    }
    
    class func getAccessToken() -> String {
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        return dict.objectForKey("InterAPPt Access Token") as String
    }
    
    class func getURL() -> NSURL {
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let urlAsString = dict.objectForKey("DevelopmentApiUrl") as String
        return NSURL(string: urlAsString + "/\(self.className().lowercaseString)s")
    }
    
    class func getURL(baseModelId: String) -> NSURL {
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let urlAsString = dict.objectForKey("DevelopmentApiUrl") as String
        return NSURL(string: urlAsString + "/\(self.className().lowercaseString)s/\(baseModelId)")
    }
    
    class func createRequest(method: String, url: NSURL) -> NSMutableURLRequest {
        let cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        println("URL: \(url)")
        
        let request = NSMutableURLRequest(URL: url, cachePolicy: cachePolicy, timeoutInterval: 2.0)
        request.HTTPMethod = method
        NSURLProtocol.setProperty("application/x-www-form-urlencoded", forKey: "Content-Type", inRequest: request)
        request.addValue(getAccessToken(), forHTTPHeaderField: "TOKEN")
        
        return request
    }
    
    class func sendRequest(request: NSURLRequest, completion: (response:NSURLResponse!, responseData:NSData!, error:NSError!) -> ()) {
        var error: NSError? = nil
        var response: NSURLResponse? = nil
        var queue: NSOperationQueue = NSOperationQueue()
        // Sending Asynchronous request using NSURLConnection
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{(response:NSURLResponse!, responseData:NSData!, error: NSError!) -> Void in
            completion(response: response, responseData: responseData, error: error)
        })
    }
    
    class func retrieveFromApi(completion: (NSArray) -> ()) {
        var request = createRequest("GET", url: self.getURL())
        
        sendRequest(request, completion:{(response:NSURLResponse!, responseData:NSData!, error: NSError!) -> Void in
            
            let jsonResult: Array = NSJSONSerialization.JSONObjectWithData(responseData!, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSArray
            
            var instances: [BaseModel] = []
            for attributes in jsonResult {
                let modelAttributes = attributes as? Dictionary<String, AnyObject>
                var instance = self.build(modelAttributes!)
                instances.append(instance)
            }
            
            completion(instances)
        })
    }
    
    class func build(attributes: Dictionary<String, AnyObject?>) -> BaseModel {
        let managedObjectContext = self.managedObjectContext()
        let entity = NSEntityDescription.entityForName(self.className(), inManagedObjectContext: managedObjectContext)
        let instance = self(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
        
        for (name, value) in attributes {
            if instance.respondsToSelector(Selector(name as String)) {
                instance.setValue(value, forKeyPath: name as String)
            }
        }
        
        return instance
    }
    
    func save(completion: (BaseModel) -> ()) {
        saveToApi(completion)
    }
    
    func destroy(completion: () -> ()) {
        deleteFromApi({ (BaseModel) -> () in
            self.classForCoder.managedObjectContext().deleteObject(self)
            self.classForCoder.managedObjectContext().save(nil)
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
    
    func saveToApi(completion: (BaseModel) -> ()) {
        let requestBodyData = (self.toDataString() as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        var request = self.classForCoder.createRequest("POST", url: self.classForCoder.getURL(self.valueForKey("id") as String))
        request.HTTPBody = requestBodyData
        NSURLProtocol.setProperty(requestBodyData?.length, forKey: "Content-Length", inRequest: request)
        
        // Sending Asynchronous request using NSURLConnection
        self.classForCoder.sendRequest(request, completion:{(response:NSURLResponse!, responseData:NSData!, error: NSError!) -> Void in
            
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
    
    func deleteFromApi(completion: (BaseModel) -> ()) {
        let request = self.classForCoder.createRequest("DELETE", url: self.classForCoder.getURL(self.valueForKey("id") as String))
        
        // Sending Asynchronous request using NSURLConnection
        self.classForCoder.sendRequest(request, completion: {(response:NSURLResponse!, responseData:NSData!, error: NSError!) -> Void in
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
}
