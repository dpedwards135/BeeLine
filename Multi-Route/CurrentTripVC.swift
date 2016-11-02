//
//  CurrentTripVC.swift
//  Multi-Route
//
//  Created by David Edwards on 10/22/16.
//  Copyright © 2016 David Edwards. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit

class CurrentTripVC: UIViewController {
    

    var analyzedTrip : AnalyzedTrip?

    @IBOutlet weak var mileageLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let camera = GMSCameraPosition.camera(withLatitude: analyzedTrip!.stopDetails[0].stopLat, longitude: analyzedTrip!.stopDetails[0].stopLong, zoom: 6)
        
        let frame = CGRect(x: 0, y: 0, width: 100.0, height: 100.0)
        
        //GMSCameraPosition.camera(withLatitude: -33.868,
                       //                                   longitude:151.2086, zoom:6)
        let mapView = GMSMapView.map(withFrame: frame, camera:camera)
        
        for stopDetail in (analyzedTrip?.stopDetails)! {
        
            let marker = GMSMarker()
        
            marker.position = CLLocationCoordinate2DMake(stopDetail.stopLat, stopDetail.stopLong)
            //marker.icon = UIImage(named: <#T##String#>)
            marker.snippet = "Hello World"
            marker.appearAnimation = kGMSMarkerAnimationPop
            marker.map = mapView
          
        }
        
        self.view.insertSubview(mapView, at: 0)
        
        //goToNavigation(lat: 25.76, long: -80.19)


        self.view.bringSubview(toFront: mileageLabel)
        mileageLabel.text = "Miles: " + "\(analyzedTrip!.directionsMileage)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func goToNavigation(lat : Double, long : Double) {
    
        let coordinate = CLLocationCoordinate2DMake(lat,long)
    
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
    
        mapItem.name = "Target location"
    
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
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
