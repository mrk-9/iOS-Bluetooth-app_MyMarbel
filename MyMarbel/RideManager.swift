//
//  RidePointManager.swift
//  MyMarbel
//
//  Created by Matt Belcher on 7/9/16.
//  Copyright © 2016 MBSolution. All rights reserved.
//

import Foundation

//var rideDataSet = NSOrderedSet()


var ridePoints = [NSObject]()
var  ridePoint = [0, "rideID", "userID", "boardID", "accel", "speed", "mode", "rpm1", "rpm2", "motorDirection1", "motorDirection2", "motorAmps1", "motorAmps2", "motorVolts1", "motorVolts2", "odometer", "remoteBLEConnection", "internatlTemperature", "remote", "esc1", "esc2", "voltage1", "voltage2", "voltage3", "voltage4", "voltage5", "voltage6", "voltage7", "voltage8", "voltage9", "voltage10", "voltage", "current", "wh", "errorFlag", "remoteBatteryLife", "latitude", "longitude", "elevation", "throttle", "bleConnectionStrength", "state" ]

var counter = 0



class RideManager: NSObject {

    static var sharedInstance : RideManager! = RideManager();

    func createRidePoint()
    {
        counter += 1

        //find all the rie data and put it into an array
           
            //timestamp... the current second in Unix
            ridePoint[0] = Int(NSDate().timeIntervalSince1970)
           //rideID... the ID number of this ride.... an INT
            ridePoint[1] = "rideID"
            //userID... who is connected and riding the board
            ridePoint[2] = "userID"
            //boardID... which board is connected and being rode
            ridePoint[3] = "boardID"
            //accel... the current acceleration setting of the board
            ridePoint[4] = "accel"
            //speed... the current max speed setting of the board
            ridePoint[5] = "speed"
            //mode... the current mode of the board
            ridePoint[6] = "mode"
            //rpm1... the RPM of the motor
            ridePoint[7] = "rpm1"
            //rpm2... the RPM of the second motor (only on certain boards)
            ridePoint[8] = "rpm2"
            //motorDirection1... the rotational direction of the motor
            ridePoint[9] = "motorDirection1"
            //motorDirection2... the rotational direction of the second motor
            ridePoint[10] = "motorDirection2"
            //motorAmps1... the current inside the motor
            ridePoint[11] = "motorAmps1"
            //motorAmps2... the current inside the second motor (only on certain boards)
            ridePoint[12] = "motorAmps2"
            //motorVolts1... the voltage inside the motor
            ridePoint[13] = "motorVolts1"
            //motorVolts2... the voltage inside the second motor (only on certain boards)
            ridePoint[14] = "motorVolts2"
            //odometer... the odomater of the board
            ridePoint[15] = "odometer"
            //remoteBLEConnection... the connection strength between the remote and the board
            ridePoint[16] = "remoteBLEConnection"
            //internalTemperature... the temperature in F inside the board
            ridePoint[17] = "internalTemperature"
            //remote... the throttle value that was received from the remote to the board
            ridePoint[18] = "remote"
            //esc1... the actual value sent to the ESC
            ridePoint[19] = "esc1"
            //esc2... the actual value sent to the second ESC (only on certain boards)
            ridePoint[20] = "esc2"
            //voltage1... the voltage on cell 1-10
            ridePoint[21] = "voltage1"
            //voltage2... the voltage on cell 1-10
            ridePoint[22] = "voltage2"
            //voltage3... the voltage on cell 1-10
            ridePoint[23] = "voltage3"
            //voltage4... the voltage on cell 1-10
            ridePoint[24] = "voltage4"
            //voltage5... the voltage on cell 1-10
            ridePoint[25] = "voltage5"
            //voltage6... the voltage on cell 1-10
            ridePoint[26] = "voltage6"
            //voltage7... the voltage on cell 1-10
            ridePoint[27] = "voltage7"
            //voltage8... the voltage on cell 1-10
            ridePoint[28] = "voltage8"
            //voltage9... the voltage on cell 1-10
            ridePoint[29] = "voltage9"
            //voltage10... the voltage on cell 1-10
            ridePoint[30] = "voltage10"
            //voltage... the voltage on the entire battery system
            ridePoint[31] = "voltage"
            //current... the current on the entire battery system
            ridePoint[32] = "current"
            //wh... the watt hours left inside the battery system
            ridePoint[33] = "wh"
            //errorFlag... any error that might be thrown
            ridePoint[34] = "errorFlag"
            //remoteBatteryLife... the battery percentage left in the remote
            ridePoint[35] = "remoteBatteryLife"
            //latitude... the current latitude of this iPhone
            ridePoint[36] = "latitude"
            //longitude... the current longitude of this iPhone
            ridePoint[37] = "longitude"
            //elevation... the current elevation of this iPhone
            ridePoint[38] = "elevation"
            //throttle... the throttle value being sent from this iPhone to the board (not always active)
            ridePoint[39] = "throttle"
            //bleConnectionStrength... the connection strength of this iPhone to the board (RSSI)
            ridePoint[40] = "bleConnectionStrength"
            //state... the current state of the board... can be charging, powered off, turning on, rebooting, etc...
            ridePoint[41] = "state"
            
     //   print("appending")
        
        ridePoints.append(ridePoint)
        
    //    print("appended")
        
        
        
        //send data to API for each created Ride Point. If there is an issue we can try to resend later as a "full ride"
        
        if(counter == 10)
        {
            showMeWhatYouGot()
        }
        
    }
    
    func showMeWhatYouGot()
    {
    
    print(ridePoints)
    
    }
    
    // called only in AppDelegate so it can run in background and in ANY screen.  You cannot end a Ride Manually. 
    func endRide()
    {
            
           // save the ride to CoreData?
            // make any updates to other CoreData sections... like board odometer... current settings... user ride distance... etc...
            
    }
    
    // called only in AppDelegate so it can run in background and in ANY screen.  You cannot start a Ride Manually.
    func startRide()
    {
        //actions to perform at the start of a ride
        
        //sends an initiation on API to start a ride... this returns the RideID that should be used on all RidePoints to keep it organizded and indexed
        
        //begin tracking location and updating with location manager... this might be called some place else...
        
        //clear any previous ridepoints in side the ridepoints array
        
       
    }
    
    
    func efficiencyScore()
    {
        //return efficiency score based on ridepoints in the array
        //use averageSpeed, Energy Used, and Range. 
        //
    }
    func averageSpeed()
    {
    //return average speed in MPH based on ridepoints in the array
    }
    
    func energyUsed()
    {
        //return energy based on ridepoints in the array
    }
    
    func rideDistanace()
    {
        //return trip distance based on ridepoints in the array
    }
    func rideDuration()
    {
        //return trip duraction in seconds based on ridepoints in the array
    }
    func maxSpeed()
    {
        //return max SPeed based on ridepoints in the array... using latitude/longitude and RPM
    }
    func maxIncline()
    {
        //return maximum incline based on elevation changes over a period of time
    }
    func elevationGain()
    {
        //return total elevation gain based on ridepoints in the array
    }
    func speedOver20Mph()
    {
        //return time in seconds of how long above based on ridepoints in the array
    }


}//end RideManager