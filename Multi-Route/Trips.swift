//
//  Villains.swift
//  Multi-Route
//
//  Created by David Edwards on 10/4/16.
//  Copyright © 2016 David Edwards. All rights reserved.
//

import Foundation
import UIKit

/* What is the the data structure for trips? 
 * A struct, where 
 * Orientation = Origin or Destination, and
 * OrientationPoint = destination or origin
 * Waypoints = an array of waypoint strings
 *
 */

struct Trip {
    
    // MARK: Properties
    
    var orientation: String
    var orientationPoint: String
    var waypoints: Array<String>
    
    static let OrientationKey = "Orientation"
    static let OrientationPointKey = "OrientationPoint"
    static let WaypointsKey = "Waypoints"
    
    // MARK: Initializer
    
    // Generate a Trip from a three entry dictionary
    
    init(orientation: String, orientationPoint: String, waypoints: Array<String>) {
        self.orientation = orientation
        self.orientationPoint = orientationPoint
        self.waypoints = waypoints
    }
        
}


// MARK: - Trip (All Trips)

/**
 * This extension adds static variable allVillains. An array of Villain objects
 */

extension Trip {
    
    // Generate an array full of all of the trips in
    static var allTrips: [Trip] {
        
        var tripArray = [Trip]()
        
        let trip1 = Trip(orientation: "origin", orientationPoint: "New York City", waypoints: ["Salt Lake City", "Pocatello", "New Orleans"])
        let trip2 = Trip(orientation: "destination", orientationPoint: "Los Angeles", waypoints: ["San Diego", "San Bernadino", "San Francisco"])
        
        
        tripArray.append(trip1)
        tripArray.append(trip2)
        
        /*
        for d in Trip.localTripData() {
            tripArray.append(Trip(dictionary: d))
        }
        */
        
        return tripArray
    }
    
    static var currentTrip: Trip! {
        let thisTrip = Trip(orientation: "origin", orientationPoint: "Richmond, VA", waypoints: ["Farmville, VA", "Lynchburg, VA", "Charlotte, NC"])
        return thisTrip
    }
    
    
    /*
    static func localTripData() -> [[String : Any]] {
        return [
            [Trip.OrientationKey : "origin", Trip.OrientationPointKey : "Salt Lake City",  Trip.WaypointsKey : ["Salt Lake City", "New York City"]]
            
        ]
    }
    */
}
