//
//  ImageCache.swift
//  InterAPPt
//
//  Created by Ryan Norman on 9/29/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import Foundation

// Cache to store images in memory
var imageCache: NSCache? = NSCache()

class ImageCache {
    
    class func getImageFolder() -> String? {
        let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
        let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
        if let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true) {
            if paths.count > 0 {
                if let dirPath = paths[0] as? String {
                    return dirPath
                }
            }
        }
        return nil
    }
    
    class func getImagePath(name: String) -> String? {
        return self.getImageFolder()!.stringByAppendingPathComponent("\(name)")
    }
    
    class func exists(filepath: String) -> Bool {
        var checkValidation = NSFileManager.defaultManager()
        return checkValidation.fileExistsAtPath(filepath)
    }
    
    class func get(url: NSURL) -> UIImage {
        var error: NSError? = nil
        var fileMgr: NSFileManager = NSFileManager.defaultManager()
        let documentsDirectory: String = self.getImageFolder()!
        
        let filename = url.absoluteString!.componentsSeparatedByString("interappt").last?.componentsSeparatedByString("?").first?.componentsSeparatedByString("/").last
        
        if let image: UIImage = imageCache?.objectForKey(filename!) as? UIImage {
            return image
        } else {
            let filepath = self.getImagePath(filename!)
            if exists(filepath!) {
                let image = UIImage(named: filepath)
                imageCache?.setObject(image, forKey: filename!)
                return image
            } else {
                let data: NSData = NSData(contentsOfURL: url)
                var image = UIImage(data: data)
                
                UIImageJPEGRepresentation(image, 1.0).writeToFile(filepath!, atomically: true)
                imageCache?.setObject(image, forKey: filename!)
                return image
            }
        }
    }
}
