//
//  ImageCache.swift
//  InterAPPt
//
//  Created by Ryan Norman on 9/29/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import Foundation

// Cache to store images in memory
var imageCache: NSCache = NSCache()

class ImageCache {
    
    class func getImagePath(name: String) -> String? {
        let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
        let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
        if let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true) {
            if paths.count > 0 {
                if let dirPath = paths[0] as? String {
                    return dirPath.stringByAppendingPathComponent("\(name)")
                }
            }
        }
        return nil
    }
    
    class func exists(url: NSURL) -> Bool {
        var checkValidation = NSFileManager.defaultManager()
    
        return checkValidation.fileExistsAtPath(getImagePath(url.absoluteString!)!)
    }
    
    class func get(url: NSURL) -> UIImage {
        let urlString = url.absoluteString!.componentsSeparatedByString("/").last?.componentsSeparatedByString("?").first
        
        if let image: UIImage = imageCache.objectForKey(urlString!) as? UIImage {
            println("Got from cache")
            return image
        } else {
            if exists(url) {
                println("Got from filesystem")
                let image = UIImage(named: urlString)
                imageCache.setObject(image, forKey: urlString!)
                return image
            } else {
                println("Got from API")
                let data: NSData = NSData(contentsOfURL: url)
                let image = UIImage(data: data)
                UIImageJPEGRepresentation(image, 0.9).writeToFile(self.getImagePath(urlString!)!, atomically: true)
                imageCache.setObject(image, forKey: urlString!)
                return image
            }
        }
    }
}
