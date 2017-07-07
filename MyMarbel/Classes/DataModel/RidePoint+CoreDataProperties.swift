//
//  RidePoint+CoreDataProperties.swift
//  MyMarbel
//
//  Created by Tmaas on 08/06/16.
//  Copyright © 2016 MBSolution. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension RidePoint {
    
    @NSManaged var timestamp: String?
    @NSManaged var rideID: NSNumber?
    @NSManaged var userID: NSNumber?
    @NSManaged var boardID: NSNumber?
    @NSManaged var accel: NSNumber?
    @NSManaged var mode: String?
    @NSManaged var speed: NSNumber?
    @NSManaged var rpm1: NSNumber?
    @NSManaged var rpm2: NSNumber?
    @NSManaged var motorDirection1: String?
    @NSManaged var motorDirection2: String?
    @NSManaged var motorAmps1: NSNumber?
    @NSManaged var motorAmps2: NSNumber?
    @NSManaged var motorVolts1: NSNumber?
    @NSManaged var motorVolts2: NSNumber?
    @NSManaged var odometer: NSNumber?
    @NSManaged var remoteBLEConnection: NSNumber?
    @NSManaged var internalTemperature: NSNumber?
    @NSManaged var remote: NSNumber?
    @NSManaged var esc1: NSNumber?
    @NSManaged var esc2: NSNumber?
    @NSManaged var voltage1: NSNumber?
    @NSManaged var voltage2: NSNumber?
    @NSManaged var voltage3: NSNumber?
    @NSManaged var voltage4: NSNumber?
    @NSManaged var voltage5: NSNumber?
    @NSManaged var voltage6: NSNumber?
    @NSManaged var voltage7: NSNumber?
    @NSManaged var voltage8: NSNumber?
    @NSManaged var voltage9: NSNumber?
    @NSManaged var voltage10: NSNumber?
    @NSManaged var voltage: NSNumber?
    @NSManaged var current: NSNumber?
    @NSManaged var wh: NSNumber?
    @NSManaged var errorFlag: NSNumber?
    @NSManaged var remoteBatteryLife: NSNumber?
    @NSManaged var latitude: String?
    @NSManaged var longitude: String?
    @NSManaged var elevation: NSNumber?
    @NSManaged var throttle: NSNumber?
    @NSManaged var bleConnectionStrength: NSNumber?
    @NSManaged var state: NSNumber?

    
}
