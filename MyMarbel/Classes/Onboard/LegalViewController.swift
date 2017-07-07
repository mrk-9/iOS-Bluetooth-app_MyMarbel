//
//  LegalViewController.swift
//  MyMarbel
//
//  Created by Tmaas on 18/05/16.
//  Copyright © 2016 MBSolution. All rights reserved.
//

import UIKit

class LegalViewController: UIViewController {

    @IBOutlet var txtview: UITextView!{
        didSet{
            txtview.text = Constants.LEGAL_MESSAGE
            txtview.textColor = UIColor.whiteColor()
            makeRoundView(txtview, radius: 1.0, color: UIColor.lightGrayColor(), width: 1.0)
        }
    }
    
    @IBOutlet weak var agreeButton: UIButton!{
        didSet{
            makeRoundView(agreeButton, radius: 4.0, color: UIColor.clearColor(), width: 1.0)
        }
    }
    
    @IBOutlet weak var didNotAgreeButton: UIButton!{
        didSet{
            makeRoundView(didNotAgreeButton, radius: 4.0, color: UIColor.clearColor(), width: 1.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func backBtnClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func notNowBtnClicked(sender: AnyObject) {
        let alertControl = UIAlertController(title: "Alert", message: "You can't use the app before you ensure.", preferredStyle: .Alert)
        let item1 = UIAlertAction(title: "I understand", style: .Default, handler: {(action) -> Void in
            UIControl().sendAction(#selector(NSURLSessionTask.suspend), to: UIApplication.sharedApplication(), forEvent: nil)
//            NSThread.sleepForTimeInterval(1.0)
//            exit(0)
        })

        alertControl.addAction(item1)
        presentViewController(alertControl, animated: true, completion: nil)
        
    }
    
    @IBAction func okBtnClicked(sender: AnyObject) {
        let alertControl = UIAlertController(title: "", message: "Warning text to do here.", preferredStyle: .Alert)
        let item1 = UIAlertAction(title: "I understand", style: .Default, handler: {(action) -> Void in
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(true, forKey: "isOnboard")
            defaults.synchronize()
            
            self.goTabBarVC()
        })
        
        alertControl.addAction(item1)
        presentViewController(alertControl, animated: true, completion: nil)
    }
    
    func goTabBarVC() {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewControllerWithIdentifier(Constants.STORYBOARD_TABBAR) as! UITabBarController
        UIApplication.sharedApplication().keyWindow?.rootViewController = viewController;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
