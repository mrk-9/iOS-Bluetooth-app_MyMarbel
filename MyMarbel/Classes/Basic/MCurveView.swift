//
//  MCurveView.swift
//  MyMarbel
//
//  Created by tmaas on 01/06/16.
//  Copyright © 2016 MBSolution. All rights reserved.
//

import UIKit

class MCurveView: UIView {

    var curve        : UIBezierPath!
    var postFlatLine : UIBezierPath!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    convenience init(frame: CGRect, accel: CGFloat, topSpeed: CGFloat) {
        self.init(frame:frame)
        self.backgroundColor = UIColor.clearColor()
        applyCurveWithAcceleration(accel, topSpeed: topSpeed)
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        
        Constants.mbBlue.setStroke()
        curve!.stroke()
        postFlatLine!.stroke()
    }
    

    func applyCurveWithAcceleration(accel: CGFloat, topSpeed: CGFloat) {
        
        curve =  UIBezierPath()
        curve.lineWidth = 2.0
        
        let grapHeight = self.frame.size.height
        let grapWeidth = self.frame.size.width
        
        let headerAndFooterHeight = grapHeight * 0.1
        let maxCurveDelta = grapHeight - headerAndFooterHeight * 8
        
        let curveStartPoint : CGPoint = CGPointMake(-1, (grapHeight - headerAndFooterHeight))
        let curveEndPoint   : CGPoint = CGPointMake(grapWeidth - (accel * 20) + headerAndFooterHeight, maxCurveDelta - topSpeed * maxCurveDelta / 20 + headerAndFooterHeight)
        
        curve.moveToPoint(curveStartPoint)
        
        let cp1 = CGPointMake(curveEndPoint.x / 2, curveEndPoint.y)
        let cp2 = CGPointMake(curveEndPoint.x / 2, curveEndPoint.y)
        
        curve.addCurveToPoint(curveEndPoint, controlPoint1: cp2, controlPoint2: cp1)
        
        postFlatLine =  UIBezierPath()
        postFlatLine.lineWidth = 2.0
        
        let postFlatLineStartPoint = curveEndPoint
        let postFlatLineEndPoint   = CGPointMake(curveEndPoint.x + 414 - curveEndPoint.x, curveEndPoint.y)
        
        postFlatLine.moveToPoint(postFlatLineStartPoint)
        postFlatLine.addLineToPoint(postFlatLineEndPoint)
        
//        Constants.mbBlue.setStroke()
//        curve!.stroke()
//        postFlatLine!.stroke()
        
        self.setNeedsDisplay()
    }
}
