//
//  LoginViewController.swift
//  MyMarbel
//
//  Created by Tmaas on 12/05/16.
//  Copyright © 2016 MBSolution. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var emailFld: UITextField!
    @IBOutlet var pwdFld: UITextField!
    @IBOutlet var signinBtn: UIButton! {
        didSet{
            makeRoundView(signinBtn, radius: 3.0, color: UIColor.clearColor(), width: 1.0)
        }
    }
    
    @IBOutlet var bottomViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var titleHeightConstraint: NSLayoutConstraint!
    
    var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let isOnboard = defaults.boolForKey("isOnboard")
        let isLogout  = defaults.boolForKey("logout")
        
        if isOnboard && !isLogout{
            print("tab vc and startscan")
            MBluetoothManager.sharedInstance.startScan()
            goTabBarVC()
        }
        
        emailFld.text = "tmaas510@yahoo.com"
        pwdFld.text = "qwerqwer"
        // Get UserData from LocalDB by CoreData
        // If user email is already existed, set saved email to emailTextField
        let ary = CoreDataManager.getInstance().getUserInfo()
        if ary.count > 0 {
            let myProfile: User = ary[0]
            if myProfile.userEmail! != "" {
                emailFld.text = myProfile.userEmail!
            }
        }
        
        // Play background vide
        addVideoBackground()
    }
    
    // MARK: - Play video background
    
    func addVideoBackground() {
        let videoURL: NSURL = NSBundle.mainBundle().URLForResource("BackgroundVideo", withExtension: "mp4")!
        
        player = AVPlayer(URL: videoURL)
        player?.actionAtItemEnd = .None
        player?.muted = true
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerLayer.zPosition = -1
        
        playerLayer.frame = view.frame
        
        view.layer.addSublayer(playerLayer)
        
        player?.play()
        
        //loop video
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(LoginViewController.loopVideo),
                                                         name: AVPlayerItemDidPlayToEndTimeNotification,
                                                         object: nil)
    }
    
    func loopVideo() {
        player?.seekToTime(kCMTimeZero)
        player?.play()
    }
    
    // MARK: - Button click actions
    
    @IBAction func signinBtnClicked(sender: AnyObject) {
        //TODO:
        // If the app has backend API;
        // first, check email is valid
        // get data from server by calling backend API
        // save user data to localDB by CoreData
        
        
        //If this is first time, then Go tabVC, else Go onboardingVC
        let defaults = NSUserDefaults.standardUserDefaults()
        let isOnboard = defaults.boolForKey("isOnboard")
        //        let isLoggedIn = defaults.boolForKey("isLoggedIn")
        
        if isOnboard {
            print("tab vc")
            let result = CoreDataManager.getInstance().checkUser(self.emailFld.text!, password: self.pwdFld.text!)
            if result == Constants.RESULT_SUCCESS {
                
                MBluetoothManager.sharedInstance.startScan()
                goTabBarVC()
                
            } else if result == Constants.RESULT_INVALID_AUTHENTICATION {
                showAlertWithTitle("Error", msg: "Wrong Password!")
            } else if result == Constants.RESULT_UNAUTHIRIZED {
                showAlertWithTitle("Error", msg: "Wrong Email!")
            } else {
                showAlertWithTitle("Error", msg: "Login Error : Please Try Again")
            }
            
        } else {
            print("onboard vc")
            goOnboardingVC()
        }
        
    }
    
    @IBAction func forgotBtnClicked(sender: AnyObject) {
        //TODO here later - forgot password
    }
    
    func goTabBarVC() {
        
        let myUser : User = CoreDataManager.getInstance().getUserInfo()[0]
        myUserID = Int(myUser.userID!)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(false, forKey: "logout")
        defaults.synchronize()
        
        //transfer to tabBarViewController
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewControllerWithIdentifier(Constants.STORYBOARD_TABBAR) as! UITabBarController
        UIApplication.sharedApplication().keyWindow?.rootViewController = viewController
        
        
    }
    
    func goOnboardingVC() {
        
        // If text of emailTextField is empty, show alert and return
        if emailFld.text! == "" {
            showAlertWithTitle("", msg: "Please enter your email")
            return
        }
        
        if validateEmail(self.emailFld.text!) == false {
            showAlertWithTitle("Error", msg: "Invalid Email.")
            return
        }
        
        //*
        let loginData : Dictionary = ["userEmail" : self.emailFld.text!, "userPassword" : self.pwdFld.text! ]
        
        let service: RestApiManager = RestApiManager.init()
        SwiftNotice.wait()
        service.apiCall(loginData, callType: APICallType.POST, callName: APICallName.SignIn) { (response, success) in
            if response != nil {
                SwiftNotice.clear()
                if success {
                    let resDtn : Dictionary<String, AnyObject> = response?.objectForKey("data") as! Dictionary<String, AnyObject>
                    self.saveUserDataFromAPI(resDtn)
                }
                else {
                    showAlertWithTitle("Error", msg: "Sign In Failed")
                }
            }
            
//            service.apiCall(loginData, callType: APICallType.POST, callName: APICallName.UpdateRideInfo){ _,_ in (response, success) }
//            service.apiCall(loginData, callType: APICallType.POST, callName: APICallName.UpdateRidePoint) { _,_ in (response, success) }
//            service.apiCall(loginData, callType: APICallType.POST, callName: APICallName.UpdateBoardInfo) { _,_ in (response, success) }
            
        } //*/
        
        //save userData to LocalDB
        //saveUserDataFromAPI()
        
    }
    
    func saveUserDataFromAPI(response: Dictionary<String , AnyObject>) {
        myEmail = self.emailFld.text!
        myUserID = Int(response["userId"]! as! String)
        
        //init User entity of CoreData
        let info : NSDictionary = [Constants.KEY_EMAIL          : self.emailFld.text!,
                                   Constants.KEY_PASSWORD       : self.pwdFld.text!,
                                   Constants.KEY_USERID         : myUserID!,
                                   Constants.KEY_FIRSTNAME      : response["userFirstName"]! as! String,
                                   Constants.KEY_LASTNAME       : response["userLastName"]! as! String,
                                   Constants.KEY_HEIGHT         : response["height"]! as! String,
                                   Constants.KEY_WEIGHT         : response["weight"]! as! String,
                                   Constants.KEY_TERRAIN        : response["terrain"]! as! String,
                                   Constants.KEY_AVATAR         : response["userProfilePicture"]! as! String,
                                   Constants.KEY_BIO            : response["userBio"]! as! String,
                                   Constants.KEY_COUNTRY        : response["country"]! as! String,
                                   Constants.KEY_STATE          : response["stateRegion"]! as! String,
                                   Constants.KEY_CITY           : response["city"]! as! String,
                                   Constants.KEY_PHONENUMBER    : "",
                                   Constants.KEY_RANGEALARM     : response["rangeAlarm"]! as! String,
                                   Constants.KEY_PRIMARYRIDE    : response["primaryRidingStyle"]! as! String,
                                   Constants.KEY_MILESRIDE      : "",
                                   Constants.KEY_BRAKEFORCE     : response["preferredBrakingForce"]!, //
            Constants.KEY_LOCATION       : false,
            Constants.KEY_NOTIFICATION   : (response["notification"] as! String == "ON"),
            Constants.KEY_SAFETYBRAKE    : (response["safetyBrake"] as! String == "ON"),
            Constants.KEY_REVERSETURN    : (response["reverseTurned"] as! String == "ON"),
            Constants.KEY_TIMESTAMP      : getCurrentTimeString(),
            Constants.KEY_UNITS          : "M"
        ]
        CoreDataManager.getInstance().saveUserInfo(info)
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Onboarding", bundle: nil)
        let viewController = mainStoryboard.instantiateViewControllerWithIdentifier(Constants.STORYBOARD_ONBOARDING) as! UINavigationController
        UIApplication.sharedApplication().keyWindow?.rootViewController = viewController;
    }
    
    func saveUserDataFromAPI() {
        //TODO:
        // If app has backend, get data from API and save them to localDB
        // write avatar image with document path, and save the path string to DB
        
        //save email to global variable
        myEmail = self.emailFld.text!
        
        //init User entity of CoreData
        let info : NSDictionary = [Constants.KEY_EMAIL          : self.emailFld.text!,
                                   Constants.KEY_PASSWORD       : self.pwdFld.text!,
                                   Constants.KEY_FIRSTNAME      : "",
                                   Constants.KEY_LASTNAME       : "",
                                   Constants.KEY_HEIGHT         : "",
                                   Constants.KEY_WEIGHT         : "",
                                   Constants.KEY_TERRAIN        : "",
                                   Constants.KEY_AVATAR         : "",
                                   Constants.KEY_BIO            : "",
                                   Constants.KEY_COUNTRY        : "",
                                   Constants.KEY_STATE          : "",
                                   Constants.KEY_CITY           : "",
                                   Constants.KEY_PHONENUMBER    : "",
                                   Constants.KEY_RANGEALARM     : "off",
                                   Constants.KEY_PRIMARYRIDE    : "",
                                   Constants.KEY_MILESRIDE      : "",
                                   Constants.KEY_BRAKEFORCE     : "",
                                   Constants.KEY_LOCATION       : false,
                                   Constants.KEY_NOTIFICATION   : false,
                                   Constants.KEY_SAFETYBRAKE    : false,
                                   Constants.KEY_REVERSETURN    : false,
                                   Constants.KEY_PARENTLOCK     : false,
                                   Constants.KEY_TIMESTAMP      : getCurrentTimeString()
        ]
        
        //save
        CoreDataManager.getInstance().saveUserInfo(info)
        
        //transfer to first OnboardingViewController
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Onboarding", bundle: nil)
        let viewController = mainStoryboard.instantiateViewControllerWithIdentifier(Constants.STORYBOARD_ONBOARDING) as! UINavigationController
        UIApplication.sharedApplication().keyWindow?.rootViewController = viewController;
    }
    
    // MARK: - UITextField Delegate Method
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if (textField == emailFld) {
            pwdFld.becomeFirstResponder();
        } else if (textField == pwdFld) {
            textField.resignFirstResponder();
            UIView.animateWithDuration(2.5, animations: {
                //animation for move down bottomView
                self.bottomViewHeightConstraint.constant = 0
                if self.view.frame.size.height < 600 {
                    self.titleHeightConstraint.constant = 110
                }
                }, completion: nil)
        }
        return true;
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        //animation for move up bottomView
        UIView.animateWithDuration(3.5, animations: {
            self.bottomViewHeightConstraint.constant = Constants.HEIGHT_KEYBOARD
            if self.view.frame.size.height < 600 {
                self.titleHeightConstraint.constant = 65
            }
            }, completion: nil)
        
        return true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
