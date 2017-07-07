//
//  RangeVC.swift
//  MyMarbel
//
//  Created by Tmaas on 11/05/16.
//  Copyright © 2016 MBSolution. All rights reserved.
//

import UIKit
import Mapbox
import CoreLocation

class RangeVC: UIViewController, CLLocationManagerDelegate, MGLMapViewDelegate {

    @IBOutlet var mapView: MGLMapView!
    @IBOutlet var circleView: UIView!
    
    @IBOutlet var percentLbl: UILabel!
    @IBOutlet var milesLbl: UILabel!
    @IBOutlet var minutesLbl: UILabel!
    
    var locationManager = CLLocationManager()
    var userLocation : CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        mapView.layer.zPosition = 0
        
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.Follow, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

//        addCurcleProgress(100)
        
    }
    
    func addCurcleProgress(percent: Double) {
        let dist = circleView.frame.size.width - 0
        let angle: Double = percent / 100 * 360
        var progress: TMCircularProgress!
        progress = TMCircularProgress(frame: CGRect(x: 0, y: 76, width: dist+40, height: dist+40))
        progress.startAngle = 180
        progress.progressThickness = 0.07
        progress.trackThickness = 0.0
        progress.clockwise = true
        progress.gradientRotateSpeed = 0
        progress.roundedCorners = false
        progress.glowMode = .Forward
        progress.glowAmount = 0.0
        progress.setColors(Constants.mbNeonYellow, Constants.mbDarkBlue)
        progress.center = CGPointMake(circleView.center.x, circleView.center.y - 0)
        mapView.addSubview(progress)
        
        progress.angle = angle
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let location = locations.last! as CLLocation
        userLocation = location
        
        print("location = \(location.coordinate)")
        // Do any additional setup after loading the view.
        //     let point = MGLPointAnnotation()
        //  point.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        //   mapView.addAnnotation(point)
        // mapView.layer.zPosition = 0
        
        
//        let point = MGLPointAnnotation()
//        point.coordinate = userLocation.coordinate
//        point.title = "Current Location"
//        mapView.addAnnotation(point)
        
        
//        mapView.setCenterCoordinate(CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), zoomLevel: 12, animated: false)
        
        
    }
    
    func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage? {
        if annotation.title! == "You Are Here" {
            var annotaionImage = mapView.dequeueReusableAnnotationImageWithIdentifier("You Are Here")
            var image = UIImage(named: "pin.png")
            image = image?.imageWithAlignmentRectInsets(UIEdgeInsetsMake(0, 0, 25, 25))
            annotaionImage = MGLAnnotationImage(image: image!, reuseIdentifier:"User location")
            return annotaionImage!
        } else {
            return nil
        }
    }
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always try to show a callout when an annotation is tapped.
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
