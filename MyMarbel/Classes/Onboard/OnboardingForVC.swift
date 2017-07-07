//
//  OnboardingForVC.swift
//  MyMarbel
//
//  Created by Tmaas on 18/05/16.
//  Copyright © 2016 MBSolution. All rights reserved.
//

import UIKit

class OnboardingForVC: UIViewController {

    @IBOutlet var rideImg1: UIImageView!
    @IBOutlet var rideImg2: UIImageView!
    
    @IBOutlet var nextBtn: UIButton! {
        didSet{
            makeRoundView(nextBtn, radius: 3.0, color: UIColor.clearColor(), width: 1.0)
        }
    }
    
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setTerrainImages(rideImg1, index: 1)
        index = 1
    }

    // MARK: - Button Actions
    
    @IBAction func backBtnClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func skipBtnClicked(sender: AnyObject) {
        goNextVC()
    }
    
    @IBAction func nextBtnClicked(sender: AnyObject) {
        //update terrian in CoreData
        var terrianStyle : String! = Constants.TERRIAN_FLAT
        if index == 1 {
            terrianStyle = Constants.TERRIAN_FLAT
        }else {
            terrianStyle = Constants.TERRIAN_HILL
        }
        
        CoreDataManager.getInstance().updateUserStrInfo(myEmail, key: Constants.KEY_TERRAIN, value: terrianStyle)
        
        goNextVC()
    }
    
    // UITapGesture Event of terrian image
    @IBAction func tapRideImage(sender: UITapGestureRecognizer) {
        index = sender.view?.tag
        if  index == 1{ //selected first image - flat
            setTerrainImages(rideImg1, index: 1)
            setTerrainImages(rideImg2, index: 0)
        } else { //selected second image - small hill
            setTerrainImages(rideImg1, index: 0)
            setTerrainImages(rideImg2, index: 1)
        }
    }
    
    func setTerrainImages(view: UIImageView, index: Int) {
        view.image = UIImage(named: "img_ridelook\(view.tag)_\(index).png")
    }
    
    func goNextVC() {
        self.performSegueWithIdentifier(Constants.SEGUE_ONBOARD_4TO5, sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
