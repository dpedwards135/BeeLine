//
//  MapTrip.swift
//  Multi-Route
//
//  Created by David Edwards on 11/12/16.
//  Copyright © 2016 David Edwards. All rights reserved.
//

import Gloss
import UIKit
import GoogleMaps

class MapTrip: NSObject {
    


        

        
        //Outputs
        var stopDetails : [StopDetail] = []
        var directionsMileage : Double = 0
        var encodedPath : [GMSPath] = []
        
        override init() {

            super.init()
            retrieveAnalyzedTrip()
            
            
        }
        
    
        func retrieveAnalyzedTrip() {
            let defaults = UserDefaults.standard
            
            
            if let objectCheck : AnyObject? = defaults.object(forKey: "stop_details") as AnyObject??  {
                
            } else {
                
                var stopDetail = StopDetail(stopName: "Welcome to BeeLine", stopGeolocation: "", stopLat: 38.9072, stopLong: -77.03)
                stopDetails.append(stopDetail)
                
                return
            }
            
            directionsMileage = defaults.double(forKey: "directions_mileage")
            
            //defaults.set(directionsMileage, forKey: "directions_mileage")
            
            
            var stopDetailArray : [String] = []
            
            
            stopDetailArray = defaults.array(forKey: "stop_details") as! [String]
            var stopDetailCount = stopDetailArray.count
            var stopDetailArrayCounter = 0
            while stopDetailArrayCounter < stopDetailCount {
                let name = stopDetailArray[stopDetailArrayCounter + 0]
                let lat = Double(stopDetailArray[stopDetailArrayCounter + 1])!
                let long = Double(stopDetailArray[stopDetailArrayCounter + 2])!
                let geocode = stopDetailArray[stopDetailArrayCounter + 3]
                
                let stopDetail = StopDetail(stopName: name, stopGeolocation: geocode, stopLat: lat, stopLong: long)
                stopDetails.append(stopDetail)
                stopDetailArrayCounter += 4
            }
            
            var pathArray : [String] = []
            pathArray = defaults.array(forKey: "encoded_path") as! [String]
            
            for path in pathArray {
                let gmsPath = GMSPath(fromEncodedPath: path)
                encodedPath.append(gmsPath!)
            }
            
            
            
            
            print("Trip Retrieved")
            
        }
        
        
        
    

}
