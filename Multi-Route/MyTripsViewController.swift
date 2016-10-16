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
    
    // MARK: Properties
    
    // Get allTrips data
    let allTrips = Trip.allTrips
    
    // MARK: Table View Data Source
    
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
}
