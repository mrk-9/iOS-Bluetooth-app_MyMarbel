//
//  OnboardingFivVC.swift
//  MyMarbel
//
//  Created by Tmaas on 18/05/16.
//  Copyright © 2016 MBSolution. All rights reserved.
//

import UIKit
import CoreLocation

class OnboardingFivVC: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var nextBtn: UIButton! {
        didSet{
            makeRoundView(nextBtn, radius: 3.0, color: UIColor.clearColor(), width: 1.0)
        }
    }
    
    var locationManager = CLLocationManager()
    var count: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    // MARK: - Button Actions
    
    @IBAction func backBtnClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func skipBtnClicked(sender: AnyObject) {
        goScanBoardViewController()
    }
    
    @IBAction func enableMapBtnClicked(sender: AnyObject) {
        
        if (CLLocationManager.locationServicesEnabled())
        {
            
            locationManager = CLLocationManager()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.delegate = self
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
//        let status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
    }
    
    func goScanBoardViewController() {
        self.performSegueWithIdentifier(Constants.SEGUE_ONBOARD_SCAN, sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        count += 1;
        print("Count = \(count)")
        if count == 2 && status != .AuthorizedAlways{
            
            let alertControl = UIAlertController(title: "Alert", message: "The app will be very limited if you don't allow the app to use location data.", preferredStyle: .Alert)
            let item1 = UIAlertAction(title: "OK", style: .Default, handler: {(action) -> Void in
                self.goScanBoardViewController()
            })
            
            alertControl.addAction(item1)
            presentViewController(alertControl, animated: true, completion: nil)
        }
        
        if status == .NotDetermined {
            print("Not Determined")
        } else if status == .AuthorizedAlways {
            //update locationEnable of DB
            CoreDataManager.getInstance().updateUserBoolInfo(myEmail, key: Constants.KEY_LOCATION, value: true)
            //go scanBoardVC
            goScanBoardViewController()
        }
    }
 
}
