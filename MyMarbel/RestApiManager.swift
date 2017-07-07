//
//  RestApiManager.swift
//  MyMarbel
//
//  Created by Dhiru on 06/07/16.
//  Copyright © 2016 MBSolution. All rights reserved.
//

import Foundation

public enum APICallType : String {
    case GET = "GET"
    case POST = "POST"
};

public enum APICallName : String {
    case SignIn = "appsignin"
};

class RestApiManager: NSObject {
    
    func apiCall(params :Dictionary<String , AnyObject>!, callType: APICallType!, callName: APICallName, afterCall: (AnyObject?, Bool) -> Void) -> Void {
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: config)
        
        var todoEndpoint: String = String(format: "%@", Constants.API_URL)
        
        todoEndpoint.appendContentsOf(String(callName.rawValue))
        
        guard let url = NSURL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            sendToForeGround(nil, foreG: afterCall)
            return
        }
        
        let urlRequest = NSMutableURLRequest(URL: url)
        
        urlRequest.HTTPMethod = String(callType.rawValue)
        
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.HTTPBody = getData(params)
        
        
        let task = session.dataTaskWithRequest(urlRequest, completionHandler: { (data, response, error) in
            guard error == nil else {
                print("Error calling on API")
                self.sendToForeGround(error, foreG: afterCall)
                return
            }
            guard let responseData = data else {
                print("Error: Data not received")
                self.sendToForeGround(nil, foreG: afterCall)
                return
            }
            
            do {
                guard let userData = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as? [String: AnyObject] else {
                    print("Error: While trying to convert data to JSON : " + String(responseData))
                    self.sendToForeGround(nil, foreG: afterCall)
                    return
                }
                print("Response received:\n" + userData.description)
                self.sendToForeGround(userData, foreG: afterCall)
            }
            catch  {
                print("error trying to convert data to JSON-"+String(responseData))
                self.sendToForeGround(nil, foreG: afterCall)
                return
            }
        })
        task.resume()
    }
    
    private func sendToForeGround(send: AnyObject?,foreG: (AnyObject?, Bool) -> Void) {
        dispatch_sync(dispatch_get_main_queue(), {
            let resp = send as! Dictionary<String, AnyObject>
            
            let status: Bool = (resp["status"] as! String == "200")
            
            let data: AnyObject? = resp["data"]
            foreG(data, status)
        })
    }
    
    func getData(params :Dictionary<String , AnyObject>!) -> NSData {
        
        var paramStr: String = ""
        
        for (key, value) in params {
            if paramStr.characters.count > 0 {
                paramStr.appendContentsOf("&")
            }
            paramStr.appendContentsOf(String(format: "%@%@%@", key, "=", String(value)))
        }
        return paramStr.dataUsingEncoding(NSUTF8StringEncoding)!
    }
}