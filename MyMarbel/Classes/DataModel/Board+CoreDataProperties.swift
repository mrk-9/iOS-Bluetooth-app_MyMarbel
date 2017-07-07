//
//  Board+CoreDataProperties.swift
//  MyMarbel
//
//  Created by Tmaas on 01/06/16.
//  Copyright © 2016 MBSolution. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Board {

    @NSManaged var userID: NSNumber?
    @NSManaged var boardID: NSNumber?
    @NSManaged var boardName: String?
    @NSManaged var timestamp: String?
    @NSManaged var firmwareVersion: String?
    @NSManaged var mainSerialNumber: String?
    @NSManaged var wheelSize: String?
    @NSManaged var odometer: String?
    @NSManaged var duration: NSNumber?
    @NSManaged var rideCount: NSNumber?
    @NSManaged var batteryChargeCount: NSNumber?
    @NSManaged var lockStatus: NSNumber? //bool
    @NSManaged var parentLockStatus: NSNumber? //bool
    @NSManaged var batterySerialNumber: String?
    @NSManaged var motorVersionNumber: String?
    @NSManaged var circuitVersionNumber: String?
    @NSManaged var deckVersionNumber: String?
    @NSManaged var productionDate: String?

}
