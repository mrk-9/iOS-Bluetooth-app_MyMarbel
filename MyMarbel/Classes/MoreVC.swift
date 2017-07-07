//
//  MoreVC.swift
//  MyMarbel
//
//  Created by Tmaas on 11/05/16.
//  Copyright © 2016 MBSolution. All rights reserved.
//

import UIKit

class MoreVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var titleAry: [String] = []
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleAry = ["Edit Profile", "Settings", "Support", "Video", "Store"] //, "Log out"
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)

        self.tabBarController?.tabBar.hidden = false
//        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func tapLogout(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(true, forKey: "logout")
        defaults.synchronize()
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewControllerWithIdentifier("loginVC") as! UINavigationController
        UIApplication.sharedApplication().keyWindow?.rootViewController = viewController;
    }
    
    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return titleAry.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:MoreTableViewCell = tableView.dequeueReusableCellWithIdentifier(Constants.CELL_MORE) as! MoreTableViewCell
        
        let title: String! = titleAry[indexPath.row]
        cell.titleLbl.text = title
        if indexPath.row == 0 {
            makeRoundView(cell.imgView, radius: 15, color: UIColor.whiteColor(), width: 1.0)
            cell.imgView.image = UIImage(named: "tab_2")
        } else {
            cell.imgView.image = UIImage(named: "menu_\(title)")
        }

//        if indexPath.row == 5 {
//            cell.accessoryType = .None
//        }
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var segue: String!
        
        if indexPath.row == 5 {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setBool(true, forKey: "logout")
            defaults.synchronize()
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = mainStoryboard.instantiateViewControllerWithIdentifier("loginVC") as! UINavigationController
            UIApplication.sharedApplication().keyWindow?.rootViewController = viewController;
        } else {
            if indexPath.row == 0 {
                segue = Constants.SEGUE_MORE_PROFILE
            } else if indexPath.row == 1 {
                segue = Constants.SEGUE_MORE_SETTINGS
            } else if indexPath.row == 2 {
                segue = Constants.SEGUE_MORE_SUPPORT
            } else if indexPath.row == 3 {
                segue = Constants.SEGUE_MORE_VIDEO
            } else if indexPath.row == 4 {
                segue = Constants.SEGUE_MORE_STORE
            } else{
                
            }
            
            self.tabBarController?.tabBar.hidden = true
            
            self.performSegueWithIdentifier(segue, sender: self)
        }
        
    }

}
