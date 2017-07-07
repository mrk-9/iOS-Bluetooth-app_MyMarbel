//
//  ModeVC.swift
//  MyMarbel
//
//  Created by Tmaas on 11/05/16.
//  Copyright © 2016 MBSolution. All rights reserved.
//

import UIKit

class ModeVC: UIViewController {

    @IBOutlet var savebarItem: UIBarButtonItem!
    
    @IBOutlet var starterBtn: UIButton!
    @IBOutlet var ecoBtn: UIButton!
    @IBOutlet var sportBtn: UIButton!
    @IBOutlet var customBtn: UIButton!
    
    @IBOutlet var drawView: UIView!
    
    @IBOutlet var customView: UIView!
    
    @IBOutlet var accelerationLbl: UILabel!
    @IBOutlet var topspeedLbl: UILabel!
    
    @IBOutlet var accelSlider: UISlider!
    @IBOutlet var speedSlider: UISlider!
    
    var customAccel: CGFloat! = 0
    var customSpeed: CGFloat! = 0
    
    var mode = 1
    var timer       = NSTimer()
    var myRidePoint: RidePoint!
    var disconnectView: MDisconnectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        changeBarItemStatus(1)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if connected {
            if disconnectView != nil {
                disconnectView.removeFromSuperview()
                disconnectView = nil
            }
        } else {
            if disconnectView == nil {
                disconnectView = MDisconnectView(frame:(self.view.superview?.frame)!)
                self.navigationController?.view.addSubview(disconnectView)
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if disconnectView != nil {
            disconnectView.removeFromSuperview()
            disconnectView = nil
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //read Coredata to see what Mode the board is set in. This would be depend on two values. TopSpeed and Accel number from CodeData.
        let ary = CoreDataManager.getInstance().getRidePointInfo()
        myRidePoint = ary[0]
        
        let myMode = myRidePoint.mode!
        if myMode == "STARTER"{
            mode = 1
        } else if myMode == "ECO" {
            mode = 2
        } else if myMode == "SPORT" {
            mode = 3
        } else {
            mode = 4
            customAccel = myRidePoint.accel! as CGFloat
            customSpeed = myRidePoint.speed! as CGFloat
            print("accel and speed = \(customAccel) \(customSpeed)")
        }
        
        //show the "Save" button as "Saved" and greyed out
        
        //show the correct "Mode" buttons selected
        
        //show the correct values for the mode.
        
        //user can click around and SEE the other Modes and options... but has to click "Save" to actually send the values and save them.
        
        //if the board is in ECO mode and the user selects the Sport button...
        //we show the "Save" button become available.
        //then we show the correct buttons for Sport
        //then we show the correct values for Sport
        
        //if the user clicks "Save" we send the values for Accel and Speed to the board
        //after 1 second we readEEPROM value and if they MATCh our sent Accel and Speed everythign was saved correctly.
        //the new Accel and Speed values are also updated in CoreData immediately.
        
        makeTypeButtonsToRound(mode)
    }

    func makeTypeButtonsToRound(num: Int) {
        makeRoundView(starterBtn, width: 2.0, color: UIColor.whiteColor())
        makeRoundView(ecoBtn, width: 2.0, color: UIColor.whiteColor())
        makeRoundView(sportBtn, width: 2.0, color: UIColor.whiteColor())
        makeRoundView(customBtn, width: 2.0, color: UIColor.whiteColor())
        
        if num == 1 {
            makeRoundView(starterBtn, width: 2.0, color: Constants.mbBlue)
            customView.hidden = true
        }else if num == 2 {
            makeRoundView(ecoBtn, width: 2.0, color: Constants.mbBlue)
            customView.hidden = true
        }else if num == 3 {
            makeRoundView(sportBtn, width: 2.0, color: Constants.mbBlue)
            customView.hidden = true
        }else {
            makeRoundView(customBtn, width: 2.0, color: Constants.mbBlue)
            customView.hidden = false
        }
        displayValues(num)
//        displayCurve(num)
    }
    
    @IBAction func typeBtnClicked(sender: UIButton) {
       // sleep(1)
        makeTypeButtonsToRound(sender.tag)
        
        changeBarItemStatus(0)
    }
    
    func changeBarItemStatus(index: Int) {
        if index == 0 { //save
            savebarItem.tintColor = UIColor.whiteColor()
            savebarItem.title = "Save"
            savebarItem.enabled = true
        } else { //saved
            savebarItem.title = "Saved"
            savebarItem.tintColor = UIColor.lightGrayColor()
            savebarItem.enabled = false
        }
    }
    
    func displayValues(num: Int) {
        if num == 1 {
            accelerationLbl.text = "10%"
            topspeedLbl.text = "9"
        }else if num == 2 {
            accelerationLbl.text = "ECO"
            topspeedLbl.text = "17"
        }else if num == 3 {
            accelerationLbl.text = "100%"
            topspeedLbl.text = "25"
        }else {
            accelerationLbl.text = "\(myRidePoint.accel!)"
            topspeedLbl.text = "\(myRidePoint.speed!)"
            
            accelSlider.setValue((Float(myRidePoint.accel!) - 1) / 9, animated: true)
            speedSlider.setValue((Float(myRidePoint.speed!) - 10) / 15, animated: true)
        }
        
        mode = num
        
        displayCurve(num)
    }
    
    func displayCurve(num: Int) {
        for subview: UIView in drawView.subviews {
            subview.removeFromSuperview()
        }
        
        var accel: CGFloat!
        var speed: CGFloat!
        if num == 1 {
            accel = Constants.MS_STARTER_ACCELERATION_VALUE
            speed = Constants.MS_STARTER_SPEED_VALUE
        }else if num == 2 {
            accel = Constants.MS_ECO_ACCELERATION_VALUE
            speed = Constants.MS_ECO_SPEED_VALUE
        }else if num == 3 {
            accel = Constants.MS_SPORT_ACCELERATION_VALUE
            speed = Constants.MS_SPORT_SPEED_VALUE
        }else {
            accel = customAccel
            speed = customSpeed
        }
        let curveView = MCurveView(frame: drawView.frame, accel: accel, topSpeed: speed)
        drawView.addSubview(curveView)
    }
    
    @IBAction func accelerationChanged(sender: UISlider) {
        let newAccel = CGFloat(sender.value)
        customAccel = Constants.MS_CUSTOM_ACCELERATION_RANGE * newAccel + Constants.MS_CUSTOM_MIN_ACCELERATION
        displayCurve(4)
        
    }
    
    @IBAction func topSpeedChanged(sender: UISlider) {
        let newSpeed = CGFloat(sender.value)
        customSpeed = Constants.MS_CUSTOM_SPEED_RANGE * newSpeed + Constants.MS_CUSTOM_MIN_SPEED
        displayCurve(4)
    }
    
    @IBAction func saveBarItemClicked(sender: UIBarButtonItem) {
        
        SwiftNotice.wait()
        performSelector(#selector(self.afterSaveAction), withObject: self, afterDelay: 1.0)
        
        let newAccel: Int!
        let newSpeed: Int!
        let newMode: String!
        if mode == 1 {
            sendAccel(1)
            sendSpeed(9)
            timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: #selector(self.checkEEPROM), userInfo: nil, repeats: false)
            
            newAccel = 1
            newSpeed = 9
            newMode = "STARTER"
        } else if mode == 2 {
            sendAccel(11)
            sendSpeed(17)
            timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: #selector(self.checkEEPROM), userInfo: nil, repeats: false)
            
            newAccel = 11
            newSpeed = 17
            newMode = "ECO"
        } else if mode ==  3 {
            sendAccel(10)
            sendSpeed(25)
            timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: #selector(self.checkEEPROM), userInfo: nil, repeats: false)
            
            newAccel = 10
            newSpeed = 25
            newMode = "SPORT"
        } else {
            sendAccel(UInt16(customAccel))
            sendSpeed(UInt16(customSpeed))
            checkEEPROM()
            
            newAccel = Int(customAccel)
            newSpeed = Int(customSpeed)
            newMode = "CUSTOM"
        }
        
        CoreDataManager.getInstance().updateRidePointNumberInfo(myUserID, key: Constants.KEY_ACCEL, value: newAccel)
        CoreDataManager.getInstance().updateRidePointNumberInfo(myUserID, key: Constants.KEY_SPEED, value: newSpeed)
        CoreDataManager.getInstance().updateRidePointStrInfo(myUserID, key: Constants.KEY_MODE, value: newMode)
        
        changeBarItemStatus(1)
    }
    
    func afterSaveAction() {
        SwiftNotice.clear()
        showAlertWithTitle("", msg: "Saved successfully!")
    }
    
    func sendAccel(acceleration: UInt16){
        MBluetoothManager.sharedInstance.writeAccel( acceleration )
        print("write accel \(acceleration)")
        
    }
    
    func sendSpeed(speed: UInt16){
        MBluetoothManager.sharedInstance.writeSpeed( speed )
        print("write speed \(speed)")
        
    }
    
    
    func checkEEPROM(){
        
        MBluetoothManager.sharedInstance.readEEPROM()
        //  print( String( MBluetoothManager.sharedInstance.eepromCharacteristic?.value ))
        
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
