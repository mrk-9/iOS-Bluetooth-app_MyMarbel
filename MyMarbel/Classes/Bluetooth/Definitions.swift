//
//  Definitions.swift
//  Bluetooth
//
//  Created by Tmaas on 24/05/16.
//  Copyright © 2016 MBSolution. All rights reserved.
//

import CoreBluetooth

let MS_UUID                         = CBUUID(string: "4BBC0955-9038-4394-9EA9-F3921863A402")
let MS_BATTERY_SERVICE_UUID         = CBUUID(string: "180F")
let MS_BATTERY_CHARACTERISTIC_UUID  = CBUUID(string: "2A19")
let MS_DEVICE_INFO_SERVICE_UUID     = CBUUID(string: "180A")
let MS_SERIAL_CHARACTERISTIC_UUID   = CBUUID(string: "2A25")
let MS_FIRMWARE_CHARACTERISTIC_UUID = CBUUID(string: "2A26")

// ************************************************** \\
//      Marbel Private READ Characteristics           \\
// ************************************************** \\
let MS_EEPROM_UUID                  = CBUUID(string: "1FC2F695-3A7B-4EF3-8C00-556E16301344")
let MS_ODOMETER_UUID                = CBUUID(string: "1DE12955-09BA-4F2F-91C1-0B323F953162")
let MS_TRIP_UUID                    = CBUUID(string: "8C19029A-E9CA-11E4-B02C-1681E6B88EC1")
let MS_REMOTE_BATTERY_UUID          = CBUUID(string: "6A23E786-01E5-4D4D-97BF-97FC80BDE5E1")
let MS_BOARD_LOCK_READ_UUID         = CBUUID(string: "D8610E4C-C8A3-46B1-BB58-137AAC1A2F61")

// ************************************************** \\
//     Marbel Private WRITE Characteristics           \\
// ************************************************** \\
let MS_ACCEL_UUID                   = CBUUID(string: "F56B69C7-8E75-4635-AC4B-0C82B8179F3E")
let MS_SPEED_UUID                   = CBUUID(string: "EA2E254E-1DC8-4CE2-BC39-34D73D897EC4")
let MS_BOARD_LOCK_WRITE_UUID        = CBUUID(string: "D4209C45-9C7F-4389-916B-7423C45CEEA4")
let MS_WHEEL_SIZE_WRITE_UUID        = CBUUID(string: "7A721C02-8A5C-4E28-94A4-09EE8D987F93")
let MS_MOTION_CONTROL_WRITE_UUID    = CBUUID(string: "D970E78A-93C4-4C71-BF4A-38DA45ADD4DE")

let SCAN_ON_TIME = 15
let SCAN_OFF_TIME = 45

let MS_MILE_RANGE  = 16