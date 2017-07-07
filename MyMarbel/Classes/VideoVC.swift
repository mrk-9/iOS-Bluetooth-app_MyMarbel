//
//  VideoVC.swift
//  MyMarbel
//
//  Created by Tmaas on 13/06/16.
//  Copyright © 2016 MBSolution. All rights reserved.
//

import UIKit

class VideoVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var videoCollectionView: UICollectionView!
    var wd: CGFloat! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        wd = self.view.frame.size.width - 6
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
       
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 20
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // Configure the cell
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("videoCellId", forIndexPath: indexPath) as! VideoCollectionViewCell
        cell.imgView.image = UIImage(named: "bg_intro.png")
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        if indexPath.row == 0
//        {
//            return CGSize(width:wd, height: wd * 0.8)
//        }
        return CGSize(width: wd / 2, height: wd / 2 * 0.8)
        
    }
    
    func collectionView(collectionView: UICollectionView!, relativeHeightForItemAtIndexPath indexPath: NSIndexPath!) -> Float {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView!, isDoubleColumnAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return false
    }
    
    func numberOfColumnsInCollectionView(collectionView: UICollectionView!) -> UInt {
        return 2
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
