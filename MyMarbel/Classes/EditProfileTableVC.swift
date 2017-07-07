//
//  EditProfileTableVC.swift
//  MyMarbel
//
//  Created by Tmaas on 11/05/16.
//  Copyright © 2016 MBSolution. All rights reserved.
//

import UIKit

class EditProfileTableVC: UITableViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate {

    @IBOutlet var avatarImgView: UIImageView! {
        didSet{
            makeRoundView(avatarImgView, width: 1.0, color: UIColor.whiteColor())
        }
    }
    
    @IBOutlet var firstNameFld: UITextField!
    @IBOutlet var LastNameFld: UITextField!
    
    var m_pickerView: UIPickerView!
    var m_toolbar : UIToolbar!
    var currentTxtFld: UITextField!
    var titleAry: [String] = []
    var dataAry: [String] = []
    
    var pickerDataSourceAry: [String] = []
    var myProfile: User!
    
    let imagePicker = UIImagePickerController()
    var imageChanged: Bool! = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleAry = ["Email", "Password", "Height", "Weight", "Terrain"]
        
        //get data from DB and set init values
        getInfo()
        
        //set pickerView
        m_pickerView = UIPickerView.init(frame: CGRectZero)
        m_pickerView.delegate = self
        m_pickerView.dataSource = self
        
        firstNameFld.attributedPlaceholder = NSAttributedString(string: "FirstName", attributes: [NSForegroundColorAttributeName:UIColor.lightGrayColor()])
        LastNameFld.attributedPlaceholder = NSAttributedString(string: "LastName", attributes: [NSForegroundColorAttributeName:UIColor.lightGrayColor()])
        
        //set toolbar to add Done button
        m_toolbar = UIToolbar.init(frame: CGRectMake(0, 0, self.view.bounds.size.width, 44))
        m_toolbar.barStyle = .Default
        let doneBtnItem : UIBarButtonItem! = UIBarButtonItem.init(title: "Done", style: .Done, target: self, action: #selector(doneBtnClicked))
        let flexibleItem: UIBarButtonItem! = UIBarButtonItem.init(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        m_toolbar.items = [flexibleItem, doneBtnItem]
        doneBtnItem.tintColor = UIColor.blackColor()
        
        //imagePicker delegate
        imagePicker.delegate = self
    }

    func getInfo() {
        //get user data from DB
        let ary = CoreDataManager.getInstance().getUserInfo() 
        myProfile = ary[0]
        
        firstNameFld.text = myProfile.firstName!
        LastNameFld.text = myProfile.lastName!
        
        //add data to dataAry
        dataAry.append(myProfile.userEmail!)
        dataAry.append(myProfile.password!)
        dataAry.append(myProfile.height!)
        dataAry.append(myProfile.weight!)
        dataAry.append(myProfile.terrain!)
        
        // set avatar image
        if myProfile.avatar! != "" {
            print(myProfile.avatar!)
            
            let path: String = myProfile.avatar!
            
            if path.containsString("http") {
                downloadImage(NSURL.init(string: path)!, onDone: { (success) in
                    dispatch_sync(dispatch_get_main_queue(), { 
                        if success {
                            let myImageName = "mbAvatar.png"
                            let imagePath = fileInDocumentsDirectory(myImageName)
                            if let loadedImage = loadImageFromPath(imagePath) {
                                self.avatarImgView.image = loadedImage
                            }
                        }
                    })
                })
            }
            else if let loadedImage = loadImageFromPath(myProfile.avatar!) {
                print(" Loaded Image: \(loadedImage)")
                avatarImgView.image = loadedImage
            } else { print("some error message 2") }
        }
    }

    // Done button action
    func doneBtnClicked() {
        currentTxtFld.resignFirstResponder()
        currentTxtFld.text = pickerDataSourceAry[m_pickerView.selectedRowInComponent(0)]
    }
    
    ////////////////////////////////////////////////////////////////////////
    // MARK: - NavigationBarItem Actions
    
    @IBAction func cancelBtnClicked(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func saveBtnClicked(sender: AnyObject) {
        
        SwiftNotice.wait()
        performSelector(#selector(self.afterSaveAction), withObject: self, afterDelay: 3.0)
        
        // save edit profile info
        if firstNameFld.text! != myProfile.firstName {
            CoreDataManager.getInstance().updateUserStrInfo(myEmail, key: Constants.KEY_FIRSTNAME, value: firstNameFld.text!)
        }
        
        if LastNameFld.text! != myProfile.lastName {
            CoreDataManager.getInstance().updateUserStrInfo(myEmail, key: Constants.KEY_LASTNAME, value: LastNameFld.text!)
        }
        
        /* // userEmail not editable
        if let txtFld = self.view.viewWithTag(1) as? UITextField {
            if txtFld.text! != myProfile.userEmail  {
                CoreDataManager.getInstance().updateUserStrInfo(myEmail, key: Constants.KEY_EMAIL, value: txtFld.text!)
            }
        } */
        
        if let txtFld = self.view.viewWithTag(2) as? UITextField {
            if txtFld.text! != myProfile.password  {
                CoreDataManager.getInstance().updateUserStrInfo(myEmail, key: Constants.KEY_PASSWORD, value: txtFld.text!)
            }
        }
        
        if let txtFld = self.view.viewWithTag(3) as? UITextField {
            if txtFld.text! != myProfile.height  {
                CoreDataManager.getInstance().updateUserStrInfo(myEmail, key: Constants.KEY_HEIGHT, value: txtFld.text!)
            }
        }
        
        if let txtFld = self.view.viewWithTag(4) as? UITextField {
            if txtFld.text! != myProfile.weight  {
                CoreDataManager.getInstance().updateUserStrInfo(myEmail, key: Constants.KEY_WEIGHT, value: txtFld.text!)
            }
        }
        
        if let txtFld = self.view.viewWithTag(5) as? UITextField {
            if txtFld.text! != myProfile.terrain  {
                CoreDataManager.getInstance().updateUserStrInfo(myEmail, key: Constants.KEY_TERRAIN, value: txtFld.text!)
            }
        }
        
        if imageChanged == true {
            // Define the specific path, image name
            var newEmail = myProfile.userEmail!.stringByReplacingOccurrencesOfString("@", withString: "")
            newEmail = myProfile.userEmail!.stringByReplacingOccurrencesOfString(".", withString: "")
            let myImageName = "\(newEmail).png"
            let imagePath = fileInDocumentsDirectory(myImageName)
            
            if let image = avatarImgView.image {
                saveImage(image, path: imagePath)
                CoreDataManager.getInstance().updateUserStrInfo(myEmail, key: Constants.KEY_AVATAR, value: imagePath)
            } else { print("some error message") }
            
        }
        
        
    }
    
    func afterSaveAction() {
        SwiftNotice.clear()
        let alertControl = UIAlertController(title: "", message: "Saved successfully!", preferredStyle: .Alert)
        let item1 = UIAlertAction(title: "OK", style: .Default, handler: {(action) -> Void in
            self.navigationController?.popViewControllerAnimated(true)
        })

        alertControl.addAction(item1)
        presentViewController(alertControl, animated: true, completion: nil)
    }
    
    ////////////////////////////////////////////////////////////////////////
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titleAry.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:ProfileTableViewCell = tableView.dequeueReusableCellWithIdentifier(Constants.CELL_PROFILE) as! ProfileTableViewCell
        
        let title: String! = titleAry[indexPath.row]
        cell.titleLbl.text = title
        
        let data: String! = dataAry[indexPath.row]
        cell.txtFld.text = data
        cell.txtFld.tag = indexPath.row + 1
        
        if cell.txtFld.tag == 1 {
            cell.txtFld.enabled = false
        }
        
        if cell.titleLbl.text == "Password" {
            cell.txtFld.secureTextEntry = true
        }
        
        return cell
    }

    
    ////////////////////////////////////////////////////////////////////////
    // MARK: - UITextField Delegate Method
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder();
        
        return true;
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        
        currentTxtFld = textField
        
        //if textField is height, weight, terrian, add pickerView
        if textField.tag == 3 || textField.tag == 4 || textField.tag == 5 {
            pickerDataSourceAry = []
            textField.inputView = m_pickerView
            textField.inputAccessoryView = m_toolbar
            
            if textField.tag == 3 { //4.6 ~ 7'0"
                var selectedIndex: Int! = 999
                for i in 4 ..< 7 {
                    for j in 0...9 {
                        if i == 4 && j < 6 {
                            continue
                        }
                        let str: String! = "\(i)'\(j)\""
                        pickerDataSourceAry.append(str)
                        if str == myProfile.height {
                            selectedIndex = pickerDataSourceAry.count - 1
                        }
                    }
                }
                
                if selectedIndex == 999 {
                    selectedIndex = pickerDataSourceAry.count - 1
                }
                
                m_pickerView.reloadAllComponents()
                m_pickerView.selectRow(selectedIndex, inComponent: 0, animated: true)
            } else if textField.tag == 4 { // 50 ~ 300
                var selectedIndex: Int! = 0
                for index in 50...300 {
                    let str: String! = "\(index) lbs"
                    pickerDataSourceAry.append(str)
                    
                    if str == myProfile.weight {
                        selectedIndex = index - 50
                    }
                }
                m_pickerView.reloadAllComponents()
                m_pickerView.selectRow(selectedIndex, inComponent: 0, animated: true)
            } else if textField.tag == 5 {
                
                pickerDataSourceAry = ["Mostly Flat", "Hills"]
                m_pickerView.reloadAllComponents()
                
                var selectedIndex: Int! = 0
                if myProfile.terrain == Constants.TERRIAN_HILL {
                    selectedIndex = 1
                }
                m_pickerView.selectRow(selectedIndex, inComponent: 0, animated: true)
            }
        }
        
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
        currentTxtFld.text = pickerDataSourceAry[row]
    }
    
    
    ////////////////////////////////////////////////////////////////////////
    // MARK: - UIImagePickerController Delegate Method
    
    @IBAction func tapedAvatarImgView(sender: UITapGestureRecognizer) {
        let alertControl = UIAlertController(title: "Choose Image", message: "", preferredStyle: .ActionSheet)
        let item1 = UIAlertAction(title: "From Camera", style: .Destructive, handler: {(action) -> Void in
            self.imagePicker.allowsEditing = true
            if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
                self.imagePicker.sourceType = .Camera
            } else {
                self.imagePicker.sourceType = .PhotoLibrary
            }
            
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        })
        
        let item2 = UIAlertAction(title: "Photo Gallery", style: .Default, handler: {(action) -> Void in
            self.imagePicker.allowsEditing = true
            self.imagePicker.sourceType = .PhotoLibrary
            
            self.presentViewController(self.imagePicker, animated: true, completion: nil)
        })
        
        let item3 = UIAlertAction(title: "Cancel", style: .Cancel, handler: {(action) -> Void in
            print("Cancel")
        })
        alertControl.addAction(item1)
        alertControl.addAction(item2)
        alertControl.addAction(item3)
        
        presentViewController(alertControl, animated: true, completion: nil)
       
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            avatarImgView.image = pickedImage
            imageChanged = true
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
