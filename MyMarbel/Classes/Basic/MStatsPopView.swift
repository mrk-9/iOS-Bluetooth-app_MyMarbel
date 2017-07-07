//
//  MStatsPopView.swift
//  MyMarbel
//
//  Created by Thomas Maas on 13/07/16.
//  Copyright © 2016 MBSolution. All rights reserved.
//

import UIKit

class MStatsPopView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    convenience init(frame: CGRect, title: String, describe: String) {
        self.init(frame:frame)
        self.backgroundColor = UIColor.clearColor()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
//        tap.delegate = self
        self.addGestureRecognizer(tap)
        
        let sh : CGFloat = self.frame.width - 60
        let x = (self.frame.width - sh) / 2
        let y = (self.frame.height - sh) / 2 - 20
        
        let subview = UIView(frame: CGRectMake(x, y , sh, sh))
        subview.backgroundColor = UIColor(white: 0, alpha: 0.7)
        subview.layer.borderColor = UIColor.whiteColor().CGColor
        subview.layer.borderWidth = 2.0
        self.addSubview(subview)
        
        //title
        let label1 = UILabel(frame: CGRectMake(0, 10, sh, 25))
        label1.textAlignment = NSTextAlignment.Center
        label1.text = title
        label1.textColor = UIColor.whiteColor()
        label1.font = UIFont.boldSystemFontOfSize(20)
        label1.backgroundColor = UIColor.clearColor()
        subview.addSubview(label1)
        
        //text
        let label2 = UILabel(frame: CGRectMake(10, 40, sh - 20 , sh - 40))
        label2.textAlignment = NSTextAlignment.Center
        label2.text = describe
        label2.textColor = UIColor.whiteColor()
        label2.font = UIFont.systemFontOfSize(16)
        label2.lineBreakMode = .ByWordWrapping
        label2.numberOfLines = 0
        label2.backgroundColor = UIColor.clearColor()
        subview.addSubview(label2)
    }

    func handleTap(sender: UITapGestureRecognizer? = nil) {
        print("handleTap1")
        self.removeFromSuperview()
    }
}
