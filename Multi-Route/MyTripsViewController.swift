//
//  MyTripsViewController.swift
//  Multi-Route
//
//  Created by David Edwards on 10/7/16.
//  Copyright © 2016 David Edwards. All rights reserved.
//

import UIKit

// MARK: - ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate

class MyTripsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    let defaults = UserDefaults.standard
    var tripIndexArray : [String] = []
    var selectedTripKey = ""
    
    
    // Get allTrips data
    var allTrips : [Trip] = []
    

    func getTrips() {
        
        tripIndexArray = defaults.value(forKey: "tripIndex") as! [String]
        for String in tripIndexArray {
            
            var savedTrip = Trip(orientation: "", orientationPoint: "", waypoints: [])
            savedTrip = savedTrip.readTripFromDefaults(key: String)
            allTrips.append(savedTrip)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "Plan Trip Segue") {
            let planTripViewController : PlanTripViewController = segue.destination as! PlanTripViewController
            planTripViewController.tripKey = selectedTripKey
            print(selectedTripKey)
        

         }
    }
    
    
    override func viewDidLoad() {
        getTrips()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allTrips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SavedCell")!
        let trip = self.allTrips[indexPath.row]
        
        // Set the name of the saved trip
        cell.textLabel?.text = trip.orientationPoint
        
        // If the trip has stops, add them
        if let detailTextLabel = cell.detailTextLabel {
            var stopsText = ""
            for i in 0 ..< trip.waypoints.count {
                stopsText.append(trip.waypoints[i] + " ")
            }
            detailTextLabel.text = "Stops: \(stopsText)"
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTripKey = tripIndexArray[indexPath.row]
        performSegue(withIdentifier: "Plan Trip Segue", sender: self)
    }
    
    
    

}
