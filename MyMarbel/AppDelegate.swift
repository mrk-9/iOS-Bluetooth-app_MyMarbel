//
//  AppDelegate.swift
//  MyMarbel
//
//  Created by Tmaas on 11/05/16.
//  Copyright © 2016 MBSolution. All rights reserved.
//

import UIKit
import CoreData

import Fabric
import Crashlytics
import Mapbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // test data
    
    private func storeDummyData () {
        // Save Rides
        saveDemoRide(1, boardId: 1, rideId: 109, rideName: "Test Ride 1", timeStamp: getCurrentTimeString(), startStrt: "Start 1", tempF: 86, humidity: 50, distance: 1200, duration: 60, finishStrt: "Finish 1")
        saveDemoRide(2, boardId: 2, rideId: 2, rideName: "Test Ride 2", timeStamp: getCurrentTimeString(), startStrt: "Start 2", tempF: 80, humidity: 44, distance: 1000, duration: 100, finishStrt: "Finish 2")
        saveDemoRide(3, boardId: 3, rideId: 3, rideName: "Test Ride 3", timeStamp: getCurrentTimeString(), startStrt: "Start 3", tempF: 75, humidity: 60, distance: 1100, duration: 50, finishStrt: "Finish 3")
        saveDemoRide(4, boardId: 4, rideId: 4, rideName: "Test Ride 4", timeStamp: getCurrentTimeString(), startStrt: "Start 4", tempF: 90, humidity: 35, distance: 2000, duration: 80, finishStrt: "Finish 4")
        
        // save RidePoints

        saveDemoRidePoints("test1@test.com", accel: 12, speed: 1000, motorDirection: "h1", motorDirection2: "h2", elevation: 10, rideId: 1, state: "run", rpm: 30, rpm2: 20, odometer: 50, bleConnection: 1, internalTemprature: 100, motorTemp: 50, remote: 2, esc: 1, esc2: 1, voltage1: 220, voltage2: 440, voltage3: 220, voltage4: 440, voltage5: 440, voltage6: 440, voltage7: 1000, voltage8: 1000, voltage9: 1000, voltage10: 440, voltage: 440, currentAmps: 10, weight: 50, errorFlag: 0, batteryLife: 100, lat: "22.725598", lng: "75.894198", throttle: 20, bleStrength: 10, timeStamp: getCurrentTimeString(), motorAmps1: 20, motorAmps2: 22, motorVolt1: 120, motorVolt2: 160, userId: 1)
        saveDemoRidePoints("test1@test.com", accel: 12, speed: 2000, motorDirection: "h1", motorDirection2: "h2", elevation: 10, rideId: 1, state: "run", rpm: 30, rpm2: 20, odometer: 50, bleConnection: 1, internalTemprature: 100, motorTemp: 50, remote: 2, esc: 1, esc2: 1, voltage1: 220, voltage2: 440, voltage3: 220, voltage4: 440, voltage5: 440, voltage6: 440, voltage7: 1000, voltage8: 1000, voltage9: 1000, voltage10: 440, voltage: 440, currentAmps: 10, weight: 50, errorFlag: 0, batteryLife: 100, lat: "22.725598", lng: "75.894198", throttle: 20, bleStrength: 10, timeStamp: getCurrentTimeString(), motorAmps1: 20, motorAmps2: 22, motorVolt1: 120, motorVolt2: 160, userId: 1)
        saveDemoRidePoints("test1@test.com", accel: 12, speed: 1500, motorDirection: "h1", motorDirection2: "h2", elevation: 10, rideId: 1, state: "run", rpm: 30, rpm2: 20, odometer: 50, bleConnection: 1, internalTemprature: 100, motorTemp: 50, remote: 2, esc: 1, esc2: 1, voltage1: 220, voltage2: 440, voltage3: 220, voltage4: 440, voltage5: 440, voltage6: 440, voltage7: 1000, voltage8: 1000, voltage9: 1000, voltage10: 440, voltage: 440, currentAmps: 10, weight: 50, errorFlag: 0, batteryLife: 100, lat: "22.714598", lng: "75.892198", throttle: 20, bleStrength: 10, timeStamp: getCurrentTimeString(), motorAmps1: 20, motorAmps2: 22, motorVolt1: 120, motorVolt2: 160, userId: 1)
        saveDemoRidePoints("test1@test.com", accel: 12, speed: 3000, motorDirection: "h1", motorDirection2: "h2", elevation: 10, rideId: 1, state: "run", rpm: 30, rpm2: 20, odometer: 50, bleConnection: 1, internalTemprature: 100, motorTemp: 50, remote: 2, esc: 1, esc2: 1, voltage1: 220, voltage2: 440, voltage3: 220, voltage4: 440, voltage5: 440, voltage6: 440, voltage7: 1000, voltage8: 1000, voltage9: 1000, voltage10: 440, voltage: 440, currentAmps: 10, weight: 50, errorFlag: 0, batteryLife: 100, lat: "22.788598", lng: "75.844198", throttle: 20, bleStrength: 10, timeStamp: getCurrentTimeString(), motorAmps1: 20, motorAmps2: 22, motorVolt1: 120, motorVolt2: 160, userId: 1)
        saveDemoRidePoints("test1@test.com", accel: 12, speed: 500, motorDirection: "h1", motorDirection2: "h2", elevation: 10, rideId: 1, state: "run", rpm: 30, rpm2: 20, odometer: 50, bleConnection: 1, internalTemprature: 100, motorTemp: 50, remote: 2, esc: 1, esc2: 1, voltage1: 220, voltage2: 440, voltage3: 220, voltage4: 440, voltage5: 440, voltage6: 440, voltage7: 1000, voltage8: 1000, voltage9: 1000, voltage10: 440, voltage: 440, currentAmps: 10, weight: 50, errorFlag: 0, batteryLife: 100, lat: "22.711598", lng: "75.894100", throttle: 20, bleStrength: 10, timeStamp: getCurrentTimeString(), motorAmps1: 20, motorAmps2: 22, motorVolt1: 120, motorVolt2: 160, userId: 1)
        saveDemoRidePoints("test1@test.com", accel: 12, speed: 5400, motorDirection: "h1", motorDirection2: "h2", elevation: 10, rideId: 1, state: "run", rpm: 30, rpm2: 20, odometer: 50, bleConnection: 1, internalTemprature: 100, motorTemp: 50, remote: 2, esc: 1, esc2: 1, voltage1: 220, voltage2: 440, voltage3: 220, voltage4: 440, voltage5: 440, voltage6: 440, voltage7: 1000, voltage8: 1000, voltage9: 1000, voltage10: 440, voltage: 440, currentAmps: 10, weight: 50, errorFlag: 0, batteryLife: 100, lat: "22.720598", lng: "75.894178", throttle: 20, bleStrength: 10, timeStamp: getCurrentTimeString(), motorAmps1: 20, motorAmps2: 22, motorVolt1: 120, motorVolt2: 160, userId: 1)
        saveDemoRidePoints("test1@test.com", accel: 12, speed: 2055, motorDirection: "h1", motorDirection2: "h2", elevation: 10, rideId: 1, state: "run", rpm: 30, rpm2: 20, odometer: 50, bleConnection: 1, internalTemprature: 100, motorTemp: 50, remote: 2, esc: 1, esc2: 1, voltage1: 220, voltage2: 440, voltage3: 220, voltage4: 440, voltage5: 440, voltage6: 440, voltage7: 1000, voltage8: 1000, voltage9: 1000, voltage10: 440, voltage: 440, currentAmps: 10, weight: 50, errorFlag: 0, batteryLife: 100, lat: "22.705898", lng: "75.804098", throttle: 20, bleStrength: 10, timeStamp: getCurrentTimeString(), motorAmps1: 20, motorAmps2: 22, motorVolt1: 120, motorVolt2: 160, userId: 1)
    }
    
    func saveDemoRide (userId: Int, boardId: Int, rideId: Int, rideName: String, timeStamp: String, startStrt: String, tempF: Float, humidity: Float, distance: Double, duration: Double, finishStrt: String ) {
        
        CoreDataManager.getInstance().saveRideInfo([
            Constants.KEY_USERID: userId,
            Constants.KEY_BOARD_ID: boardId,
            Constants.KEY_RIDE_ID:rideId,
            Constants.KEY_TIMESTAMP: timeStamp,
            Constants.KEY_TRIP_DIST: distance,
            Constants.KEY_TRIP_DURATION: duration,
            Constants.KEY_EST_FINISH: finishStrt,
            Constants.KEY_EST_START: startStrt,
            Constants.KEY_TEMPF: tempF,
            Constants.KEY_HUMIDITY: humidity,
            Constants.KEY_RIDE_NAME: rideName,
            ])
        // for update
        CoreDataManager.getInstance().updateRideInfo(rideId, key: Constants.KEY_RIDE_NAME, value: "My \(rideName)")
    }

    func saveDemoRidePoints (mode:String, accel: Int, speed: Int,motorDirection:String,motorDirection2:String, elevation: Int,rideId:Int,state:String,rpm: Int,rpm2: Int,odometer: Int,bleConnection: Int,internalTemprature: Int,motorTemp: Int,remote: Int,esc: Int,esc2: Int,voltage1: Int,voltage2: Int,voltage3: Int,voltage4: Int,voltage5: Int,voltage6: Int,voltage7: Int,voltage8: Int,voltage9: Int,voltage10: Int,voltage: Int,currentAmps: Int,weight: Float,errorFlag: Int,batteryLife: Int,lat: String,lng: String,throttle: Int,bleStrength: Int,timeStamp: String,motorAmps1: Int,motorAmps2: Int,motorVolt1: Int,motorVolt2: Int,userId: Int) {
        //init Ride data
        let ridePointInfo : NSDictionary = [
                                   Constants.KEY_EMAIL                  : myEmail,
                                   Constants.KEY_MODE                   : mode,
                                   Constants.KEY_BOARD_ID               : 123,
                                   Constants.KEY_ACCEL                  : accel,
                                   Constants.KEY_SPEED                  : speed,
                                   Constants.KEY_MOTOR_DIRECTION        : motorDirection,
                                   Constants.KEY_MOTOR_DIRECTION2       : motorDirection2,
                                   Constants.KEY_ELEVATION              : elevation,
                                   Constants.KEY_RIDE_ID                : 109,
                                   Constants.KEY_STATE                  : state,
                                   Constants.KEY_RPM                    : rpm,
                                   Constants.KEY_RPM2                   : rpm2,
                                   Constants.KEY_ODOMETER               : odometer,
                                   Constants.KEY_REMOTE_BLE_CONNECTION  : bleConnection,
                                   Constants.KEY_INTERNAL_TEMPERATURE   : internalTemprature,
                                   Constants.KEY_MOTOR_TEMP             : motorTemp,
                                   Constants.KEY_REMOTE                 : remote,
                                   Constants.KEY_ESC                    : esc,
                                   Constants.KEY_ESC2                   : esc2,
                                   Constants.KEY_VOLTAGE1               : voltage1,
                                   Constants.KEY_VOLTAGE2               : voltage2,
                                   Constants.KEY_VOLTAGE3               : voltage3,
                                   Constants.KEY_VOLTAGE4               : voltage4,
                                   Constants.KEY_VOLTAGE5               : voltage5,
                                   Constants.KEY_VOLTAGE6               : voltage6,
                                   Constants.KEY_VOLTAGE7               : voltage7,
                                   Constants.KEY_VOLTAGE8               : voltage8,
                                   Constants.KEY_VOLTAGE9               : voltage9,
                                   Constants.KEY_VOLTAGE10              : voltage10,
                                   Constants.KEY_VOLTAGE                : voltage,
                                   Constants.KEY_CURRENT_AMPS           : currentAmps,
                                   Constants.KEY_WH                     : weight,
                                   Constants.KEY_ERROR_FLAG             : errorFlag,
                                   Constants.KEY_REMOTE_BATTERY_LIFE    : batteryLife,
                                   Constants.KEY_LATITUDE               : lat,
                                   Constants.KEY_LONGITUDE              : lng,
                                   Constants.KEY_THROTTLE               : throttle,
                                   Constants.KEY_BLE_STRENGTH           : bleStrength,
                                   Constants.KEY_TIMESTAMP              : timeStamp,
                                   Constants.KEY_MOTOR_AMPS1            : motorAmps1,
                                   Constants.KEY_MOTOR_AMPS2            : motorAmps2,
                                   Constants.KEY_MOTOR_VOLT1            : motorVolt1,
                                   Constants.KEY_MOTOR_VOLT2            : motorVolt2,
                                   Constants.KEY_USERID                 : userId
        ]
        CoreDataManager.getInstance().saveRidePointInfo(ridePointInfo)

    }
    
    // test data end
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        Fabric.with([MGLAccountManager.self, Crashlytics.self])

//        storeDummyData()
        
        // Override point for customization after application launch.
        
        isFirstOdoMeter = false
        isStartNewRide = false

        ///////////////////////////////////////////////////
        //This code is copied from Mattew branch
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let onboardingStatus = defaults.boolForKey("isOnboard")
        let connectionStatus = defaults.boolForKey("boardConnection")
        let rideStatus = defaults.boolForKey("rideStatus")
        
        if(onboardingStatus == true && connectionStatus != true)
        {
            
            //call a function that should look for bluetooth connection.  If it doesn’t find anything within first 30 seconds… it cycles on and off for 15 seconds every 45 seconds (basically one check per minute)
            print("didFinishLaunchingWithOptions starting Scan")
//            createRide() //marked for test
            MBluetoothManager.sharedInstance.startScan()
            
        }
        
        if(connectionStatus == true && rideStatus == false)
        {
            print("background looking for ride start")
            //0) start reading BLE data every second
            //1) get odometer value from skateboard... if it changes more than 0.05 miles it might be a ride... proceed to #2 check
            //2) start location updates... if the location moves more than 20 meters... it is officially a ride... procees to #3
            //3) start updating Ride Points ever second and call the startRide() function in RideManager.swift
            //4) set rideStatus flag to true
        }
        
        if(connectionStatus == false && rideStatus == true)
        {
            print("background looking for ride end")
            //1) if the connectionStatus has been false for 2 minutes... then the ride is likely over.
            //2) subtract the last 2 minutes (120) from the Ride Points... and call the endRide() function in RideManager.swift
        }
        

        
        ///////////////////////////////////////////////////
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        ///////////////////////////////////////////////////
        //This code is copied from Mattew branch
        
        //every 45 seconds... scan bluetooth for 15 seconds... if you find something... connect.
        //if connected
        // check odometer and board battery % for movement and an update every 1 seconds
        //if movement start location tracking adn initiate the start of a "ride" in core data.
        //just records data into CoreData
        
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let onboardingStatus = defaults.boolForKey("isOnboard")
        let connectionStatus = defaults.boolForKey("boardConnection")
        let rideStatus = defaults.boolForKey("rideStatus")
        
        if(onboardingStatus == true && connectionStatus != true)
        {
            print("appliecationDidEnterBackground starting Scan")
//            createRide()
            MBluetoothManager.sharedInstance.startScan()
        }
        
        if(connectionStatus == true && rideStatus == false)
        {
           print("background looking for ride start")
             //0) start reading BLE data every second
            //1) get odometer value from skateboard... if it changes more than 0.05 miles it might be a ride... proceed to #2 check
            //2) start location updates... if the location moves more than 20 meters... it is officially a ride... procees to #3 
            //3) start updating Ride Points ever second and call the startRide() function in RideManager.swift
            //4) set rideStatus flag to true
        }
        
        if(connectionStatus == false && rideStatus == true)
        {
             print("background looking for ride end")
            //1) if the connectionStatus has been false for 2 minutes... then the ride is likely over.
            //2) subtract the last 2 minutes (120) from the Ride Points... and call the endRide() function in RideManager.swift
        }
        
       
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        ///////////////////////////////////////////////////
        //This code is copied from Mattew branch
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let onboardingStatus = defaults.boolForKey("isOnboard")
        let connectionStatus = defaults.boolForKey("boardConnection")
        let rideStatus = defaults.boolForKey("rideStatus")
        
        if(onboardingStatus == true && connectionStatus != true)
        {
            
            //call a function that should look for bluetooth connection.  If it doesn’t find anything within first 30 seconds… it cycles on and off for 15 seconds every 45 seconds (basically one check per minute)
            print("appliecationDidBecomeActive starting Scan")
//            createRide()
            MBluetoothManager.sharedInstance.startScan()
            
        }
        
        if(connectionStatus == true && rideStatus == false)
        {
            print("app active looking for ride start")
             //0) start reading BLE data every second
            //1) get odometer value from skateboard... if it changes more than 0.05 miles it might be a ride... proceed to #2 check
            //2) start location updates... if the location moves more than 20 meters... it is officially a ride... procees to #3
            //3) start updating Ride Points ever second and call the startRide() function in RideManager.swift
            //4) set rideStatus flag to true
        }
        
        if(connectionStatus == false && rideStatus == true)
        {
            print("app active looking for ride end")
            //1) if the connectionStatus has been false for 2 minutes... then the ride is likely over.
            //2) subtract the last 2 minutes (120) from the Ride Points... and call the endRide() function in RideManager.swift
        }
        

        
        ///////////////////////////////////////////////////
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        
        ///////////////////////////////////////////////////
        //This code is copied from Mattew branch
        
        ///////////////////////////////////////////////////
        
        MBluetoothManager.sharedInstance.cleanup()
        
        self.saveContext()
    }

   

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.app.MyMarbel" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("MyMarbel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as! NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
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

