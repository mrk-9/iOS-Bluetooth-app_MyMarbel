//
//  User+CoreDataProperties.swift
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

extension User {
    @NSManaged var userID: NSNumber?
    @NSManaged var userEmail: String?
    @NSManaged var password: String?
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var avatar: String?
    @NSManaged var height: String?
    @NSManaged var weight: String?
    @NSManaged var terrain: String?
    @NSManaged var bio: String?
    @NSManaged var city: String?
    @NSManaged var state: String?
    @NSManaged var country: String?
    @NSManaged var phoneNumber: String?
    @NSManaged var primaryRideStyle: String?
    @NSManaged var milesRidden: String?
    @NSManaged var locationEnable: NSNumber?
    @NSManaged var units: String?
    @NSManaged var rangeAlarm: String?
    @NSManaged var notificationEnable: NSNumber?
    @NSManaged var safetyBrake: NSNumber?
    @NSManaged var brakingForce: String?
    @NSManaged var reverseTurned: NSNumber?
    @NSManaged var timestamp: String?

}
