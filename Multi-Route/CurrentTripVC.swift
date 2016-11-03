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

class CurrentTripVC: UIViewController, GMSMapViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    

    var analyzedTrip : AnalyzedTrip?
    var selectedStop : Int = 0
    var pickerView : UIPickerView?
    var toolBar : UIToolbar?
    
    @IBOutlet weak var nearbyServicesInput: UITextField!
    @IBOutlet weak var navigationButton: UIButton!
    @IBOutlet weak var optionView: UIView!
    
    @IBOutlet weak var stopNameLabel: UILabel!

    @IBOutlet weak var mileageLabel: UILabel!
    
    var services = ["Select Service","Hotel", "Food", "Coffee", "Gas"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Configure nearbyServicesInput
        
        pickerView = UIPickerView()
        pickerView?.delegate = self
        self.nearbyServicesInput.delegate = self
        
        
        toolBar = UIToolbar()
        
        toolBar?.barStyle = UIBarStyle.default
        toolBar?.isTranslucent = true
        toolBar?.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar?.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: Selector("donePicker"))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: Selector("cancelPicker"))
        
        toolBar?.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar?.isUserInteractionEnabled = true
        
        nearbyServicesInput.inputView = pickerView
        nearbyServicesInput.inputAccessoryView = toolBar
        

        
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
            marker.snippet = "Test Snippet"
        
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
    
    //PickerView Configuration
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return services.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return services[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        nearbyServicesInput.text = services[row]
        //pickerView.removeFromSuperview()
        
        //Launch service request
        
    }
    
    func donePicker() {
    
        self.view.endEditing(true)
        print("DonePicker")
        
        //Get service name from text input
        //Query places API for types of that service
        //Display new markers on map
        
    }
    
    func cancelPicker() {
        self.view.endEditing(true)
        print("CancelPicker")
    }
    


}
