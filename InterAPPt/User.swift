//
//  User.swift
//  InterAPPt
//
//  Created by Ryan Norman on 9/7/14.
//  Copyright (c) 2014 Ryan Norman. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {

    @NSManaged var uuid: String
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
        
        
        if fetchedObjects?.count == 0 {
            print("Could not find user")
            return nil
        } else {
            print("Found user")
            return fetchedObjects?[0] as? User
        }
    }
    
    class func createFromFacebookInfo(fbUser: FBGraphUser) -> User {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: managedObjectContext)
        let user = User(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
        user.name = fbUser.name
        user.facebook_id = fbUser.objectID
        user.email = fbUser.objectForKey("email") as String
        user.gender = fbUser.objectForKey("gender") as String
        user.locale = fbUser.objectForKey("locale") as String
        user.timezone = fbUser.objectForKey("timezone") as String
        managedObjectContext?.save(nil)
        return user
    }
}
