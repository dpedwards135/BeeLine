//
//  AnalyzedTrip.swift
//  Multi-Route
//
//  Created by David Edwards on 11/1/16.
//  Copyright © 2016 David Edwards. All rights reserved.
//

import Gloss
import UIKit
import GoogleMaps

class AnalyzedTrip {
    
    //Inputs and working variables
    private var waypointOrder : [Int] = []
    private var currentTrip = Trip(orientation: "", orientationPoint: "", waypoints: [""])
    private var origin = ""
    private var destination = ""
    private var destinationIndex = 0
    private var senderVC : PlanTripViewController
    
    //Outputs
    var stopDetails : [StopDetail] = []
    var directionsMileage : Double = 0
    var encodedPath : [GMSPath] = []
    
    init(currentTrip : Trip, viewControllerSender : UIViewController) {
        self.currentTrip = currentTrip
        self.senderVC = viewControllerSender as! PlanTripViewController
        getCounterOrientationPoint()
        
        
    }
    
    func buildGMUrl(counterPoint : String) {
        
        
        
        let baseURL : String = "https://maps.googleapis.com/maps/api/directions/json?"
        let orientationString = currentTrip.orientation.lowercased() + "=" + currentTrip.orientationPoint + ",&"
        var waypointsString = ""
        if currentTrip.waypoints.count > 0 {
            waypointsString = "waypoints=optimize:true"
            for waypoint in currentTrip.waypoints {
                waypointsString.append("|\(waypoint)")
        
            }
        }
        var counterOrientationPoint = counterPoint
        var counterOrientationPointString : String
        if currentTrip.orientation == "Origin" {
            counterOrientationPointString = "destination=\(counterOrientationPoint),&"
        } else {
            counterOrientationPointString = "origin=\(counterOrientationPoint),&"
        }
        //let destinationString = "&destination=" + currentTrip.orientationPoint
        let keyString = "&key=AIzaSyAXKUya8igVCUOUAhlOVcatMYzzsM-1pJQ"
        
        var urlString = baseURL + orientationString + counterOrientationPointString + waypointsString + keyString
        
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        print(urlString)
        
        let gmURL = URL(string: urlString)
        
        getDirections(gmURL: gmURL!)
        
        
        return
    }
    
    func getCounterOrientationPoint() {
        
        var orientationCounterpoint = ""
        
        let baseURLString = "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial"
        let originString = "&origins=" + currentTrip.orientationPoint
        var destinationString : String = "&destinations="
        var waypointCounter = 0
        for waypoint in currentTrip.waypoints {
            if waypointCounter == 0 {
                destinationString.append(waypoint)
            } else {
                destinationString.append("|" + waypoint)
            }
            
            waypointCounter += 1
        }
        let keyString = "&key=AIzaSyAXKUya8igVCUOUAhlOVcatMYzzsM-1pJQ"
        
        var distanceMatrixString = baseURLString + originString + destinationString + keyString
        
        //distanceMatrixString = "https://maps.googleapis.com/maps/api/distancematrix/json?origins=Vancouver+BC|Seattle&destinations=San+Francisco|Victoria+BC&key=AIzaSyAXKUya8igVCUOUAhlOVcatMYzzsM-1pJQ"
        
        distanceMatrixString = distanceMatrixString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        var distanceMatrixURL = URL(string: distanceMatrixString)
        
        
        
        print(distanceMatrixURL)
        
        let task = URLSession.shared.dataTask(with: distanceMatrixURL!) { (data, response, error) in
            
            if error == nil {
                
                
                
                print("Error: Nil")
                
                /* Raw JSON data (...simliar to the format you might receive from the network) */
                var rawDistanceJSON = try? Data(contentsOf: distanceMatrixURL!)
                
                /* Error object */
                var parsingDistanceError: NSError? = nil
                
                /* Parse the data into usable form */
                var parsedDistanceJSON = try! JSONSerialization.jsonObject(with: rawDistanceJSON!, options: .allowFragments) as! NSDictionary
                
                print(parsedDistanceJSON)
                print("Directions Parsed")
                
                
                
                guard let distance = MatrixDistance(json: parsedDistanceJSON as! JSON) else {
                    print ("unable to parse")
                    return
                }
                
                return
                
                print(distance.rows[0].elements[0].distance!.value)
                
                var distanceArray : [Int] = []
                
                for element in distance.rows[0].elements {
                    //Pair the distance to it's waypoint and identify the largest
                    distanceArray.append((element.distance?.value)!)
                }
                
                let distanceArrayMax = distanceArray.max()
                
                self.destinationIndex = distanceArray.index(of: distanceArrayMax!)!
                
                
                
                print(self.destinationIndex)
                
                orientationCounterpoint = self.currentTrip.waypoints[self.destinationIndex]
                
                //Remove destination from waypoints to avoid double designation
                self.currentTrip.waypoints.remove(at: self.destinationIndex)
                
                print(orientationCounterpoint)
                
                //Add orientationCounterpoint to AnalyzedTrip.origin or destination
                
                if self.currentTrip.orientation == "Destination" {
                    self.destination = self.currentTrip.orientationPoint
                    self.origin = orientationCounterpoint
                } else {
                    self.destination = orientationCounterpoint
                    self.origin = self.currentTrip.orientationPoint
                }
                
                self.buildGMUrl(counterPoint: orientationCounterpoint)
                
                return
           
            }
            
            
            
        }
        task.resume()
        
    }
    
    
    func getDirections(gmURL : URL) {
        
        let task = URLSession.shared.dataTask(with: gmURL) { (data, response, error) in
            
            if error == nil {
                
                print("Error: Nil")
                
                /* Raw JSON data (...simliar to the format you might receive from the network) */
                var rawDirectionsJSON = try? Data(contentsOf: gmURL)
                
                /* Error object */
                var parsingDirectionsError: NSError? = nil
                
                /* Parse the data into usable form */
                var parsedDirectionsJSON = try! JSONSerialization.jsonObject(with: rawDirectionsJSON!, options: .allowFragments) as! NSDictionary
                
                print(parsedDirectionsJSON)
                print("Directions Parsed")
                
                guard let directions = Directions(json: parsedDirectionsJSON as! JSON) else {
                    print ("unable to parse")
                    return
                }
                
                print(directions.status)
                
                var totalDistance = 0
                var legs : [Leg]
                legs = (directions.routes[0].legs)
                print(legs.count)
                for item in legs{
                    
                    var distance = item.distance
                    var value = distance.value
                    
                    totalDistance = totalDistance + value
                    
                    
                }
                
                
                
                /*
                if self.currentTrip.orientation == "Origin" {
                    var lastLegIndex = legs.endIndex - 1
                    totalDistance = totalDistance - legs[lastLegIndex].distance.value
                } else {
                    totalDistance = totalDistance - legs[0].distance.value
                    
                }
                */
                self.directionsMileage = Double(totalDistance) * 0.000621371
                
                self.waypointOrder = directions.routes[0].waypointOrder
                
                ////////Assemble StopDetail Array for all points
                var geocodeArray : [String] = []
                for geocodedWaypoint in directions.geocodedWaypoints {
                    geocodeArray.append(geocodedWaypoint.placeID)
                }
                var originDetail = StopDetail(stopName: self.origin, stopGeolocation: geocodeArray[0], stopLat : 0, stopLong : 0)
                self.stopDetails.append(originDetail)
                for waypoint in self.waypointOrder {
                    var waypointDetail = StopDetail(stopName: self.currentTrip.waypoints[waypoint], stopGeolocation: geocodeArray[waypoint+1], stopLat : 0, stopLong : 0)
                    self.stopDetails.append(waypointDetail)
                }
                var destinationDetail = StopDetail(stopName: self.destination, stopGeolocation: geocodeArray.last!, stopLat : 0, stopLong : 0)
                self.stopDetails.append(destinationDetail)
                
                
                // Need to fix this so that it pulls the end coordinates off the last one, 1 less leg than stops
                

                self.stopDetails[0].stopLat = directions.routes[0].legs[0].startLocation.startLat
                self.stopDetails[0].stopLong = directions.routes[0].legs[0].startLocation.startLong

                var legCounter = 0
                for leg in directions.routes[0].legs {
                    
                        self.stopDetails[legCounter + 1].stopLat = directions.routes[0].legs[legCounter].endLocation.endLat
                    
                        self.stopDetails[legCounter + 1].stopLong = directions.routes[0].legs[legCounter].endLocation.endLong
                    
                        print(self.stopDetails[legCounter + 1].stopLat)
                    
                        legCounter += 1
                        
                 
                    
                }
                
                //Get Encoded Path 2 loops - Steps and Legs
                
                for leg in directions.routes[0].legs {
                    for step in leg.steps {
                        
                        var pathFromEncodedPath = GMSPath.init(fromEncodedPath: step.polyline.points)
                        print(pathFromEncodedPath)
                        self.encodedPath.append(pathFromEncodedPath!)
                        //self.encodedPath!.add(pathFromEncodedPath!)
                    }
                }
                
                print(self.encodedPath)
                print(self.waypointOrder)
                
                //print(directions.routes[0].legs[0].distance.value)
                print(self.directionsMileage)
                
                
                DispatchQueue.main.async {
                    
                    self.senderVC.performSegue(withIdentifier: "Current Trip Segue", sender: self)
                }
 
                
                return
            }
            
            
            
        }
        task.resume()
        
        return
        
    }
    

}
