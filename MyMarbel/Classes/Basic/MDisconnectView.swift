//
//  MDisconnectView.swift
//  MyMarbel
//
//  Created by Thomas Maas on 13/07/16.
//  Copyright © 2016 MBSolution. All rights reserved.
//

import UIKit

class MDisconnectView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        let label = UILabel(frame: CGRectMake(0, 30, frame.width, 25))
        label.textAlignment = NSTextAlignment.Center
        label.text = "Disconnected"
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.boldSystemFontOfSize(17)
        label.backgroundColor = UIColor.clearColor()
        self.addSubview(label)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }

}
