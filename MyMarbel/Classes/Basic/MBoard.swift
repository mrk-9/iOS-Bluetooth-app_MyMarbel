//
//  MBoard.swift
//  MyMarbel
//
//  Created by tmaas on 25/05/16.
//  Copyright © 2016 MBSolution. All rights reserved.
//

import UIKit

class MBoard: NSObject {
    var isConnected : Bool?
    var isLocked : Bool?
    var batteryLevel : NSInteger?
    var remoteBatteryLevel : NSInteger?
    var milesLeft : NSInteger?
    var accelerationLevel : NSInteger?
    var speedLevel : NSInteger?
    var currentMode : M_MODE?
}

enum M_MODE : Int {
    case MSStarterMode  = 0
    case MSEcoMode      = 1
    case MSSportMode    = 2
    case MSCustomMode   = 3
}