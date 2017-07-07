//
//  StatsVC.swift
//  MyMarbel
//
//  Created by Tmaas on 11/05/16.
//  Copyright © 2016 MBSolution. All rights reserved.
//

import UIKit

class StatsVC: UITableViewController {

    var titleAry: [String] = []
    var dataAry: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        initArray()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        initArray()
        getData()
    }
    
    func initArray() {
        titleAry = ["Odometer", "Ride Time", "Number of Rides", "Average Speed", "Efficiency Score", "Average Ride Distance", "MAX Hill Incline", "# of Full Charges", "Total Elevation Gain", "Longest Ride", "Biggest Hill", "Longest Time + 20 mgh", "Saved on Parking", "Gallons of Gas Saved", "Rongaine Saved", "LBS of CO2 Saved"]
        
        dataAry = ["0 miles", "0 hours 0 minutes", "0", "0.0 MPH", "0%", "0 miles", "0%", "0", "0FT", "0 miles", "0 miles", "0 minutes", "$0", "0 gallons", "0 packets", "0 lbs"]
        /*
         Ride Time               : 80 hours 12 minutes
         Number of Rides         : 609
         Average Ride Distance   : 6.8 miles
         Longest Rides           : 18.3 miles
         Average Speed           : 15.3 MPH
         Odometer                : 1089 miles
         Efficiency Score        : 76%
         MAX Hill Incline        : 19%
         # of Full Charges       : 552
         Total Elevation Gain    : 12,488FT
         Biggest Hill            : 2.1 miles
         Longest Time + 20 mgh   : 17 minutes
         Saved on Parking        : $2350
         Gallons of Gas Saved    : 32 gallons
         Rongaine Saved          : 17 packets
         LBS of CO2 Saved        : 1.7 lbs
         */
        
    }
    
    func getData() {
        //TODO: get data from db
        let rides = CoreDataManager.getInstance().getAllRides()
        
        if rides.count == 0 {
            print("No ride found")
            return;
        }
        let ridesPoints = CoreDataManager.getInstance().getRidePointInfo()
        if ridesPoints.count == 0 {
            print("DB has no ride points")
            return;
        }
        titleAry.removeAll()
        dataAry.removeAll()
        
        // Trip Duration
        var sum = (rides as AnyObject).valueForKeyPath("@sum.tripDuration") as! Int
        let hours = Int(sum/60)
        sum = sum - hours * 60
        titleAry.append("Ride Time")
        dataAry.append("\(hours) hours \(sum) minutes")
        
        titleAry.append("Number of Rides")
        dataAry.append("\(rides.count)")
        
        let avgDistanceMeter = (rides as AnyObject).valueForKeyPath("@avg.tripDistance") as! Float
        let avgDistanceMiles = avgDistanceMeter/1609.34
        titleAry.append("Average Ride Distance")
        dataAry.append(String(format:"%.1f miles",avgDistanceMiles))
        
        let longestDistanceMeter = (rides as AnyObject).valueForKeyPath("@max.tripDistance") as! Int
        let longestDistanceMiles = Float(longestDistanceMeter)/1609.34
        titleAry.append("Longest Rides")
        dataAry.append(String(format:"%.1f miles",longestDistanceMiles))
        
        let avgSpeedMeter = (ridesPoints as AnyObject).valueForKeyPath("@avg.speed") as! Float
        let avgSpeedMiles = avgSpeedMeter/1609.34
        titleAry.append("Average Speed")
        dataAry.append(String(format:"%.1f MPH",avgSpeedMiles))
        
        //odometer from board directly and/or m_board API
        
        //ride time from m_board API
        
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleAry.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:StatsTableViewCell = tableView.dequeueReusableCellWithIdentifier(Constants.CELL_STATS) as! StatsTableViewCell
        
        let title: String! = titleAry[indexPath.row]
        cell.titleLbl.text = title
        
        let data: String! = dataAry[indexPath.row]
        cell.valueLbl.text = data
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let title: String = titleAry[indexPath.row]
        let popView = MStatsPopView(frame:self.view.frame, title: title, describe: "This is test text. The average speed if calculated on your all of your rides. This is YOUR average speed and is independent whichever Marbel Board you are riding.")
        self.view.superview!.addSubview(popView)
        
    }
   
}
