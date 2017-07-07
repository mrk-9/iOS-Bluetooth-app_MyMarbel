//
//  StoreVC.swift
//  MyMarbel
//
//  Created by Tmaas on 11/05/16.
//  Copyright © 2016 MBSolution. All rights reserved.
//

import UIKit

class StoreVC: UIViewController {

    @IBOutlet var myWebview: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myWebview.loadRequest(NSURLRequest(URL: NSURL(string: Constants.URL_STORE)!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
