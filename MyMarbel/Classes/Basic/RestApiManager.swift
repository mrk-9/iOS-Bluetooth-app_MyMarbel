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
    case UpdateUserInfo = "saveuserinformation"
    case UpdateRideInfo = "saverideinformation"
    case UpdateRidePoint = "saveridepoint"
    case UpdateBoardInfo = "saveboardinformation"
    case CreateOrUpdateRide = "rides"
    case AddRidePoints = "ridespoints"
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
                
                print(NSString(data:responseData, encoding: NSUTF8StringEncoding))
                
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
            foreG(send, status)
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
    
    
    // MARK: - Ride
    
    func createOrUpdateRide(boardId:String, callBack: (Int?, Bool) -> Void) -> Void {
        
        let rideData = [
            "user_id"       : myUserID,
            "board_ID"      : "123",
            "est_start_st"  : "Saket Nagar",
            "ride_name"     : "MyRide \(getCurrentTimeString)"
        ]
       // let service: RestApiManager = RestApiManager.init()
        
        self.apiCall(rideData as! Dictionary<String, AnyObject>, callType: APICallType.POST, callName: APICallName.CreateOrUpdateRide) { (response, success) in
            
            //Pending receiving rideID
            if success {
                let resDtn : Dictionary<String, AnyObject> = response?.objectForKey("data") as! Dictionary<String, AnyObject>
                let newRideId = Int((resDtn["ride_ID"] as? String)!)
                
                print("Ride Created \(resDtn.description)")
                
                callBack(newRideId, success)
            } else {
                callBack(-1, false)
            }
        }
    }
    
    func updateRide(callBack: (Int?, Bool) -> Void) -> Void {
        
        if currentRideId < 1 {
            return;
        }
        let currentRide = CoreDataManager.getInstance().getRideForId(currentRideId)
        
        if currentRide == nil {
            print("No ride stored in db")
            return
        }
        
        let ridePoint = CoreDataManager.getInstance().getRidePointsForRideId(currentRideId)

        var duration = 0
        var distance = 0.0
        if ridePoint.count > 0 {
            let avgSpeed = (ridePoint as AnyObject).valueForKeyPath("@avg.speed") as! Float
            let startPoint = ridePoint[0]
            let endPoint = ridePoint[ridePoint.count-1]
        
            let startTime = getTimeStringToDate(startPoint.timestamp!)
            let endTime = getTimeStringToDate(endPoint.timestamp!)
            
            duration = Int(endTime.timeIntervalSinceDate(startTime))
            let diffTimeInHours = Float(Float(duration)/(60*60))
            
            distance = Double(avgSpeed * diffTimeInHours)
            
        } 
        
        CoreDataManager.getInstance().saveRideInfo([
            Constants.KEY_USERID: myUserID,
            Constants.KEY_BOARD_ID: 123,
            Constants.KEY_RIDE_ID:currentRideId,
            Constants.KEY_EST_FINISH: "End To",
            Constants.KEY_TRIP_DURATION:duration,
            Constants.KEY_TRIP_DIST:distance
            ])
        
        
        let rideData:Dictionary<String, AnyObject> = [
                                                      "board_ID" : 123,
                                                      "est_start_st": (currentRide?.estimatedStartStreet)!,
                                                      "ride_name":(currentRide?.rideName)!,
                                                      "trip_distance" : distance,
                                                      "trip_duration" : duration,
                                                      "est_finish_st" : (currentRide?.estimatedFinishStreet)!,
                                                      "temp_f"        : (currentRide?.tempF)!,
                                                      "humidity"      : (currentRide?.humidity)!,
                                                      "ride_ID"       : (currentRide?.rideID)!]
        
        //
        let service: RestApiManager = RestApiManager.init()
        
        service.apiCall(rideData, callType: APICallType.POST, callName: APICallName.CreateOrUpdateRide) { (response, success) in
            
          //  var rideid : Int?
            callBack(currentRideId, success)
            //Pending receiving rideID
            if response != nil {
//                self.updateRidePoints()
            }
        }
    }
    
    func updateRidePoints(callBack: (Bool) -> Void) -> Void {
        if currentRideId < 1 {
            print("current ride id not set")
            callBack(false)
            return;
        }
        // Get ride Points from Cire data
        let ridePoints = CoreDataManager.getInstance().getRidePointsForRideId(currentRideId)
        
        if ridePoints.count == 0 {
            print("No ride points stored in db")
            callBack(false)
            return
        }
        var ridepointArray = [NSDictionary]()
        
        for ridePnt in ridePoints as [RidePoint] {
            let keys = Array(ridePnt.entity.attributesByName.keys)
            let dict = ridePnt.dictionaryWithValuesForKeys(keys)
            
            ridepointArray.append(dict)
        }
        
//        let currentRide = CoreDataManager.getInstance().getRideForId(currentRideId)
        
        let rideData:Dictionary<String, AnyObject> = [
            "ride_points"   : ridepointArray
        ]
        
        let service: RestApiManager = RestApiManager.init()
        
        service.apiCall(rideData, callType: APICallType.POST, callName: APICallName.AddRidePoints) { (response, success) in
            
            
            callBack(success)
        }
    }

}