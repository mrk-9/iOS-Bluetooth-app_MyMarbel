//
//  DashboardVC.swift
//  MyMarbel
//
//  Created by Tmaas on 11/05/16.
//  Copyright © 2016 MBSolution. All rights reserved.
//

import UIKit

var firstOdoMeter: Float! = 0.0
var isFirstOdoMeter: Bool!
var isStartNewRide: Bool!

class DashboardVC: UIViewController {

    @IBOutlet var mapView: UIView!
    @IBOutlet var topView: UIView!
    @IBOutlet var batteryImgView: UIImageView!
    
    @IBOutlet var typeLbl: UILabel! {
        didSet{
            makeRoundView(typeLbl, width: 1.0, color: Constants.mbBlue)
        }
    }
    
    @IBOutlet var centerChargeLbl: UILabel!
    @IBOutlet var trpLbl: UILabel!
    @IBOutlet var remoteLbl: UILabel!
    
    @IBOutlet var chartView: UIView!
    @IBOutlet var efficencyLbl: UILabel!
    @IBOutlet var totalDistanceLbl: UILabel!
    @IBOutlet var rideCountLbl: UILabel!
    @IBOutlet var batteryHeight: NSLayoutConstraint!
    
    var connectTimer       = NSTimer()
    var disconnectTimer       = NSTimer()
    var appendTimer = NSTimer()
    var printTimer = NSTimer()
    var everySecTimer       = NSTimer()
    let progressViewTag: Int = 99999
    var disconnectCounter = 0
    
    var disconnectView: MDisconnectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(searchingBoard),
            name: Constants.MSSearchingNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(connectedNow),
            name: Constants.MSDidConnectNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(disconnectedNow),
            name: Constants.MSDidDisconnectNotification,
            object: nil)
        
        everySecTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(self.updateAll), userInfo: nil, repeats: true)


        //let del = UIApplication.sharedApplication().delegate as! AppDelegate
        //del.updateRidePoints()
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        updateDashboard()
        print("viewDidAppear")
       }
    
    func searchingBoard(notification: NSNotification){
        //do stuff
        print("searching...")
        
    }
    
    func connectedNow(notification: NSNotification){
        //do stuff
        print("now connected")
//        connectTimer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(self.updateDashboard), userInfo: nil, repeats: false)
    }
    
    func updateAll() {
//       RideManager.sharedInstance.createRidePoint() // marked for test
        
        if connected {
            if disconnectView != nil {
                disconnectView.removeFromSuperview()
                disconnectView = nil
            }
            disconnectCounter = 0
            updateDashboard()
        } else {
            if disconnectView == nil {
                disconnectView = MDisconnectView(frame:self.view.frame)
                self.view.addSubview(disconnectView)
            }
            
            disconnectCounter += 1
            if disconnectCounter == 120 {
                isFirstOdoMeter = false
                isStartNewRide = false
            }
        }
    }
    
    func updateDashboard(){
        let ary1 = CoreDataManager.getInstance().getRidePointInfo()
        let myRidePoint: RidePoint! = ary1[0]
        typeLbl.text = myRidePoint.mode!
        remoteLbl.text = "\(myRidePoint.remoteBatteryLife!)"
        
        let ary2 = CoreDataManager.getInstance().getBoardInfo()
        let myBoard: Board! = ary2[0]
        centerChargeLbl.text = "\(myBoard.batteryChargeCount!)"
        addCurcleProgress(Double(myBoard.batteryChargeCount!))
       
        
        //range alarm refresh.. only needed each time the screen loads.
        batteryHeight.constant = CGFloat(myBoard.batteryChargeCount!) / 100 * 25
       
        
        
        trpLbl.text = calculateTrip(myBoard.odometer!)
        
        calculateRideCount(myBoard.odometer!, count: myBoard.rideCount!)
        //        totalDistanceLbl.text = myBoard.odometer!
        //        rideCountLbl.text = "\(myBoard.rideCount!)"
        //        efficencyLbl.text =
        
        
        let arr = CoreDataManager.getInstance().getAllRides()
        
        var totalDistance : Float = 0.0
        for ride in arr{
            totalDistance = totalDistance + Float(ride.tripDistance!)
        }
        totalDistanceLbl.text = "\(totalDistance)"
        rideCountLbl.text = "\(arr.count)"
    }
    
    func disconnectedNow(notification: NSNotification){
        //do stuff
        print("now disconnected")
        //  timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: #selector(self.updateDashboard), userInfo: nil, repeats: false)
    }
    
    
    func addCurcleProgress(percent: Double) {
        if let theProgress = self.view.viewWithTag(progressViewTag) {
            theProgress.removeFromSuperview()
        }
        
        let dist = topView.frame.size.width - 8
        let angle: Double = percent / 100 * 360
        var progress: TMCircularProgress!
        progress = TMCircularProgress(frame: CGRect(x: 0, y: 0, width: dist, height: dist))
        progress.startAngle = -90
        progress.progressThickness = 0.08
        progress.trackThickness = 0.0
        progress.clockwise = true
        progress.gradientRotateSpeed = 2
        progress.roundedCorners = false
        progress.glowMode = .Forward
        progress.glowAmount = 0.0
        progress.setColors(Constants.mbDarkBlue, Constants.mbNeonYellow)
        progress.center = topView.center
        topView.addSubview(progress)
        progress.tag = progressViewTag
        progress.angle = angle
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func calculateRideCount(value: String, count: NSNumber) {
        let result = value.floatValue - firstOdoMeter
        if !isStartNewRide {
            if result > 0.1 {
                let newCount = Int(count) + 1
                CoreDataManager.getInstance().updateBoardNumberInfo(myUserID!, key: Constants.KEY_RIDECOUNT, value: newCount)
                isStartNewRide = true
            }
        }
    }
    
    func calculateTrip(value: String) -> String {
        let result = value.floatValue - firstOdoMeter
        
        return "\(result)"
    }
    
    func calculateEfficiencyScore() {
        
    }
}
