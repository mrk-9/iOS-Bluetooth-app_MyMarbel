//
//  MBluetoothManager.swift
//  MyMarbel
//
//  Created by Tmaas on 24/05/16.
//  Copyright © 2016 MBSolution. All rights reserved.
//

import UIKit
import CoreBluetooth

var connected = false

var lastRidePointEntryDateTime = NSDate()


class MBluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate { //
    
    private var centralManager      : CBCentralManager?
    private var marbelPeripheral    : CBPeripheral?
    
    var discoveredPeripherals: NSMutableArray!
    
    var serialNumberCharacteristic      : CBCharacteristic?
    var batteryCharacteristic           : CBCharacteristic?
    var eepromCharacteristic            : CBCharacteristic?
    var accelCharacteristic             : CBCharacteristic?
    var speedCharacteristic             : CBCharacteristic?
    var odometerCharacteristic          : CBCharacteristic?
    var tripCharacteristic              : CBCharacteristic?
    var remoteBatteryCharacteristic     : CBCharacteristic?
    var wheelSizeWriteCharacteristic    : CBCharacteristic?
    var wheelSizeReadCharacteristic     : CBCharacteristic?
    var nameCharacteristic              : CBCharacteristic?
    var boardLockWriteCharacteristic    : CBCharacteristic?
    var boardLockReadCharacteristic     : CBCharacteristic?
    var firmwareCharacteristic          : CBCharacteristic?
    var motionControlCharacteristic     : CBCharacteristic?
    
    var onScanCounter = 0
    var offScanCounter = 0
//    var connected = false
    
    var everySecondTimer = NSTimer()
    var updateTimer = NSTimer()
    
    var batteryUpdateTimer: NSTimer?
    var scanning: Bool?
    
    var board: MBoard?
    
    class var sharedInstance: MBluetoothManager {
        struct Static {
            static let instance: MBluetoothManager = MBluetoothManager()
        }
        
        return Static.instance
    }
    
    override init() {
        super.init()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        discoveredPeripherals = NSMutableArray()
        
        everySecondTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(updateCounters), userInfo: nil, repeats: true)
    }
    
    func updateCounters (){
        if (!connected)
        {
            
            if scanning == true
            {
               // print("counters updated : Scanning On")
                onScanCounter += 1
                if onScanCounter >= SCAN_ON_TIME
                {
                    print("moving from updateCounters to stopTheScan")
                    stopTheScan()
                    
                }
            }
            else
            {
               // print("counters updated : Scanning Off")
                offScanCounter += 1
                if offScanCounter >= SCAN_OFF_TIME
                {
                    print("moving from updateCounters to startScan")
                    startScan()
                }
            }
        }
        else
        {
            //read all updates.... and deserialize.
            
            if currentRideId > 0 {
                let currentDateDate = NSDate()
                let currentTime = Int64(currentDateDate.timeIntervalSince1970)
                let entryTime = Int64(lastRidePointEntryDateTime.timeIntervalSince1970)
                let diff = (currentTime - entryTime)
                
                if diff > 60*2 {
                    print("Ride Ended")
                    
                    currentRideId = 0
                    
                    
                    let service: RestApiManager = RestApiManager.init()
                    service.updateRide({ (rideId, status) in
                        service.updateRidePoints({ (success) in
                            currentRideId = -1

                        })
                        
                    })
                }
            }
        }
    }
    
    /** 
     *   Scan for peripherals - specifically for our service's 128bit CBUUID
     */
    func startScan() {
        
        if let central = centralManager {
            central.scanForPeripheralsWithServices([MS_UUID], options: nil)
            
            scanning = true
            offScanCounter = 0
            
            print("Scanning started in startScan")
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(Constants.MSSearchingNotification, object: nil)

    }
    
    func cancelScan() {
        
        if ((self.centralManager) != nil)
        {
            scanning = false
            
            self.centralManager?.stopScan()
            
            // Post a notification saying that scanning stopped and didnt find anything
            NSNotificationCenter.defaultCenter().postNotificationName(Constants.MSDidDisconnectNotification, object: nil)
            
            print("Scanning stopped in cancelScan")
        }
    }
    
    func stopTheScan()
    {
        self.centralManager!.stopScan()
        scanning = false
        onScanCounter = 0
        print("Scanning stopped in stopTheScan and will start Scanning again in 45 seconds")
        
    }
    
    /** Call this when things either go wrong, or you're done with the connection.
     *  This cancels any subscriptions if there are any, or straight disconnects if not.
     */
    func cleanup() {
        // Don't do anything if we're not connected
        // self.discoveredPeripheral.isConnected is deprecated
        if marbelPeripheral?.state != CBPeripheralState.Connected { // explicit enum required to compile here?
            return
        }
        
        // See if we are subscribed to a characteristic on the peripheral
        if let services = marbelPeripheral?.services as [CBService]? {
            for service in services {
                if let characteristics = service.characteristics as [CBCharacteristic]? {
                    for characteristic in characteristics {
                        if characteristic.UUID.isEqual(MS_BATTERY_CHARACTERISTIC_UUID) && characteristic.isNotifying {
                            marbelPeripheral?.setNotifyValue(false, forCharacteristic: characteristic)
                            // And we're done.
                            return
                        }
                    }
                }
            }
        }
        
        // If we've got this far, we're connected, but we're not subscribed, so we just disconnect
        centralManager?.cancelPeripheralConnection(marbelPeripheral!)
    }
    
    func stopCollecting() {
        batteryUpdateTimer?.invalidate()
    }
    
    func clearDevices() {
        //        self.bleService = nil
        //        self.peripheralBLE = nil
    }
    
    
    // MARK: - CBCentralManagerDelegate Methods

    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        switch (central.state) {
        case CBCentralManagerState.PoweredOff:
            self.clearDevices()
            // Set isConnected Bool to false
            self.board?.isConnected = false
            
        case CBCentralManagerState.Unauthorized:
            // Indicate to user that the iOS device does not support BLE.
            break
            
        case CBCentralManagerState.Unknown:
            // Wait for another event
            break
            
        case CBCentralManagerState.PoweredOn:
            self.startScan()
            
        case CBCentralManagerState.Resetting:
            self.clearDevices()
            
        case CBCentralManagerState.Unsupported:
            break
        }
    }
    
    
    /**
     *  We check the RSSI, to make sure it's close enough that we're interested in it, and if it is,
     *  we start the connection process
     */
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        
        print("Discovered Peripheral \(peripheral)")
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let homeBoard = defaults.objectForKey(Constants.MS_HOME_BOARD_IDENTIFIER)
        
        if homeBoard == nil {
            // Save a local copy of the peripheral, so CoreBluetooth doesn't get rid of it
            marbelPeripheral = peripheral
            
            // Connect to peripherial
            centralManager?.connectPeripheral(peripheral, options: nil)
        } else if (homeBoard as! String) == peripheral.identifier.UUIDString {
            if marbelPeripheral != peripheral {
                // Save a local copy of the peripheral, so CoreBluetooth doesn't get rid of it
                marbelPeripheral = peripheral
                
                // Connect to peripherial
                centralManager?.connectPeripheral(peripheral, options: nil)
            }
        } else {
            // Add discovered peripheral to list
            self.discoveredPeripherals.addObject(peripheral)
        }
        
    }
    
    /** If the connection fails for whatever reason, we need to deal with it.
     */
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("Failed to connect to \(peripheral). (\(error!.localizedDescription))")
        
        cleanup()
    }
    
    /** We've connected to the peripheral, now we need to discover the services and characteristics to find the 'transfer' characteristic.
     */
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        
        // Stop scanning
        centralManager?.stopScan()
        print("Scanning stopped in cental manager")
        
        print("Peripheral Connected to \(peripheral)")
        
        // Set the home board and SN
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(peripheral.identifier.UUIDString, forKey: Constants.MS_HOME_BOARD_IDENTIFIER)
        defaults.setObject(peripheral.name, forKey: Constants.MS_SERIAL_NUMBER)
        defaults.setBool(true, forKey: "boardConnection")
        defaults.synchronize()
//        CoreDataManager.getInstance().updateBoardStrInfo(myUserID, key: Constants.KEY_MAIN_SN, value: peripheral.name!)
        
        // Set the scanning bool flag
        scanning = false
        
        //stops the scanning timers because the peripheral is connected
        onScanCounter = 0
        
        // Set isConnected Bool to true
        self.board?.isConnected = true
        connected = true
        
        // Post a notification saying we connected to a marbel board
        NSNotificationCenter.defaultCenter().postNotificationName(Constants.MSDidConnectNotification, object: nil)
        
        // Make sure we get the discovery callbacks
        peripheral.delegate = self
        
        // Search only for services that match our UUID
        peripheral.discoverServices([MS_UUID, MS_BATTERY_SERVICE_UUID, MS_DEVICE_INFO_SERVICE_UUID])
    }
    
    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("Peripheral Disconnected")
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(false, forKey: "boardConnection")
        defaults.synchronize()
        
        
        // Set isConnected Bool to false
        self.board?.isConnected = false
        connected = false
        
        // Reset variables
        marbelPeripheral = nil
        
        self.accelCharacteristic = nil
        self.speedCharacteristic = nil
        self.batteryCharacteristic = nil
        self.eepromCharacteristic = nil
        self.serialNumberCharacteristic = nil
        self.firmwareCharacteristic = nil
        self.odometerCharacteristic = nil
        self.tripCharacteristic = nil
        self.remoteBatteryCharacteristic = nil
        self.wheelSizeReadCharacteristic = nil
        self.wheelSizeWriteCharacteristic = nil
        self.nameCharacteristic = nil
        self.boardLockReadCharacteristic = nil
        self.boardLockWriteCharacteristic = nil
        self.motionControlCharacteristic = nil
        
        // We're disconnected, so start scanning again
        startScan()
    }
    
    /** The Transfer Service was discovered
     */
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        if let error = error {
            print("Error discovering services: \(error.localizedDescription)")
            cleanup()
            return
        }
        
        // Discover the characteristic we want...
        
        // Loop through the newly filled peripheral.services array, just in case there's more than one.
        for service in peripheral.services as [CBService]! {
            if  service.UUID.isEqual(MS_UUID) {
                peripheral.discoverCharacteristics([MS_EEPROM_UUID,
                    MS_ACCEL_UUID,
                    MS_SPEED_UUID,
                    MS_WHEEL_SIZE_WRITE_UUID,
                    MS_BOARD_LOCK_READ_UUID,
                    MS_BOARD_LOCK_WRITE_UUID,
                    MS_ODOMETER_UUID,
                    MS_TRIP_UUID,
                    MS_REMOTE_BATTERY_UUID,
                    MS_MOTION_CONTROL_WRITE_UUID], forService: service)
            } else if service.UUID.isEqual(MS_BATTERY_SERVICE_UUID) {
                peripheral.discoverCharacteristics([MS_BATTERY_CHARACTERISTIC_UUID], forService: service)
            } else if service.UUID.isEqual(MS_DEVICE_INFO_SERVICE_UUID) {
                peripheral.discoverCharacteristics([MS_SERIAL_CHARACTERISTIC_UUID, MS_FIRMWARE_CHARACTERISTIC_UUID], forService: service)
            } else {
                print("Not Match!")
            }
            
        }
        print("Matched services!")

    }
    
    /** The Transfer characteristic was discovered.
     *  Once this has been found, we want to subscribe to it, which lets the peripheral know we want the data it contains
     */
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        // Deal with errors (if any)
        if let error = error {
            print("Error discovering characteristics for services: \(error.localizedDescription)")
            cleanup()
            return
        }
        
        if  service.UUID.isEqual(MS_UUID) {
            // Again, we loop through the array, just in case.
            for characteristic in service.characteristics as [CBCharacteristic]! {
                // And check if it's the right one
                if characteristic.UUID.isEqual(MS_EEPROM_UUID) {
                    self.eepromCharacteristic = characteristic
                    peripheral.readValueForCharacteristic(characteristic)
                    peripheral.setNotifyValue(true, forCharacteristic: characteristic as CBCharacteristic)
                } else if characteristic.UUID.isEqual(MS_SPEED_UUID) {
                    self.speedCharacteristic = characteristic
                } else if characteristic.UUID.isEqual(MS_ACCEL_UUID) {
                    self.accelCharacteristic = characteristic
                } else if characteristic.UUID.isEqual(MS_WHEEL_SIZE_WRITE_UUID) {
                    self.wheelSizeWriteCharacteristic = characteristic
                } else if characteristic.UUID.isEqual(MS_BOARD_LOCK_READ_UUID) {
                    self.boardLockReadCharacteristic = characteristic
                    peripheral.readValueForCharacteristic(characteristic)
                } else if characteristic.UUID.isEqual(MS_BOARD_LOCK_WRITE_UUID) {
                    self.boardLockWriteCharacteristic = characteristic
                } else if characteristic.UUID.isEqual(MS_ODOMETER_UUID) {
                    self.odometerCharacteristic = characteristic
                    peripheral.readValueForCharacteristic(characteristic)
                    peripheral.setNotifyValue(true, forCharacteristic: characteristic as CBCharacteristic)
                } else if characteristic.UUID.isEqual(MS_TRIP_UUID) {
                    self.tripCharacteristic = characteristic
                    peripheral.readValueForCharacteristic(characteristic)
                    peripheral.setNotifyValue(true, forCharacteristic: characteristic as CBCharacteristic)
                } else if characteristic.UUID.isEqual(MS_REMOTE_BATTERY_UUID) {
                    self.remoteBatteryCharacteristic = characteristic
                    peripheral.readValueForCharacteristic(characteristic)
                    peripheral.setNotifyValue(true, forCharacteristic: characteristic as CBCharacteristic)
                } else if characteristic.UUID.isEqual(MS_MOTION_CONTROL_WRITE_UUID) {
                    self.motionControlCharacteristic = characteristic
                }
            }
            return
        } else if service.UUID.isEqual(MS_BATTERY_SERVICE_UUID) {
            for characteristic in service.characteristics as [CBCharacteristic]! {
                // And check if it's the right one
                if characteristic.UUID.isEqual(MS_BATTERY_CHARACTERISTIC_UUID) {
                    self.batteryCharacteristic = characteristic
                    peripheral.readValueForCharacteristic(characteristic)
                    peripheral.setNotifyValue(true, forCharacteristic: characteristic)
                }
            }
        } else if service.UUID.isEqual(MS_DEVICE_INFO_SERVICE_UUID) {
            for characteristic in service.characteristics as [CBCharacteristic]! {
                // And check if it's the right one
                if characteristic.UUID.isEqual(MS_SERIAL_CHARACTERISTIC_UUID) {
                    self.serialNumberCharacteristic = characteristic
                    peripheral.readValueForCharacteristic(characteristic)
                } else if characteristic.UUID.isEqual(MS_FIRMWARE_CHARACTERISTIC_UUID) {
                    self.firmwareCharacteristic = characteristic
                    peripheral.readValueForCharacteristic(characteristic)
                }
            }
        } else {
            print("Not Match!")
        }
        // Once this is complete, we just need to wait for the data to come in.
    }
    
    /** This callback lets us know more data has arrived via notification on the characteristic
     */
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if let error = error {
            print("Error updating characteristic: \(error.localizedDescription)")
            return
        }
        var data = ""
        data = String(characteristic.value)
        // Have we got everything we need?
        if characteristic.UUID == MS_EEPROM_UUID {
            data = String( characteristic.value )
            print("Notify EEPROM \(data)")
            deserializeEEPROMCharacteristic(characteristic)
        } else if characteristic.UUID == MS_BATTERY_CHARACTERISTIC_UUID {
            print("Notify Battery \(data)")
            deserializeBoardBatteryCharacteristic(characteristic)
        } else if characteristic.UUID == MS_REMOTE_BATTERY_UUID {
            print("Notify Remote Battery \(data)")
            deserializeRemoteBatteryCharacteristic(characteristic)
        } else if characteristic.UUID == MS_SERIAL_CHARACTERISTIC_UUID {
            print("Notify SN \(data)")
            deserializeSerialNumberCharacteristic(characteristic)
        } else if characteristic.UUID == MS_FIRMWARE_CHARACTERISTIC_UUID {
            print("Notify Firmware Ver \(data)")
            deserializeFirmwareVersionCharacteristic(characteristic)
        } else if characteristic.UUID == MS_ODOMETER_UUID {
            data = String( characteristic.value )
            print("Notify Odometer \(data)")
            deserializeOdometerCharacteristic(characteristic)
        } else if characteristic.UUID == MS_TRIP_UUID {
            print("Notify Trip \(data)")
            deserializeTripCharacteristic(characteristic)
        } else if characteristic.UUID == MS_BOARD_LOCK_READ_UUID {
            print("Notify Lock \(data)")
            deserializeBoardLockCharacteristic(characteristic)
        } else {
            print("UPDATE: OTHER")
        }
    }
    
    
    func peripheral(peripheral: CBPeripheral, didWriteValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        /* When a write occurs, need to set off a re-read of the local CBCharacteristic to update its value */
        peripheral.readValueForCharacteristic(characteristic)
    }
    
    
    
    /** The peripheral letting us know whether our subscribe/unsubscribe happened or not
     */
    func peripheral(peripheral: CBPeripheral, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if let error = error {
            print("Error changing notification state: \(error.localizedDescription)")
            return
        }
        
        // Exit if it's not the transfer characteristic
        if characteristic.UUID.isEqual(MS_EEPROM_UUID) {
            print("UPDATE STATE: EEPROM")
        } else if characteristic.UUID.isEqual(MS_BATTERY_CHARACTERISTIC_UUID) {
            print("UPDATE STATE: BATTERY")
        } else if characteristic.UUID.isEqual(MS_REMOTE_BATTERY_UUID) {
            print("UPDATE STATE: REMOTE BATTERY")
        } else if characteristic.UUID.isEqual(MS_ODOMETER_UUID) {
            print("UPDATE STATE: ODOMETER")
        } else {
            print("UPDATE STATE: OTHER")
        }
        
        // Notification has started
        if (characteristic.isNotifying) {
            print("Notification began on \(characteristic)")
        } else { // Notification has stopped
            print("Notification stopped on (\(characteristic))  Disconnecting")
            //            centralManager?.cancelPeripheralConnection(peripheral)
        }
    }
    
    // MARK: - Write Marbel Methods
    
    func writeSpeed(speed: UInt16) {
        // See if characteristic has been discovered before writing to it
        if (self.marbelPeripheral != nil && self.speedCharacteristic != nil) {
            // Need a mutable var to pass to writeValue function
            var speedValue = speed
            let data = NSData(bytes: &speedValue, length: sizeof(UInt16))
            self.marbelPeripheral?.writeValue(data, forCharacteristic: self.speedCharacteristic! , type: CBCharacteristicWriteType.WithoutResponse)
        }
    }
    
    
    func writeAccel(accel: UInt16) {
        // See if characteristic has been discovered before writing to it
        if (self.marbelPeripheral != nil && self.accelCharacteristic != nil) {
            // Need a mutable var to pass to writeValue function
            var accelValue = accel
            let data = NSData(bytes: &accelValue, length: sizeof(UInt16))
            self.marbelPeripheral?.writeValue(data, forCharacteristic: self.accelCharacteristic! , type: CBCharacteristicWriteType.WithoutResponse)
        }
    }
    
    
    func writeWheelSize(wheelSize: UInt16) {
        // See if characteristic has been discovered before writing to it
        if (self.marbelPeripheral != nil && self.wheelSizeWriteCharacteristic != nil) {
            // Need a mutable var to pass to writeValue function
            var sizeValue = wheelSize
            let data = NSData(bytes: &sizeValue, length: sizeof(UInt16))
            self.marbelPeripheral?.writeValue(data, forCharacteristic: self.wheelSizeWriteCharacteristic! , type: CBCharacteristicWriteType.WithoutResponse)
        }
    }
    
    
    func writeThrottle(throttle: UInt8) {
        // See if characteristic has been discovered before writing to it
        if (self.marbelPeripheral != nil && self.motionControlCharacteristic != nil) {
            // Need a mutable var to pass to writeValue function
            var throttleValue = throttle
            let data = NSData(bytes: &throttleValue, length: sizeof(UInt8))
            self.marbelPeripheral?.writeValue(data, forCharacteristic: self.motionControlCharacteristic! , type: CBCharacteristicWriteType.WithoutResponse)
        }
    }
    
    
    // MARK: - Read Marbel Methods
    //read every second
    
    func readEEPROM() {
        if (self.marbelPeripheral != nil && self.eepromCharacteristic != nil) {
            self.marbelPeripheral?.readValueForCharacteristic(self.eepromCharacteristic!)
        }
    }
    
    func readBoardBattery() {
        if (self.marbelPeripheral != nil && self.batteryCharacteristic != nil) {
            self.marbelPeripheral?.readValueForCharacteristic(self.batteryCharacteristic!)
        }
    }
    
    func readOdometer() {
        if (self.marbelPeripheral != nil && self.odometerCharacteristic != nil) {
            self.marbelPeripheral?.readValueForCharacteristic(self.odometerCharacteristic!)
        }
    }
    
    
    func readRemoteBattery() {
        if (self.marbelPeripheral != nil && self.remoteBatteryCharacteristic != nil) {
            self.marbelPeripheral?.readValueForCharacteristic(self.remoteBatteryCharacteristic!)
        }
    }
    
    // MARK: - Deserialization Methods
    
    func deserializeEEPROMCharacteristic(characteristic: CBCharacteristic) {
      
        //  let array2 = Array(UnsafeBufferPointer(start: UnsafePointer<UInt8>(data.bytes), count: data.length))
    
        let data = characteristic.value!
        let count = data.length / sizeof(UInt8)
        var array = [UInt8](count: count, repeatedValue: 0)
        data.getBytes(&array, length: count * sizeof(UInt8))
        
        print("Skateboard Data : \(array)")
        
        var accel       = 0
        var speed       = 0
        var wheelSize   = 0
        var boardLock   = 0
        
        if array.count > 0 {
            accel  = Int(array[0])
        }
        if array.count > 1 {
            speed  = Int(array[1])
        }
        if array.count > 2 {
            wheelSize  = Int(array[2])
        }
        if array.count > 3 {
            boardLock  = Int(array[3])
        }
        
        if accel != 0 && speed != 0 {
            var mode : String! = ""
            if accel == Int(Constants.MS_STARTER_ACCELERATION_VALUE) && speed == Int(Constants.MS_STARTER_SPEED_VALUE) {
                //mode is starter
                mode = "STARTER"
            } else if accel == Int(Constants.MS_ECO_ACCELERATION_VALUE) && speed == Int(Constants.MS_ECO_SPEED_VALUE) {
                //mode is ECO
                mode = "ECO"
            } else if accel == Int(Constants.MS_SPORT_ACCELERATION_VALUE) && speed == Int(Constants.MS_SPORT_SPEED_VALUE) {
                //mode is sport
                mode = "SPORT"
            } else {
                //mode is custom
                mode = "CUSTOM"
            }
            print(mode)
            
            if currentRideId == -1 {
                currentRideId = 0
                
                let service: RestApiManager = RestApiManager.init()
               // let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
               
                service.createOrUpdateRide(MS_UUID.UUIDString, callBack: { (rideId, status) in
                    if status {
                        currentRideId = rideId
                    } else {
                        let rides = CoreDataManager.getInstance().getAllRides()
                        let maxRideID = (rides as AnyObject).valueForKeyPath("@max.rideID") as! Int
                        currentRideId = maxRideID
                    }
                    
                    CoreDataManager.getInstance().saveRideInfo([
                        Constants.KEY_USERID: myUserID,
                        Constants.KEY_BOARD_ID: MS_UUID.UUIDString,
                        Constants.KEY_RIDE_ID:currentRideId,
                        Constants.KEY_TIMESTAMP: getCurrentTimeString(),
                        Constants.KEY_EST_START: "Start From",
                        ])
                })
            }
            
            if currentRideId > 0 {
                let currentRide = CoreDataManager.getInstance().getRideForId(currentRideId)
                
                CoreDataManager.getInstance().addRidePoint([
                    Constants.KEY_BOARD_ID  : currentRide!.boardID!,
                    Constants.KEY_RIDE_ID   : currentRideId,
                    Constants.KEY_USERID    : myUserID,
                    Constants.KEY_ACCEL     : accel,
                    Constants.KEY_SPEED     : speed,
                    Constants.KEY_MODE      : mode,
                    Constants.KEY_TIMESTAMP : getCurrentTimeString(),
                    ])
                
                lastRidePointEntryDateTime = NSDate()
            }
        }
        
        if wheelSize == 76 || wheelSize == 100 {
            CoreDataManager.getInstance().updateBoardStrInfo(myUserID!, key: Constants.KEY_WHEEL, value: "\(wheelSize)")
        }
        
        
        let lockStatus : Bool!
        if boardLock == 0 {
            lockStatus = false
        } else {
            lockStatus = true
        }
        CoreDataManager.getInstance().updateBoardBoolInfo(myUserID!, key: Constants.KEY_LOCKSTATUS, value: lockStatus)
        
    }
    
    func deserializeBoardBatteryCharacteristic(characteristic: CBCharacteristic) {
        var values: UInt16 = 0
        characteristic.value!.getBytes(&values, length:characteristic.value!.length)
        let desValue2: NSNumber = NSNumber(unsignedShort: values)
        
        //save to core data
        CoreDataManager.getInstance().updateBoardNumberInfo(myUserID!, key: Constants.KEY_BATTERYCHARGE, value: desValue2)
        print("Battery % as a Uint16: \(desValue2)")
        
    }
    
    func deserializeRemoteBatteryCharacteristic(characteristic: CBCharacteristic) {
        var values: UInt16 = 0
        characteristic.value!.getBytes(&values, length:characteristic.value!.length)
        let desValue2: NSNumber = NSNumber(unsignedShort: values)
        
        //save to core data
        CoreDataManager.getInstance().updateRidePointNumberInfo(myUserID!, key: Constants.KEY_REMOTE_BATTERY_LIFE, value: desValue2)
        print("Remote % as a Uint16: \(desValue2)")
    }
    
    func deserializeOdometerCharacteristic(characteristic: CBCharacteristic) {
        //odometer
        print("odoMeter HEX: \(characteristic.value)")
        var temp = NSString(data: characteristic.value!, encoding: NSUTF8StringEncoding)
        temp = temp?.stringByReplacingOccurrencesOfString("<", withString: "")
        temp = temp?.stringByReplacingOccurrencesOfString(">", withString: "")
        if let other: String = temp as? String {
            if let newValue: Int = Int(other) {
                let left: Int = newValue / 10
                let right = newValue % 10
                var odoValue: String! = ""
                if left <= 999 {
                    odoValue = "\(left).\(right)"
                } else {
                    odoValue = "\(left)"
                }
                
                if !isFirstOdoMeter {
                    firstOdoMeter = odoValue.floatValue
                    isFirstOdoMeter = true
                }
                
                CoreDataManager.getInstance().updateBoardStrInfo(myUserID!, key: Constants.KEY_ODOMETER, value: odoValue)
            }
        }
    }
    
    func deserializeTripCharacteristic(characteristic: CBCharacteristic) {
        var values: UInt16 = 0
        characteristic.value!.getBytes(&values, length:characteristic.value!.length)
        let desValue2: NSNumber = NSNumber(unsignedShort: values)
        
        //save to core data: Unused in this version
        
        print("Trip as a Uint16: \(desValue2)")
    }
    
    func deserializeSerialNumberCharacteristic(characteristic: CBCharacteristic) {
        //mainSerialNumber
        let serialNumber = NSString(data: characteristic.value!, encoding: NSUTF8StringEncoding)
        let newValue = serialNumber as! String
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject("\(newValue)", forKey: Constants.MS_SERIAL_NUMBER)
        defaults.synchronize()
        
        CoreDataManager.getInstance().updateBoardStrInfo(myUserID!, key: Constants.KEY_MAIN_SN, value: newValue)
        
    }
    
    func deserializeFirmwareVersionCharacteristic(characteristic: CBCharacteristic) {
        // firmwareVersion
        let firmwareVersion = NSString(data: characteristic.value!, encoding: NSUTF8StringEncoding)
        let newValue = firmwareVersion as! String
        CoreDataManager.getInstance().updateBoardStrInfo(myUserID!, key: Constants.KEY_FIRMWARE, value: newValue)
    }
    
    func deserializeBoardLockCharacteristic(characteristic: CBCharacteristic) {
        let boardLockCode = NSString(data: characteristic.value!, encoding: NSUTF8StringEncoding)
        
        //save to core data: Unused in this version
        
        print("BoardLockCode: \(boardLockCode!)")
    }
    
    func swapUInt16Data(data : NSData) -> NSData {
        
        // Copy data into UInt16 array:
        let count = data.length / sizeof(UInt16)
        var array = [UInt16](count: count, repeatedValue: 0)
        data.getBytes(&array, length: count * sizeof(UInt16))
        
        // Swap each integer:
        for i in 0 ..< count {
            // array[i] = array[i].byteSwapped // *** (see below)
            array[i] = UInt16(bigEndian: array[i])
        }
        
        // Create NSData from array:
        return NSData(bytes: &array, length: count * sizeof(UInt16))
    }
}


