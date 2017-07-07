//
//  ScanBoardVC.swift
//  MyMarbel
//
//  Created by Tmaas on 18/05/16.
//  Copyright © 2016 MBSolution. All rights reserved.
//

import UIKit
import CoreBluetooth

class ScanBoardVC: UIViewController{
    
    @IBOutlet var mainTitleLbl: UILabel!
    @IBOutlet var subTitleLbl: UILabel!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var midTxtLbl: UILabel!
    @IBOutlet var connectBtn: UIButton! {
        didSet{
            makeRoundView(connectBtn, radius: 3.0, color: UIColor.clearColor(), width: 1.0)
        }
    }
    
    var status: Int!
    
//    static var STATUS_START      : Int = 0
//    static var STATUS_SCAN       : Int = 1
//    static var STATUS_CONNECT    : Int = 2
//    static var STATUS_FINISH     : Int = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        status = 0
        
        // Add NSNotificationCenter for scanBoard
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(searchingBoard),
            name: Constants.MSSearchingNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(getSerialNumber),
            name: Constants.MSDidConnectNotification,
            object: nil)
        
    }

    // MARK: - NSNotification Methods
    
    func searchingBoard(notification: NSNotification){
        
        print("searching...")
        changeStatus(1)
    }
    
    func getSerialNumber(notification: NSNotification){
        
        print("get serial number")
        changeStatus(2)
    }
    
    // MARK: - Button Actions
    
    @IBAction func backBtnClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func skipBtnClicked(sender: AnyObject) {
        goLegalViewController()
    }
    
    @IBAction func connectBtnClicked(sender: AnyObject) {
        if status == 2 {
            changeStatus(3)
        } else if status == 3 {
            goLegalViewController()
        }
    }
   
    // UITapGesture Event of Centre Image
    @IBAction func tapCenterImage(sender: AnyObject) {
        if status == 0 {
            MBluetoothManager.sharedInstance.startScan()
            print("searching...")
            changeStatus(1)
        }
    }
    
    func changeStatus(st: Int) {
        status = st
        if st == 1 {
            //when tapped centreImage
            
            midTxtLbl.text = "Scanning..."
            imgView.image = UIImage(named: "img_nearby1.png")
            
            //rotate anomation
            let rotateAnimation = CABasicAnimation(keyPath:"transform.rotation")
            rotateAnimation.fromValue = 0.0
            rotateAnimation.toValue = CGFloat(M_PI * 2.0)
            rotateAnimation.duration = 2
            self.imgView.layer.addAnimation(rotateAnimation, forKey: nil)
            
        } else if st == 2 {
            //when scanBoard is finished
            
            let defaults = NSUserDefaults.standardUserDefaults()
            let sn = defaults.objectForKey(Constants.MS_SERIAL_NUMBER) as! String
            /*
            let boardAry = CoreDataManager.getInstance().getBoardInfo() as [Board]
            let info: Board = boardAry[0]
            let sn : String = info.mainSerialNumber!
            */
            
            if sn != "" {
                midTxtLbl.text = sn
            } else {
                midTxtLbl.text = "MB1204536" //device serial number
            }
            
            midTxtLbl.textColor = Constants.mbGreen
            imgView.image = UIImage(named: "img_nearby2.png")
            connectBtn.hidden = false
            
        } else if st == 3 {
            //when click connect button
            
            mainTitleLbl.text = "Ta-Da!"
            subTitleLbl.text = "That was easy! Your new Marbel Board is all set up and ready to ride."
            imgView.image = UIImage(named: "img_checked.png")
            midTxtLbl.text = ""
            connectBtn.setTitle("Finish", forState: .Normal)
        }
    }
    
    func goLegalViewController() {
        self.performSegueWithIdentifier(Constants.SEGUE_ONBOARD_LEGAL, sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
