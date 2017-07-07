//
//  SettingTableVC.swift
//  MyMarbel
//
//  Created by Tmaas on 11/05/16.
//  Copyright © 2016 MBSolution. All rights reserved.
//

import UIKit

class SettingTableVC: UITableViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    var disconnectView: MDisconnectView!
    
    @IBOutlet var wheelImg76: UIImageView!
    @IBOutlet var wheelLbl76: UILabel!
    @IBOutlet var wheelImg100: UIImageView!
    @IBOutlet var wheelLbl100: UILabel!
    
    @IBOutlet var rangeAlarmFld: UITextField!
    @IBOutlet var serialNumberLbl: UILabel!
    
    @IBOutlet var versionLbl: UILabel!
    @IBOutlet var versionUpdateBtn: UIButton!
    @IBOutlet var vUpdateBtnWidthConst: NSLayoutConstraint!
    
    var wheelSize: String! = "76"
    
    @IBOutlet var unitsSwitch: TMCustomSwitch!{
        didSet{
            unitsSwitch.leftTitle = "M"
            unitsSwitch.rightTitle = "E"
            unitsSwitch.backgroundColor = Constants.mbBlue
            unitsSwitch.selectedBackgroundColor = Constants.mbBGColor
            unitsSwitch.titleColor = UIColor.clearColor()
            unitsSwitch.selectedTitleColor = Constants.mbBlue
            unitsSwitch.titleFont = UIFont.boldSystemFontOfSize(18)
            unitsSwitch.autoresizingMask = [.FlexibleWidth]
        }
    }
    
    @IBOutlet var notificationSwitch: TMCustomSwitch!{
        didSet{
            notificationSwitch.leftTitle = " "
            notificationSwitch.rightTitle = "✔︎"
            notificationSwitch.backgroundColor = Constants.mbBlue
            notificationSwitch.selectedBackgroundColor = Constants.mbBGColor
            notificationSwitch.titleColor = UIColor.clearColor()
            notificationSwitch.selectedTitleColor = Constants.mbBlue
            notificationSwitch.titleFont = UIFont.boldSystemFontOfSize(22)
            notificationSwitch.autoresizingMask = [.FlexibleWidth]
        }
    }
    
    @IBOutlet var mapboxSwitch: TMCustomSwitch!{
        didSet{
            mapboxSwitch.leftTitle = " "
            mapboxSwitch.rightTitle = "✔︎"
            mapboxSwitch.backgroundColor = Constants.mbBlue
            mapboxSwitch.selectedBackgroundColor = Constants.mbBGColor
            mapboxSwitch.titleColor = UIColor.clearColor()
            mapboxSwitch.selectedTitleColor = Constants.mbBlue
            mapboxSwitch.titleFont = UIFont.boldSystemFontOfSize(22)
            mapboxSwitch.autoresizingMask = [.FlexibleWidth]
        }
    }
    
    var m_pickerView: UIPickerView!
    var m_toolbar : UIToolbar!
    var pickerDataSourceAry: [String] = []
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if connected {
            if disconnectView != nil {
                disconnectView.removeFromSuperview()
                disconnectView = nil
            }
        } else {
            if disconnectView == nil {
                disconnectView = MDisconnectView(frame:self.view.frame)
                self.view.addSubview(disconnectView)
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        disconnectView.removeFromSuperview()
        disconnectView = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //get user data from DB
        let ary = CoreDataManager.getInstance().getUserInfo()
        let myProfile = ary[0]
        
        rangeAlarmFld.text = "Set to \(myProfile.rangeAlarm!)"
        notificationSwitch.setSelectedIndex(myProfile.notificationEnable! as Int, animated: false)
        mapboxSwitch.setSelectedIndex(myProfile.locationEnable! as Int, animated: false)
        
        let unit: String! = myProfile.units!
        print("units = \(unit)")
        if unit == "E" {
            unitsSwitch.setSelectedIndex(1, animated: false)
        }
        
        //get board data from DB
        let ary2 = CoreDataManager.getInstance().getBoardInfo()
        let myBoard = ary2[0]
        
        serialNumberLbl.text = myBoard.mainSerialNumber
        versionLbl.text = myBoard.firmwareVersion
        if versionLbl.text! == "V1.0" {
            versionUpdateBtn.hidden = true
            vUpdateBtnWidthConst.constant = 0
        }
        
        if myBoard.wheelSize == "100" {
            selectWheel(1)
        }
        
        preparePickerViewForRangeAlarm()
    }

    func preparePickerViewForRangeAlarm() {
        
        //set pickerView
        m_pickerView = UIPickerView.init(frame: CGRectZero)
        m_pickerView.delegate = self
        m_pickerView.dataSource = self
        
        //set toolbar to add Done button
        m_toolbar = UIToolbar.init(frame: CGRectMake(0, 0, self.view.bounds.size.width, 44))
        m_toolbar.barStyle = .Default
        let doneBtnItem : UIBarButtonItem! = UIBarButtonItem.init(title: "Done", style: .Done, target: self, action: #selector(doneBtnClicked))
        let flexibleItem: UIBarButtonItem! = UIBarButtonItem.init(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        m_toolbar.items = [flexibleItem, doneBtnItem]
        doneBtnItem.tintColor = UIColor.blackColor()
        
        rangeAlarmFld.inputView = m_pickerView
        rangeAlarmFld.inputAccessoryView = m_toolbar
        
        pickerDataSourceAry = ["10%", "25%", "50%", "off"]
    }
    
    
    // Done button action
    func doneBtnClicked() {
        rangeAlarmFld.resignFirstResponder()
        rangeAlarmFld.text = "Set to \(pickerDataSourceAry[m_pickerView.selectedRowInComponent(0)])"

        SwiftNotice.wait()
        performSelector(#selector(self.afterSaveAction), withObject: self, afterDelay: 2.0)
        
        CoreDataManager.getInstance().updateUserStrInfo(myEmail, key: Constants.KEY_RANGEALARM, value: pickerDataSourceAry[m_pickerView.selectedRowInComponent(0)])
    }
    
    func afterSaveAction() {
        SwiftNotice.clear()
        successNotice("Saved!", autoClear: true)
    }
    ////////////////////////////////////////////////////////////////////////
    // MARK: - Tapped wheel image

    @IBAction func tapWheel76(sender: UITapGestureRecognizer) {
        if wheelSize == "100" {
            SwiftNotice.wait()
            performSelector(#selector(self.afterSaveAction), withObject: self, afterDelay: 2.0)
            
            CoreDataManager.getInstance().updateBoardStrInfo(myUserID, key: Constants.KEY_WHEEL, value: "76")
            
            selectWheel(0)
        }
    }
    
    @IBAction func tapWheel100(sender: UITapGestureRecognizer) {
        if wheelSize == "76" {
            SwiftNotice.wait()
            performSelector(#selector(self.afterSaveAction), withObject: self, afterDelay: 2.0)
            
            CoreDataManager.getInstance().updateBoardStrInfo(myUserID, key: Constants.KEY_WHEEL, value: "100")
            
            selectWheel(1)
        }
    }
    
    func selectWheel(type: Int) {
        if type == 0 {
            wheelLbl76.textColor = Constants.mbBlue
            wheelLbl100.textColor = UIColor.whiteColor()
            
            imageWithColor(wheelImg100, color: UIColor.whiteColor())
            imageWithColor(wheelImg76, color: Constants.mbBlue)
            
            wheelSize = "76"
        } else {
            wheelLbl100.textColor = Constants.mbBlue
            wheelLbl76.textColor = UIColor.whiteColor()
            
            imageWithColor(wheelImg76, color: UIColor.whiteColor())
            imageWithColor(wheelImg100, color: Constants.mbBlue)
            
            wheelSize = "100"
        }
    }
    
    
    // Clicked update button
    @IBAction func updateBtnClicked(sender: AnyObject) {
        print("UPDATE AVAILABLE button clicked")
    }
    
    ////////////////////////////////////////////////////////////////////////
    // MARK: - UISwitch control actions
    
    @IBAction func unitsChangedAction(sender: TMCustomSwitch) {
        let unit: String!
        if sender.selectedIndex == 0 {
            unit = "M"
            print("M")
        } else {
            unit = "E"
            print("E")
        }
        
//        SwiftNotice.wait()
//        performSelector(#selector(self.afterSaveAction), withObject: self, afterDelay: 2.0)
        CoreDataManager.getInstance().updateUserStrInfo(myEmail, key: Constants.KEY_UNITS, value: unit!)
    }
    
    @IBAction func notificationChangedAction(sender: TMCustomSwitch) {
        let status : Bool!
        if sender.selectedIndex == 0 {
            status = false
        } else {
            status = true
        }
        
//        SwiftNotice.wait()
//        performSelector(#selector(self.afterSaveAction), withObject: self, afterDelay: 2.0)
        
        CoreDataManager.getInstance().updateUserBoolInfo(myEmail, key: Constants.KEY_NOTIFICATION, value: status)
    }
    
    @IBAction func mapboxChangedAction(sender: TMCustomSwitch) {
        let status : Bool!
        if sender.selectedIndex == 0 {
            status = false
        } else {
            status = true
        }
        
//        SwiftNotice.wait()
//        performSelector(#selector(self.afterSaveAction), withObject: self, afterDelay: 2.0)
        
        CoreDataManager.getInstance().updateUserBoolInfo(myEmail, key: Constants.KEY_LOCATION, value: status)
    }
    
    @IBAction func unitsSwitchAction(sender: UISwitch) {
//        let status : Bool!
//        if sender.on {
//            status = true
//        } else {
//            status = false
//        }
        
    }
    
    @IBAction func notificationSwitchAction(sender: UISwitch) {
        
        let status : Bool!
        if sender.on {
            status = true
        } else {
            status = false
        }
        
        CoreDataManager.getInstance().updateUserBoolInfo(myEmail, key: Constants.KEY_NOTIFICATION, value: status)
    }
    
    @IBAction func mapboxSwitchAction(sender: UISwitch) {
        
        let status : Bool!
        if sender.on {
            status = true
        } else {
            status = false
        }
        
        CoreDataManager.getInstance().updateUserBoolInfo(myEmail, key: Constants.KEY_LOCATION, value: status)
    }
    
    
    ////////////////////////////////////////////////////////////////////////
    // MARK: - UITextField Delegate Method
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder();
        
        return true;
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        m_pickerView.selectRow(0, inComponent: 0, animated: true)
        
        return true;
    }
    
    
    ////////////////////////////////////////////////////////////////////////
    // MARK: - UIPickerView Delegate Method
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSourceAry.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSourceAry[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        rangeAlarmFld.text = "Set to \(pickerDataSourceAry[m_pickerView.selectedRowInComponent(0)])"
    }
    
    
    ////////////////////////////////////////////////////////////////////////
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
