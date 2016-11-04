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
import Gloss

class CurrentTripVC: UIViewController, GMSMapViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    

    var analyzedTrip : AnalyzedTrip?
    var selectedStop : Int = 0
    var nearbyPlaces : NearbyPlaces?
    var pickerView : UIPickerView?
    var mapView : GMSMapView?
    var toolBar : UIToolbar?
    var servicesMarkers : [GMSMarker] = []
    
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
        

        /*
        let camera = GMSCameraPosition.camera(withLatitude: analyzedTrip!.stopDetails[0].stopLat, longitude: analyzedTrip!.stopDetails[0].stopLong, zoom: 6)
        
        let frame = self.view.bounds.size
        

        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), camera:camera)
        mapView!.delegate = self
        
        var stopDetailCounter = 0
        for stopDetail in (analyzedTrip?.stopDetails)! {
        
            stopDetailCounter += 1
            let marker = GMSMarker()
            marker.title = "\(stopDetailCounter)"
            marker.snippet = "Test Snippet"
        
            marker.position = CLLocationCoordinate2DMake(stopDetail.stopLat, stopDetail.stopLong)
        
            let image = UIImage(named: "Map Marker \(stopDetailCounter)")
            let markerView = UIImageView(image: image)
            
            

            marker.iconView = markerView
            let height : Double = 50
            let width = height * 0.62
            marker.iconView?.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
            marker.appearAnimation = kGMSMarkerAnimationPop
            
            
            
            marker.map = mapView
          
        }
        */
        
        self.addStopMarkersAndRoute()
        
        self.view.addSubview(mapView!)

        /*
        
        for element in (analyzedTrip?.encodedPath)! {
            let path = element
            let polyline = GMSPolyline(path: path)
            polyline.strokeWidth = 5
            polyline.map = mapView
        }

        */
        
        self.view.bringSubview(toFront: mileageLabel)
        self.view.bringSubview(toFront: optionView)
        
        mileageLabel.text = "Miles: " + "\(Double(round(analyzedTrip!.directionsMileage * 10)/10))"
        navigationButton.isEnabled = false
        nearbyServicesInput.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addStopMarkersAndRoute() {
        
        let camera = GMSCameraPosition.camera(withLatitude: analyzedTrip!.stopDetails[0].stopLat, longitude: analyzedTrip!.stopDetails[0].stopLong, zoom: 6)
        
        let frame = self.view.bounds.size

        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), camera:camera)
        mapView!.delegate = self
        
        var stopDetailCounter = 0
        for stopDetail in (analyzedTrip?.stopDetails)! {
            
            stopDetailCounter += 1
            let marker = GMSMarker()
            marker.title = "\(stopDetailCounter)"
            marker.snippet = "Test Snippet"
            
            marker.position = CLLocationCoordinate2DMake(stopDetail.stopLat, stopDetail.stopLong)
            
            let image = UIImage(named: "Map Marker \(stopDetailCounter)")
            let markerView = UIImageView(image: image)
            

            marker.iconView = markerView
            let height : Double = 50
            let width = height * 0.62
            marker.iconView?.frame = CGRect(x: 0, y: 0, width: width, height: height)
            

            marker.appearAnimation = kGMSMarkerAnimationPop
            
            
            
            marker.map = mapView
            
        }
        
        for element in (analyzedTrip?.encodedPath)! {
            let path = element
            let polyline = GMSPolyline(path: path)
            polyline.strokeWidth = 5
            polyline.map = mapView
        }

    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("Marker Tapped \(marker.title!)")
        if Int(marker.title!)! < 100 {
            self.selectedStop = Int(marker.title!)!
            stopNameLabel.text = "\(marker.title!): \(analyzedTrip!.stopDetails[selectedStop-1].stopName)"
            navigationButton.setTitle("Navigation", for: UIControlState.normal)
            navigationButton.isEnabled = true
            nearbyServicesInput.isEnabled = true
        } else if Int(marker.title!)! >= 100 {
            self.selectedStop = Int(marker.title!)!
            stopNameLabel.text = "\((nearbyPlaces?.results[self.selectedStop-100].name)!)"
            navigationButton.setTitle("Navigation", for: UIControlState.normal)
            navigationButton.isEnabled = true
            nearbyServicesInput.isEnabled = true
        }
        
        
        
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

    
    
    func goToNavigation(lat : Double, long : Double) {
    
        let coordinate = CLLocationCoordinate2DMake(lat,long)
    
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
    
        mapItem.name = "Target location"
    
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }

    
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
        if selectedStop != 0 {
            getServices()
        }
        print("DonePicker")
        
        //Get service name from text input
        //Query places API for types of that service
        //Display new markers on map
        
    }
    
    func cancelPicker() {
        self.view.endEditing(true)
        print("CancelPicker")
    }
    

    func getServices() {
        var lat = 0.0
        var long = 0.0
        if selectedStop<100 {
            lat = (analyzedTrip?.stopDetails[selectedStop-1].stopLat)!
            long = (analyzedTrip?.stopDetails[selectedStop-1].stopLong)!
        } else {
            lat = (nearbyPlaces?.results[selectedStop-100].geometry.location.lat)!
            long = (nearbyPlaces?.results[selectedStop-100].geometry.location.long)!
        }
        let type = "meal_takeaway"
        let radius = 1500
        //let keyword =
        
        
        //https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=500&type=restaurant&keyword=cruise&key=AIzaSyAXKUya8igVCUOUAhlOVcatMYzzsM-1pJQ
        /* 
         Query API for list of services near selectedStop
         Add list to array
         Create markers for all services
         Display markers
         On Tap Pop-Up displays service info? Or just keep it all in the main bar? More button? Let's just keep it all in the same bar for now.
         
         */

        
        
        let baseURLString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
        var locationString = "location=\(lat),\(long)"
        var typeString = "&type=" + type
        //var keywordString = "&keyword" + keyword
        
        var radiusString = "&radius=\(radius)"
        var keyString = "&key=AIzaSyAXKUya8igVCUOUAhlOVcatMYzzsM-1pJQ"
        
        var finalString = baseURLString + locationString + typeString + /*keywordString + */ radiusString + keyString
        
        
        finalString = finalString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        var placeURL = URL(string: finalString)
        
        
        
        print(placeURL!)
        
        let task = URLSession.shared.dataTask(with: placeURL!) { (data, response, error) in
            
            if error == nil {
                
                print("Error: Nil")
                
                /* Raw JSON data (...simliar to the format you might receive from the network) */
                var rawPlaceJSON = try? Data(contentsOf: placeURL!)
                
                /* Error object */
                var parsingPlaceError: NSError? = nil
                
                /* Parse the data into usable form */
                var parsedPlaceJSON = try! JSONSerialization.jsonObject(with: rawPlaceJSON!, options: .allowFragments) as! NSDictionary
                
                print(parsedPlaceJSON)
                print("Services Parsed")
                
                
                self.nearbyPlaces = NearbyPlaces(json: parsedPlaceJSON as! JSON)
                
                
                DispatchQueue.main.async {
                    
                    self.placeServiceMarkers()
                }
                
              
                
                return
            }
            
            
            
        }
        task.resume()

 
 
    }
    
    func placeServiceMarkers() {
        
        if (servicesMarkers.count) > 0 {
            removeServiceMarkers()
        }
        
        
        
        var serviceCounter = 0
        for result in (nearbyPlaces?.results)! {
            
            
            let marker = GMSMarker()
            marker.title = "\(100+serviceCounter)"
            //marker.snippet = "Test Snippet"
            
            marker.position = CLLocationCoordinate2DMake(result.geometry.location.lat, result.geometry.location.long)
            
            let image = UIImage(named: "Map Marker Service")
            let markerView = UIImageView(image: image)
            
            
            
            //marker.icon = UIImage(named: "Map Marker \(stopDetailCounter)")
            marker.iconView = markerView
            let height : Double = 50
            let width = height * 0.62
            marker.iconView?.frame = CGRect(x: 0, y: 0, width: width, height: height)
            
            //marker.snippet = "Hello World"
            marker.appearAnimation = kGMSMarkerAnimationPop
            
            
            marker.map = mapView
            
            self.servicesMarkers.append(marker)
            serviceCounter += 1
            
        }

    }
    
    func removeServiceMarkers() {
        for marker in servicesMarkers {
            marker.map = nil
        }
        servicesMarkers.removeAll()
    }

}
