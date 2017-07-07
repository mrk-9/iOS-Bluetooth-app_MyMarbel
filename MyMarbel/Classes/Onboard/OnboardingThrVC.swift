//
//  OnboardingThrVC.swift
//  MyMarbel
//
//  Created by Tmaas on 18/05/16.
//  Copyright © 2016 MBSolution. All rights reserved.
//

import UIKit

class OnboardingThrVC: UIViewController {

    var rulerImg: UIImageView!
    
    @IBOutlet var frontView: UIView!
    @IBOutlet var rideImg: UIImageView!
    @IBOutlet var lbsLbl: UILabel!
    @IBOutlet var kgLbl: UILabel!
    
    @IBOutlet var nextBtn: UIButton! {
        didSet{
            makeRoundView(nextBtn, radius: 3.0, color: UIColor.clearColor(), width: 1.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(self.initViews), userInfo: nil, repeats: false)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        initViews()
    }
    
    func initViews() {
        
        if rulerImg == nil {
            // add blue ruler image
            addRulerImage()
            
            // first, display average weight
            displayWeight(0.5)
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
        print("  \(point.x)")
        let xPosition = point.x + rideImg.frame.origin.x
        rulerImg.frame.origin.x = xPosition
        
        let w = rideImg.frame.size.width
        let value   : Double = Double(point.x / w)
        displayWeight(value)
    }
    
    //PanGesture Event
    @IBAction func changeValuebyPanGesture(sender: UIPanGestureRecognizer) {
        let point = sender.locationInView(sender.view)
        print("  \(point.x)")
        let xPosition = point.x + rideImg.frame.origin.x
        rulerImg.frame.origin.x = xPosition
        
        let w = rideImg.frame.size.width
        let value   : Double = Double(point.x / w)
        displayWeight(value)
    }
    
    // calculate weight and set them to UILabels
    func displayWeight(value: Double) {
        //weight range: 50 ~ 300lbs, 22 ~ 136kg, ratio:0.453592
        
        let ratio   : Double = 0.453592
        let deltaLbs : Double = 250
        let baseLbs  : Int = 50
        
        let valueLbs = Int(value * deltaLbs)  + baseLbs
        let valueKg  = Int(Double(valueLbs) * ratio)
        
        print("lbs = \(valueLbs), kg = \(valueKg)")
        
        lbsLbl.text = "\(valueLbs) lbs"
        kgLbl.text = "\(valueKg) kg"
    }
    
    // MARK: - Button Actions
    
    @IBAction func backBtnClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func skipBtnClicked(sender: AnyObject) {
        goNextVC()
    }
    
    @IBAction func nextBtnClicked(sender: AnyObject) {
        
        //update weight of DB
        CoreDataManager.getInstance().updateUserStrInfo(myEmail, key: Constants.KEY_WEIGHT, value: lbsLbl.text!)
        
        goNextVC()
    }
    
    func goNextVC() {
        self.performSegueWithIdentifier(Constants.SEGUE_ONBOARD_3TO4, sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
