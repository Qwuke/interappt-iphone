//
//  User.swift
//  InterAPPt
//
//  Created by Ryan Norman on 9/7/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import Foundation
import CoreData

class User: BaseModel {

    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var email: String
    @NSManaged var gender: String
    @NSManaged var locale: String
    @NSManaged var timezone: String
    @NSManaged var facebook_id: String
    
    class func current() -> User? {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: managedObjectContext)
        let error = NSErrorPointer()
        
        fetchRequest.entity = entity
        
        let fetchedObjects = managedObjectContext?.executeFetchRequest(fetchRequest, error: error)
        
        println(fetchedObjects)
        
        if fetchedObjects?.count == 0 {
            return nil
        } else {
            return fetchedObjects?[0] as? User
        }
    }
    
    class func createFromFacebookInfo(fbUser: FBGraphUser, completion: (user: User) -> Void) {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: managedObjectContext)
        let user = User(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
        user.name = fbUser.name
        user.facebook_id = fbUser.objectID
        user.email = fbUser.objectForKey("email") as String
        user.gender = fbUser.objectForKey("gender") as String
        user.locale = fbUser.objectForKey("locale") as String
        user.save({(User) -> Void in
            managedObjectContext?.save(nil)
            user.saveProfileImage()
            completion(user: user)
        })
    }
    
    func saveProfileImage() {
        var data: NSData = NSData(contentsOfURL: NSURL(string: "https://graph.facebook.com/\(self.facebook_id)/picture?type=large"))
        var image: UIImage = self.toSquareImage(UIImage(data: data))
        UIImagePNGRepresentation(image).writeToFile(self.getProfileImagePath()!, atomically: true)
    }
    
    func profileImage() -> UIImage? {
        return UIImage(named: getProfileImagePath())
    }
    
    func toSquareImage(image: UIImage) -> UIImage {
        var originalWidth  = image.size.width
        var originalHeight = image.size.height
        
        var edge: CGFloat
        if originalWidth > originalHeight {
            edge = originalHeight
        } else {
            edge = originalWidth
        }
        
        var posX = (originalWidth  - edge) / 2.0
        var posY = (originalHeight - edge) / 5.0
        
        var cropSquare = CGRectMake(posX, posY, edge, edge)
        
        var imageRef = CGImageCreateWithImageInRect(image.CGImage, cropSquare);
        return UIImage(CGImage: imageRef, scale: UIScreen.mainScreen().scale, orientation: image.imageOrientation)
    }
    
    func getProfileImagePath() -> String? {
        let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
        let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
        if let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true) {
            if paths.count > 0 {
                if let dirPath = paths[0] as? String {
                    return dirPath.stringByAppendingPathComponent("\(self.id).jpg")
                }
            }
        }
        return nil
    }
}
