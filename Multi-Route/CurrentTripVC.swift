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

class CurrentTripVC: UIViewController, GMSMapViewDelegate {
    

    var analyzedTrip : AnalyzedTrip?
    var selectedStop : Int = 0
    
    @IBOutlet weak var navigationButton: UIButton!
    @IBOutlet weak var optionView: UIView!
    
    @IBOutlet weak var stopNameLabel: UILabel!

    @IBOutlet weak var mileageLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let camera = GMSCameraPosition.camera(withLatitude: analyzedTrip!.stopDetails[0].stopLat, longitude: analyzedTrip!.stopDetails[0].stopLong, zoom: 6)
        
        let frame = self.view.bounds.size
        
            
            //CGRect(x: 0, y: 0, width: 100.0, height: 500.0)
        
        //GMSCameraPosition.camera(withLatitude: -33.868,
                       //                                   longitude:151.2086, zoom:6)
        let mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), camera:camera)
        mapView.delegate = self
        
        var stopDetailCounter = 0
        for stopDetail in (analyzedTrip?.stopDetails)! {
        
            stopDetailCounter += 1
            let marker = GMSMarker()
            marker.title = "\(stopDetailCounter)"
        
            marker.position = CLLocationCoordinate2DMake(stopDetail.stopLat, stopDetail.stopLong)
        
            let image = UIImage(named: "Map Marker \(stopDetailCounter)")
            let markerView = UIImageView(image: image)
            
            
           
            //marker.icon = UIImage(named: "Map Marker \(stopDetailCounter)")
            marker.iconView = markerView
            let height : Double = 50
            let width = height * 0.62
            marker.iconView?.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
            //marker.snippet = "Hello World"
            marker.appearAnimation = kGMSMarkerAnimationPop
            
            
            
            marker.map = mapView
          
        }
        self.view.addSubview(mapView)
        //self.view.insertSubview(mapView, at: 0)
        
        //goToNavigation(lat: 25.76, long: -80.19)

        //let path = GMSPath(fromEncodedPath: analyzedTrip!.encodedPath)
        
        for element in (analyzedTrip?.encodedPath)! {
            let path = element
            let polyline = GMSPolyline(path: path)
            polyline.strokeWidth = 5
            polyline.map = mapView
        }
        
        /*
        let path = GMSPath(fromEncodedPath: pathString)
        let polyline = GMSPolyline(path: path!)

        polyline.map = mapView
        */
        self.view.bringSubview(toFront: mileageLabel)
        self.view.bringSubview(toFront: optionView)
        mileageLabel.text = "Miles: " + "\(Double(round(analyzedTrip!.directionsMileage * 10)/10))"
        navigationButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("Marker Tapped \(marker.title!)")
        self.selectedStop = Int(marker.title!)!
        stopNameLabel.text = "Stop \(marker.title!)"
        navigationButton.setTitle("Navigation", for: UIControlState.normal)
        navigationButton.isEnabled = true
        
        return true
    }
    
    @IBAction func navigateToStop(_ sender: AnyObject) {
        
        if selectedStop == 0 {
            return
        }
        
        //Get coordinates
    
        let lat = self.analyzedTrip?.stopDetails[selectedStop-1].stopLat
        let long = self.analyzedTrip?.stopDetails[selectedStop-1].stopLong
        
        //GoToNavigation
        goToNavigation(lat: lat!, long: long!)
    }
    func openOptions() {
        
    }
    
    func closeOptions() {
        
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
