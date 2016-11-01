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

class Trip {
    
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
    
    public func saveTripToDefaults(key : String, trip : Trip) {
        
        var myTrip  = trip
        
        var saveArray : [NSString] = [NSString]()
        
        saveArray.append(myTrip.orientation as NSString)
        saveArray.append(myTrip.orientationPoint as NSString)
        for waypoint in myTrip.waypoints {
            saveArray.append(waypoint as NSString)
        }
        
        //save
        var defaults = UserDefaults.standard
        defaults.set(saveArray, forKey: key)
        defaults.synchronize()
        
        //read
        if let testArray : AnyObject? = defaults.object(forKey: key) as AnyObject?? {
            var readArray : [NSString] = testArray! as! [NSString]
            print(readArray)
        }
        
    }
    
    public func readTripFromDefaults(key : String) -> Trip {
        
        print("reading trip")
        
        var defaults = UserDefaults.standard
        
        var key = key
        
        var readArray : [NSString]
        
        var savedTrip = Trip(orientation: "", orientationPoint: "", waypoints: [])
        
        if let objectCheck : AnyObject? = defaults.object(forKey: key) as AnyObject?? {
            
            readArray = defaults.object(forKey: key) as! [NSString]
            
            print(readArray)
            
            savedTrip.orientation = readArray[0] as String
            
            savedTrip.orientationPoint = readArray[1] as String
            
            var i = 2
            let arrayEndIndex = readArray.endIndex
            while i < arrayEndIndex {
                savedTrip.waypoints.append(readArray[i] as String)
                i += 1
            }
        }
        
        
        return savedTrip
    }

}
