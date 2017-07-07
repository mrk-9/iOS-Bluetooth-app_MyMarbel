//
//  Ride+CoreDateProperties.swift
//  MyMarbel
//
//  Created by Matt Belcher on 7/9/16.
//  Copyright © 2016 MBSolution. All rights reserved.
//



import Foundation
import CoreData

extension Ride {
    
    
    @NSManaged var rideID:	NSNumber?
    @NSManaged var userID:	NSNumber?
    @NSManaged var boardID:	NSNumber?
    @NSManaged var timestamp:	String?
    @NSManaged var tripDistance:	NSNumber? // meter
    @NSManaged var tripDuration:	NSNumber? // minutes
    @NSManaged var estimatedStartStreet:	String?
    @NSManaged var estimatedFinishStreet:	String?
    @NSManaged var tempF:	NSNumber?
    @NSManaged var humidity:	NSNumber?
    @NSManaged var rideName:	String?
    @NSManaged var ridePoints:	NSOrderedSet?
    
    
    
    //not sure we should put things like averages... 
    //of @NSManaged var efficiencyScore:	NSNumber?
    //probabaly best to calculate on the fly... incase we cahnge how we calculate in the future. 
    
    
}
