//
//  ConnectionManager.swift
//  MyMarbel
//
//  Created by Thomas Maas on 16/06/16.
//  Copyright © 2016 MBSolution. All rights reserved.
//

import UIKit

class ConnectionManager: NSObject {
    static let sharedInstance = ConnectionManager()
    private let BASE_URL = "Backend url"
    typealias ServiceResponse = (NSDictionary?, NSError?) -> Void
    
    //login
    func getUserByEmail(useremail: String, password: String, callback: ServiceResponse) -> Void {
        
    }
    
    
}
