//
//  CoreDataManager.swift
//  MyMarbel
//
//  Created by Tmaas on 19/05/16.
//  Copyright © 2016 MBSolution. All rights reserved.
//

import UIKit
import CoreData

let sharedManager = CoreDataManager()

class CoreDataManager: NSObject {
    var context: NSManagedObjectContext!
    let managedObjectContext =
        (UIApplication.sharedApplication().delegate
            as! AppDelegate).managedObjectContext
    
    class func getInstance() -> CoreDataManager {
        if sharedManager.context == nil {
            let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            sharedManager.context = appDel.managedObjectContext
            
        }
        return sharedManager
    }
    
    
    //============================ User ================================//
    
    //check user by email and password
    func checkUser(email: String, password: String) -> String {
        /* return value
         1: success
         -1: wrong password
         -2: no exsit
         -64: unknown error
         */
        let request = NSFetchRequest(entityName: "User")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "userEmail = %@", email)
        
        do {
            let results: NSArray = try sharedManager.context.executeFetchRequest(request)
            if results.count > 0 {
                let info = results[0] as! User
                let userPwd = info.password
                if password == userPwd {
                    return Constants.RESULT_SUCCESS
                } else {return Constants.RESULT_INVALID_AUTHENTICATION}
            } else {return Constants.RESULT_UNAUTHIRIZED}
        } catch{
            return Constants.RESULT_UNKNOWN_ERROR
        }
    }
    
    //get all user data
    func getUserInfo() -> [User] {
        var ary: [User] = [User]()
        let request = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("User", inManagedObjectContext: sharedManager.context)
        request.entity = entityDescription
        request.returnsObjectsAsFaults = false
        
        do {
            let results: NSArray = try sharedManager.context.executeFetchRequest(request)
            for i in 0  ..< results.count  {
                let info = results[i] as! User
                ary.append(info)
            }
            return ary
        } catch{
            print(error as NSError)
            return ary
        }
    }
    
    //save user data
    func saveUserInfo(obj: NSDictionary) {
        let newUser = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: sharedManager.context) as! User
        
        newUser.firstName   = obj.objectForKey("firstName") as? String
        newUser.lastName    = obj.objectForKey("lastName") as? String
        newUser.userEmail   = obj.objectForKey("userEmail") as? String
        newUser.password    = obj.objectForKey("password") as? String
        newUser.height      = obj.objectForKey("height") as? String
        newUser.weight      = obj.objectForKey("weight") as? String
        newUser.terrain     = obj.objectForKey("terrain") as? String
        newUser.avatar      = obj.objectForKey("avatar") as? String
        newUser.bio         = obj.objectForKey("bio") as? String
        newUser.country     = obj.objectForKey("country") as? String
        newUser.state       = obj.objectForKey("state") as? String
        newUser.city        = obj.objectForKey("city") as? String
        newUser.phoneNumber         = obj.objectForKey("phoneNumber") as? String
        newUser.units               = obj.objectForKey("units") as? String
        newUser.rangeAlarm          = obj.objectForKey("rangeAlarm") as? String
        newUser.primaryRideStyle    = obj.objectForKey("primaryRideStyle") as? String
        newUser.milesRidden         = obj.objectForKey("milesRidden") as? String
        newUser.brakingForce        = obj.objectForKey("brakingForce") as? String
        newUser.timestamp           = obj.objectForKey("timestamp") as? String
        newUser.locationEnable      = boolToNumber((obj.objectForKey("locationEnable") as? Bool)!)
        newUser.notificationEnable  = boolToNumber((obj.objectForKey("notificationEnable") as? Bool)!)
        newUser.safetyBrake         = boolToNumber((obj.objectForKey("safetyBrake") as? Bool)!)
        newUser.reverseTurned       = boolToNumber((obj.objectForKey("reverseTurned") as? Bool)!)
        newUser.userID              = obj.objectForKey("userID") as? NSNumber
        
        saveContext()
    }
    
    //update user data
    
    func updateUserStrInfo(email: String, key: String, value: String) {
        let request = NSFetchRequest(entityName: "User")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "userEmail = %@", email)
        do {
            let results: NSArray = try sharedManager.context.executeFetchRequest(request)
            if results.count > 0 {
                let res = results[0] as! NSManagedObject
                res.setValue(value, forKey: key)
                saveContext()
            } else {print("error")}
        } catch{
            print(error as NSError)
        }
    }
    
    func updateUserBoolInfo(email: String, key: String, value: Bool) {
        let request = NSFetchRequest(entityName: "User")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "userEmail = %@", email)
        do {
            let results: NSArray = try sharedManager.context.executeFetchRequest(request)
            if results.count > 0 {
                let res = results[0] as! NSManagedObject
                let newValue = boolToNumber(value)
                res.setValue(newValue, forKey: key)
                saveContext()
            } else {print("error")}
        } catch{
            print(error as NSError)
        }
    }
    
    
    //============================ Board ================================//MARK: - Board
    
    //update Board data
    func updateBoardStrInfo(userID: Int, key: String, value: String) {
        let request = NSFetchRequest(entityName: "Board")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "userID == \(userID)")
        do {
            let results: NSArray = try sharedManager.context.executeFetchRequest(request)
            if results.count > 0 {
                let res = results[0] as! NSManagedObject
                res.setValue(value, forKey: key)
                saveContext()
            } else {print("error")}
        } catch{
            print(error as NSError)
        }
    }
    
    func updateBoardNumberInfo(userID: Int, key: String, value: NSNumber) {
        let request = NSFetchRequest(entityName: "Board")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "userID == \(userID)")
        do {
            let results: NSArray = try sharedManager.context.executeFetchRequest(request)
            if results.count > 0 {
                let res = results[0] as! NSManagedObject
                res.setValue(value, forKey: key)
                saveContext()
            } else {print("error")}
        } catch{
            print(error as NSError)
        }
    }
    
    func updateBoardBoolInfo(userID: Int, key: String, value: Bool) {
        let request = NSFetchRequest(entityName: "Board")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "userID == \(userID)")
        do {
            let results: NSArray = try sharedManager.context.executeFetchRequest(request)
            if results.count > 0 {
                let res = results[0] as! NSManagedObject
                let newValue = boolToNumber(value)
                res.setValue(newValue, forKey: key)
                saveContext()
            } else {print("error")}
        } catch{
            print(error as NSError)
        }
    }
    
    //get board data
    func getBoardInfo() -> [Board] {
        var ary: [Board] = [Board]()
        let request = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("Board", inManagedObjectContext: sharedManager.context)
        request.entity = entityDescription
        request.returnsObjectsAsFaults = false
        
        do {
            let results: NSArray = try sharedManager.context.executeFetchRequest(request)
            for i in 0  ..< results.count  {
                let info = results[i] as! Board
                ary.append(info)
            }
            return ary
        } catch{
            print(error as NSError)
            return ary
        }
    }
    
    func saveBoardInfo(obj: NSDictionary) {
        let info = NSEntityDescription.insertNewObjectForEntityForName("Board", inManagedObjectContext: sharedManager.context) as! Board
        
        info.userID                 = obj.objectForKey("userID") as? NSNumber
        info.boardID                = obj.objectForKey("boardID") as? NSNumber
        info.boardName              = obj.objectForKey("boardName") as? String
        info.firmwareVersion        = obj.objectForKey("firmwareVersion") as? String
        info.timestamp              = obj.objectForKey("timestamp") as? String
        info.mainSerialNumber       = obj.objectForKey("mainSerialNumber") as? String
        info.batterySerialNumber    = obj.objectForKey("batterySerialNumber") as? String
        info.motorVersionNumber     = obj.objectForKey("motorVersionNumber") as? String
        info.circuitVersionNumber   = obj.objectForKey("circuitVersionNumber") as? String
        info.deckVersionNumber      = obj.objectForKey("deckVersionNumber") as? String
        info.productionDate         = obj.objectForKey("productionDate") as? String
        info.wheelSize              = obj.objectForKey("wheelSize") as? String
        info.odometer               = obj.objectForKey("odometer") as? String
        info.rideCount          = obj.objectForKey("rideCount") as? NSNumber
        info.duration           = obj.objectForKey("duration") as? NSNumber
        info.batteryChargeCount = obj.objectForKey("batteryChargeCount") as? NSNumber
        info.lockStatus         = boolToNumber((obj.objectForKey("lockStatus") as? Bool)!)
        info.parentLockStatus   = boolToNumber((obj.objectForKey("parentLock") as? Bool)!)
        
        saveContext()
    }
    
    //============================ RidePoint ================================//
    
    func saveRidePointInfo(obj: NSDictionary) {
        let info = NSEntityDescription.insertNewObjectForEntityForName("RidePoint", inManagedObjectContext: sharedManager.context) as! RidePoint
        

        info.userID                 = obj.objectForKey("userID") as? NSNumber
        info.mode                   = obj.objectForKey("mode") as? String
        info.accel                  = obj.objectForKey("accel") as? NSNumber
        info.speed                  = obj.objectForKey("speed") as? NSNumber
        info.timestamp              = obj.objectForKey("timestamp") as? String
        info.motorDirection1        = obj.objectForKey("motorDirection1") as? String
        info.motorDirection2        = obj.objectForKey("motorDirection2") as? String
        info.elevation              = obj.objectForKey("elevation") as? NSNumber
        info.rideID                 = obj.objectForKey("rideID") as? NSNumber
        info.rpm1                   = obj.objectForKey("rpm1") as? NSNumber
        info.rpm2                   = obj.objectForKey("rpm2") as? NSNumber
        info.odometer               = obj.objectForKey("odometer") as? NSNumber
        info.remoteBLEConnection    = obj.objectForKey("remoteBLEConnection") as? NSNumber
        info.internalTemperature    = obj.objectForKey("internalTemperature") as? NSNumber
        info.remote                 = obj.objectForKey("remote") as? NSNumber
        info.esc1                   = obj.objectForKey("esc1") as? NSNumber
        info.esc2                   = obj.objectForKey("esc2") as? NSNumber
        info.voltage1           = obj.objectForKey("voltage1") as? NSNumber
        info.voltage2           = obj.objectForKey("voltage2") as? NSNumber
        info.voltage3           = obj.objectForKey("voltage3") as? NSNumber
        info.voltage4           = obj.objectForKey("voltage4") as? NSNumber
        info.voltage5           = obj.objectForKey("voltage5") as? NSNumber
        info.voltage6           = obj.objectForKey("voltage6") as? NSNumber
        info.voltage7           = obj.objectForKey("voltage7") as? NSNumber
        info.voltage8           = obj.objectForKey("voltage8") as? NSNumber
        info.voltage9           = obj.objectForKey("voltage9") as? NSNumber
        info.voltage10          = obj.objectForKey("voltage10") as? NSNumber
        info.voltage            = obj.objectForKey("voltage") as? NSNumber
        info.current            = obj.objectForKey("current") as? NSNumber
        info.wh                 = obj.objectForKey("wh") as? NSNumber
        info.errorFlag          = obj.objectForKey("errorFlag") as? NSNumber
        info.remoteBatteryLife  = obj.objectForKey("remoteBatteryLife") as? NSNumber
        info.latitude           = obj.objectForKey("latitude") as? String
        info.longitude          = obj.objectForKey("longitude") as? String
        info.throttle           = obj.objectForKey("throttle") as? NSNumber
        info.bleConnectionStrength = obj.objectForKey("bleConnectionStrength") as? NSNumber
        info.state              = obj.objectForKey("state") as? NSNumber
        info.motorAmps1         = obj.objectForKey("motor_amps1") as? NSNumber
        info.motorAmps2         = obj.objectForKey("motor_amps2") as? NSNumber
        info.motorVolts1        = obj.objectForKey("motor_voltage1") as? NSNumber
        info.motorVolts2        = obj.objectForKey("motor_voltage2") as? NSNumber
        info.boardID            = obj.objectForKey("boardID") as? NSNumber
        
        saveContext()
    }
    
    func addRidePoint(obj: NSDictionary) {
        let ridePoint = NSEntityDescription.insertNewObjectForEntityForName("RidePoint", inManagedObjectContext: sharedManager.context) as! RidePoint
        for (key,value) in obj {
            ridePoint.setValue(value, forKey: key as! String)
        }
        saveContext()
    }
    
    private func getRidePointsForKey(key:String, value:AnyObject) -> [RidePoint]?{
        let request = NSFetchRequest(entityName: "RidePoint")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "\(key) == \(value)")
        do {
            return try sharedManager.context.executeFetchRequest(request) as? [RidePoint]
        } catch{
            print(error as NSError)
            return nil
        }
    }
    
    func getRidePointInfo() -> [RidePoint] {
        var ary: [RidePoint] = [RidePoint]()
        let request = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("RidePoint", inManagedObjectContext: sharedManager.context)
        request.entity = entityDescription
        request.returnsObjectsAsFaults = false
        
        do {
            let results: NSArray = try sharedManager.context.executeFetchRequest(request)
            for i in 0  ..< results.count  {
                let info = results[i] as! RidePoint
                ary.append(info)
            }
            return ary
        } catch{
            print(error as NSError)
            return ary
        }
    }
    
    func getRidePointsForRideId(rideId:Int) -> [RidePoint] {
        let ridesArr = getRidePointsForKey("rideID", value: rideId)
        return ridesArr!
    }
    
    //update RidePoint data
    func updateRidePointStrInfo(userID: Int, key: String, value: String) {
        let request = NSFetchRequest(entityName: "RidePoint")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "userID == \(userID)")
        do {
            let results: NSArray = try sharedManager.context.executeFetchRequest(request)
            if results.count > 0 {
                let res = results[0] as! NSManagedObject
                res.setValue(value, forKey: key)
                saveContext()
            } else {print("error")}
        } catch{
            print(error as NSError)
        }
    }
    
    func updateRidePointNumberInfo(userID: Int, key: String, value: NSNumber) {
        let request = NSFetchRequest(entityName: "RidePoint")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "userID == \(userID)")

        do {
            let results: NSArray = try sharedManager.context.executeFetchRequest(request)
            if results.count > 0 {
                let res = results[0] as! NSManagedObject
                res.setValue(value, forKey: key)
                saveContext()
            } else {print("error")}
        } catch{
            print(error as NSError)
        }
    }
    
    
    //============================ Ride ================================//
    
    func saveRidesInfo(obj: NSDictionary) {
        let info = NSEntityDescription.insertNewObjectForEntityForName("Ride", inManagedObjectContext: sharedManager.context) as! Ride
        
        info.userID                 = obj.objectForKey(Constants.KEY_USERID) as? NSNumber
        info.boardID                = obj.objectForKey(Constants.KEY_BOARD_ID) as? NSNumber
        info.rideID                 = obj.objectForKey(Constants.KEY_RIDE_ID) as? NSNumber
        info.timestamp             = obj.objectForKey(Constants.KEY_TIMESTAMP) as? String
        info.tripDistance           = obj.objectForKey(Constants.KEY_TRIP_DIST) as? NSNumber
        info.tripDuration           = obj.objectForKey(Constants.KEY_TRIP_DURATION) as? NSNumber
        info.estimatedFinishStreet  = obj.objectForKey(Constants.KEY_EST_FINISH) as? String
        info.estimatedStartStreet   = obj.objectForKey(Constants.KEY_EST_START) as? String
        info.tempF                  = obj.objectForKey(Constants.KEY_TEMPF) as? NSNumber
        info.humidity               = obj.objectForKey(Constants.KEY_HUMIDITY) as? NSNumber
        info.rideName               = obj.objectForKey(Constants.KEY_RIDE_NAME) as? String
        //        info.ridePoints             = obj.objectForKey("") as? NSOrderedSet
        
        saveContext()
    }
    
    
    func getRidesInfo() -> [Ride] {
        var ary: [Ride] = [Ride]()
        let request = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("Ride", inManagedObjectContext: sharedManager.context)
        request.entity = entityDescription
        request.returnsObjectsAsFaults = false
        
        do {
            let results: NSArray = try sharedManager.context.executeFetchRequest(request)
            for i in 0  ..< results.count  {
                let info = results[i] as! Ride
                ary.append(info)
            }
            return ary
        } catch{
            print(error as NSError)
            return ary
        }
    }
    
    //update Ride data
    func updateRidesStrInfo(userID: Int, key: String, value: String) {
        let request = NSFetchRequest(entityName: "Ride")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "userID == \(userID)")
        do {
            let results: NSArray = try sharedManager.context.executeFetchRequest(request)
            if results.count > 0 {
                let res = results[0] as! NSManagedObject
                res.setValue(value, forKey: key)
                saveContext()
            } else {print("error")}
        } catch{
            print(error as NSError)
        }
    }
    
    func updateRidesNumberInfo(userID: Int, key: String, value: NSNumber) {
        let request = NSFetchRequest(entityName: "Ride")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "userID == \(userID)")
        do {
            let results: NSArray = try sharedManager.context.executeFetchRequest(request)
            if results.count > 0 {
                let res = results[0] as! NSManagedObject
                res.setValue(value, forKey: key)
                saveContext()
            } else {print("error")}
        } catch{
            print(error as NSError)
        }
    }
   
    
    //============================ Ride ================================// MARK: -Ride
    
    private func getRidesForKey(key:String, value:AnyObject) -> [Ride]?{
        let request = NSFetchRequest(entityName: "Ride")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "\(key) == \(value)")
        do {
            return try sharedManager.context.executeFetchRequest(request) as? [Ride]
        } catch{
            print(error as NSError)
            return nil
        }
    }
    
    func getRideForId(rideId:NSNumber) -> Ride? {
        let ridesArr = getRidesForKey("rideID", value: rideId)
        if ridesArr?.count > 0 {
            return ridesArr![0]
        }
        return nil
    }
    
    func saveRideInfo(obj: NSDictionary) {
        let rideId = obj.objectForKey(Constants.KEY_RIDE_ID) as! NSNumber
        var ride:Ride!
        
        if  getRideForId(rideId) != nil {
            ride = getRideForId(rideId)
        } else {
            ride = NSEntityDescription.insertNewObjectForEntityForName("Ride", inManagedObjectContext: sharedManager.context) as? Ride
        }
        for (key,value) in obj {
            ride.setValue(value, forKey: key as! String)
        }
        saveContext()
    }
    
    func updateRideInfo(rideId: Int, key: String, value: AnyObject) {
        let ride:Ride! = getRideForId(rideId)
        ride.setValue(value, forKey: key)
        saveContext()
    }
    
    func getAllRides() -> [Ride] {
        let request = NSFetchRequest(entityName: "Ride")
        request.returnsObjectsAsFaults = false
        do {
            return try sharedManager.context.executeFetchRequest(request) as! [Ride]
        } catch{
            print(error as NSError)
            return []
        }
    }
    
    //============================ utils ================================//
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
}
