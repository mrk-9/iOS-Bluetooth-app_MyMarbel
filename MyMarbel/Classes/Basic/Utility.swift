//
//  Utility.swift
//  MyMarbel
//
//  Created by Tmaas on 11/05/16.
//  Copyright © 2016 MBSolution. All rights reserved.
//
//

import UIKit
import AudioToolbox

// Check email is valid
func validateEmail(email : String) -> Bool {
    let EMAIL_REGULAR_EXPRESSION:String =  "[A-Z0-9a-z]+[A-Z0-9a-z._%+-]*@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    let testValue : NSPredicate = NSPredicate(format : "SELF MATCHES %@", EMAIL_REGULAR_EXPRESSION);
    if(testValue.evaluateWithObject(email)) {
        return true;
    }
    return false;
}

// Show AlertView
func showAlertWithTitle (title : String, msg : String) {
    let alert       = UIAlertView();
    alert.title     = title;
    alert.message   = msg;
    alert.addButtonWithTitle("OK");
    alert.show();
}

// Set round of view
func makeRoundView (item: AnyObject, width: CGFloat, color: UIColor) {
    item.layer.cornerRadius = item.frame.size.height / 2
    item.layer.masksToBounds = true
    item.layer.borderColor = color.CGColor
    item.layer.borderWidth = width
}

func makeRoundView (item: AnyObject, radius: CGFloat, color: UIColor, width: CGFloat) {
    item.layer.cornerRadius = radius
    item.layer.masksToBounds = true
    item.layer.borderColor = color.CGColor
    item.layer.borderWidth = width
}

// Get image by color
func imageWithColor (img: UIImageView, color: UIColor) {
    img.image = img.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
    img.tintColor = color
}

// Get current date and time
func getCurrentTimeString() -> String{
    let now = NSDate()
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy h:mm:ss a"
    return dateFormatter.stringFromDate(now)
}

func getTimeStringToDate(timeStr:String) -> NSDate {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy h:mm:ss a"
    let date = dateFormatter.dateFromString(timeStr)
    return date!
}

//convert Ft to Meter
func convertDoubleToFootString(value:Double) -> String {
    let txt = "\(value)"
    let txtAry = txt.characters.split{$0 == "."}.map(String.init)
    let fValue = txtAry[0]
    let sValue = txtAry[1]
    let str = "\(fValue)'\(sValue)\""
    return str
}

/* ///////////////////////////////
// read/write file and get path
*/ ///////////////////////////////

func getDocumentsURL() -> NSURL {
    let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
    return documentsURL
}

func fileInDocumentsDirectory(filename: String) -> String {
    
    let fileURL = getDocumentsURL().URLByAppendingPathComponent(filename)
    return fileURL.path!
    
}

func saveImage (image: UIImage, path: String ) -> Bool{
    let pngImageData = UIImagePNGRepresentation(image)
    //let jpgImageData = UIImageJPEGRepresentation(image, 1.0)   // if you want to save as JPEG
    let result = pngImageData!.writeToFile(path, atomically: true)
    return result
}

func downloadImage(url: NSURL, onDone:(Bool) -> Void){
    print("Download Started")
    let session : NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    let urlRequest = NSMutableURLRequest(URL: url)
    let task = session.dataTaskWithRequest(urlRequest, completionHandler: { (data, response, error) in
        guard error == nil else {
            onDone(false)
            return
        }
        guard let data = data else {
            onDone(false)
            return
        }
        let img : UIImage = UIImage.init(data: data)!
        let myImageName: String = "mbAvatar.png"
        let imagePath = fileInDocumentsDirectory(myImageName)
        saveImage(img, path: imagePath)
        onDone(true)
    })
    task.resume()
}

func loadImageFromPath(path: String) -> UIImage? {
    
    let image: UIImage!
    
    if path.rangeOfString("http://mymarbel.com/") != nil {
        //TODO here
        image = UIImage(contentsOfFile: path)
        
        if image == nil {
            
            print("missing image at: \(path)")
        }
    } else {
        image = UIImage(contentsOfFile: path)
        
        if image == nil {
            
            print("missing image at: \(path)")
        }
    }
    
    
    print("Loading image from path: \(path)") // this is just for you to see the path in case you want to go to the directory, using Finder.
    return image
    
}

/* ///////////////////////////////
// Convert variable type
*/ ///////////////////////////////

func numberToBool(intValue: NSNumber) ->Bool {
    if intValue == 0 {
        return false
    }else {
        return true
    }
}

func stringToBool(str: String) ->Bool {
    if str == "0" {
        return false
    }else {
        return true
    }
}

func boolToNumber(intValue: Bool) ->NSNumber {
    if !intValue {
        return 0
    }else {
        return 1
    }
}

// extension
extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}