//
//  OnboardingSecVC.swift
//  MyMarbel
//
//  Created by Tmaas on 18/05/16.
//  Copyright © 2016 MBSolution. All rights reserved.
//

import UIKit

class OnboardingSecVC: UIViewController {

    var rulerImg: UIImageView!
    
    @IBOutlet var frontView: UIView!
    @IBOutlet var rideImg: UIImageView!
    @IBOutlet var meterLbl: UILabel!
    @IBOutlet var inchLbl: UILabel!
    
    @IBOutlet var nextBtn: UIButton! {
        didSet{
            makeRoundView(nextBtn, radius: 3.0, color: UIColor.clearColor(), width: 1.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        initViews()
    }
    
    func initViews() {
        
        if rulerImg == nil {
            // add blue ruler image
            addRulerImage()
            
            // first, display average height
            displayHeight(0.5)
        }
        
    }
    
    func addRulerImage() {
        let image = UIImage(named: "blue_ruler.png")
        rulerImg = UIImageView(image: image)
        rulerImg.frame = CGRectMake(0, 0, 2, 103)
        frontView.addSubview(rulerImg)
        rulerImg.center = rideImg.center
    }
    
    // UITapGesture Event
    @IBAction func changeValue(sender: AnyObject) {
        let point = sender.locationInView(sender.view)
        let xPosition = point.x + rideImg.frame.origin.x
        rulerImg.frame.origin.x = xPosition
        
        let w = rideImg.frame.size.width
        let value   : Double = Double(point.x / w)
        displayHeight(value)
    }
    
    //PanGesture Event
    @IBAction func changeValuebyPanGesture(sender: UIPanGestureRecognizer) {
        let point = sender.locationInView(sender.view)
        let xPosition = point.x + rideImg.frame.origin.x
        rulerImg.frame.origin.x = xPosition
        
        let w = rideImg.frame.size.width
        let value   : Double = Double(point.x / w)
        displayHeight(value)
    }
    
    // calculate height and set them to UILabels
    func displayHeight(value: Double) {
        //height range: 4'6" ~ 7'0", 140.21 ~ 213.36cm, ratio:30.48
        
        let ratio   : Double = 0.3048
        let deltaFt : Double = 2.4
        let baseFt  : Double = 4.6
        
        let valueFt = Double(round(10 * value * deltaFt)/10)  + baseFt
        let valueCm = Double(round(100 * valueFt * ratio)/100)
        
        print("ft = \(valueFt), cm = \(valueCm)")
        
        inchLbl.text = convertDoubleToFootString(valueFt)
        meterLbl.text = "\(valueCm) m"
    }
    
    // MARK: - Button Actions
    
    @IBAction func backBtnClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func skipBtnClicked(sender: AnyObject) {
        goNextVC()
    }
    
    @IBAction func nextBtnClicked(sender: AnyObject) {
        
        //update height of DB
        CoreDataManager.getInstance().updateUserStrInfo(myEmail, key: Constants.KEY_HEIGHT, value: inchLbl.text!)
        
        goNextVC()
    }
    
    func goNextVC() {
        self.performSegueWithIdentifier(Constants.SEGUE_ONBOARD_2TO3, sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
