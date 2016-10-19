//
//  CurrentTripViewController.swift
//  Multi-Route
//
//  Created by David Edwards on 10/19/16.
//  Copyright © 2016 David Edwards. All rights reserved.
//

import UIKit
import GoogleMaps

class CurrentTripViewController: UIViewController {
    
    
    
    /*
     Next: Be able to send a request with the waypoints selected and receive the optimized waypoints and list the total distance of the route
     How?: 1. This takes place in the PlanTripVC with a submit button. When the user hits the button it takes the current trip and submits it to Google, receives JSON back, parses JSON and pulls all the leg distances and adds them together. It also pulls the array of optimized waypoints. For this week, all I have to worry about is the distances.
            2. So I need to build a submit button that retrieves all of this and then passes it to Current Trip
     1. Submit Button
     2. Submit HTTP request
     3. Receive JSON into data object
     4. Parse JSON
     5. Add up distances
     6. Pass distances to Current Trip View
 */

    override func loadView() {
        

        
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
    }
}
