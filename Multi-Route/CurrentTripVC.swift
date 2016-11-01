//
//  CurrentTripVC.swift
//  Multi-Route
//
//  Created by David Edwards on 10/22/16.
//  Copyright © 2016 David Edwards. All rights reserved.
//

import UIKit
import GoogleMaps

class CurrentTripVC: UIViewController {
    

    var analyzedTrip : AnalyzedTrip?

    @IBOutlet weak var mileageLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let camera = GMSCameraPosition()
        
        //GMSCameraPosition.camera(withLatitude: -33.868,
                       //                                   longitude:151.2086, zoom:6)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera:camera)
        
        let marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = "Hello World"
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = mapView
        
        self.view = mapView


        
        mileageLabel.text = "Miles: " + "\(analyzedTrip!.directionsMileage)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
     
     import UIKit
     import GoogleMaps
     
     class DemoViewController: UIViewController {
     
     override func viewDidLoad() {
     super.viewDidLoad()
     let camera = GMSCameraPosition.cameraWithLatitude(-33.868,
     longitude:151.2086, zoom:6)
     let mapView = GMSMapView.mapWithFrame(CGRectZero, camera:camera)
     
     let marker = GMSMarker()
     marker.position = camera.target
     marker.snippet = "Hello World"
     marker.appearAnimation = kGMSMarkerAnimationPop
     marker.map = mapView
     
     self.view = mapView
     }
     
     
     
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
