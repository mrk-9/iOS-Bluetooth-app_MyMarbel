//
//  OnboardingViewController.swift
//  MyMarbel
//
//  Created by Tmaas on 18/05/16.
//  Copyright © 2016 MBSolution. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet var nextBtn: UIButton! {
        didSet{
            makeRoundView(nextBtn, radius: 3.0, color: UIColor.clearColor(), width: 1.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Button Actions
    
    //    @IBAction func skipBtnClicked(sender: AnyObject) {
    //        goNextVC()
    //    }
    
    @IBAction func backBtnClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func startBtnClicked(sender: AnyObject) {
        goNextVC()
    }
    
    func goNextVC() {
        
        SwiftNotice.wait()
        
        //init board data of localDB
        formatLocalBoardData()
        
        
        //init RideID data of localDB
        formatLocalRidePointData()
                
        print("got here 2")
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1), dispatch_get_main_queue()) {
            SwiftNotice.clear()
            
            //go next viewController
            self.performSegueWithIdentifier(Constants.SEGUE_ONBOARD_1TO2, sender: self)
        }
        
    }
    
    func formatLocalBoardData() {
        
        //init board data
        let info : NSDictionary = [Constants.KEY_USERID         : myUserID,
                                   Constants.KEY_BOARD_ID       : 0,
                                   Constants.KEY_BOARDNAME      : "unknown",
                                   Constants.KEY_FIRMWARE       : "V1.0",
                                   Constants.KEY_MAIN_SN        : "",
                                   Constants.KEY_BATTERY_SN     : "unknown",
                                   Constants.KEY_MOTOR_VN       : "unknown",
                                   Constants.KEY_CIRCUIT_VN     : "unknown",
                                   Constants.KEY_DECK_VN        : "unknown",
                                   Constants.KEY_PRODUCTION     : "unknown",
                                   Constants.KEY_WHEEL          : "",
                                   Constants.KEY_ODOMETER       : "0",
                                   Constants.KEY_RIDECOUNT      : 0,
                                   Constants.KEY_BATTERYCHARGE  : 0,
                                   Constants.KEY_LOCKSTATUS     : false,
                                   Constants.KEY_DURATION       : 0,
                                   Constants.KEY_PARENTLOCK     : false,
                                   Constants.KEY_TIMESTAMP      : getCurrentTimeString()
        ]
        
        //save
        CoreDataManager.getInstance().saveBoardInfo(info)
    }
    
    func formatLocalRidePointData() {
        
        //init RidePoint data
        let info : NSDictionary = [Constants.KEY_USERID                 : myUserID,
                                   Constants.KEY_MODE                   : "CUSTOM",
                                   Constants.KEY_ACCEL                  : 7,
                                   Constants.KEY_SPEED                  : 19,
                                   Constants.KEY_MOTOR_DIRECTION        : "unknown",
                                   Constants.KEY_MOTOR_DIRECTION2       : "unknown",
                                   Constants.KEY_ELEVATION              : 0,
                                   Constants.KEY_RIDE_ID                : "unknown",
                                   Constants.KEY_STATE                  : "unknown",
                                   Constants.KEY_RPM                    : 0,
                                   Constants.KEY_RPM2                   : 0,
                                   Constants.KEY_ODOMETER               : 0,
                                   Constants.KEY_REMOTE_BLE_CONNECTION  : 0,
                                   Constants.KEY_INTERNAL_TEMPERATURE   : 0,
                                   Constants.KEY_MOTOR_TEMP             : 0,
                                   Constants.KEY_REMOTE                 : 0,
                                   Constants.KEY_ESC                    : 0,
                                   Constants.KEY_ESC2                   : 0,
                                   Constants.KEY_VOLTAGE1               : 0,
                                   Constants.KEY_VOLTAGE2               : 0,
                                   Constants.KEY_VOLTAGE3               : 0,
                                   Constants.KEY_VOLTAGE4               : 0,
                                   Constants.KEY_VOLTAGE5               : 0,
                                   Constants.KEY_VOLTAGE6               : 0,
                                   Constants.KEY_VOLTAGE7               : 0,
                                   Constants.KEY_VOLTAGE8               : 0,
                                   Constants.KEY_VOLTAGE9               : 0,
                                   Constants.KEY_VOLTAGE10              : 0,
                                   Constants.KEY_VOLTAGE                : 0,
                                   Constants.KEY_CURRENT_AMPS           : 80,
                                   Constants.KEY_WH                     : 181.3,
                                   Constants.KEY_ERROR_FLAG             : 0,
                                   Constants.KEY_REMOTE_BATTERY_LIFE    : 100,
                                   Constants.KEY_LATITUDE               : "unknown",
                                   Constants.KEY_LONGITUDE              : "unknown",
                                   Constants.KEY_THROTTLE               : 0,
                                   Constants.KEY_BLE_STRENGTH           : 0,
                                   Constants.KEY_TIMESTAMP              : getCurrentTimeString(),
                                   Constants.KEY_MOTOR_AMPS1            :0,
                                   Constants.KEY_MOTOR_AMPS2            :0,
                                   Constants.KEY_MOTOR_VOLT1            :0,
                                   Constants.KEY_MOTOR_VOLT2            :0
        ]
        
        print("got here")
        
        //save
        CoreDataManager.getInstance().saveRidePointInfo(info)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
