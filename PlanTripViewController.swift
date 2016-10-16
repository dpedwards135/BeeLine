//
//  PlanTripViewController.swift
//  Multi-Route
//
//  Created by David Edwards on 10/4/16.
//  Copyright © 2016 David Edwards. All rights reserved.
//
import UIKit

// MARK: - ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate

class PlanTripViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var currentTrip = Trip(orientation: "", orientationPoint: "", waypoints: ["", ""])
    
    let defaults = UserDefaults.standard
    
    var tripKey = ""
    
    override func viewDidLoad() {
        
        //Put code here that checks if there is a key sent in to access a new trip, otherwise assign "currentTrip" key
        // ELSE:
        tripKey = "currentTrip"
        //
        
        currentTrip = currentTrip.readTripFromDefaults(key: tripKey)
        //What I want to have happen: If there is no key sent in then just access currentTrip. Whatever is in the view when you exit, that is saved as "currentTrip", if a key is sent in to this view, use that to access the trip instead.

    }
    
    func saveTrip() {
        //Create SAVE TRIP button so that you don't get the popup every time
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        currentTrip.orientation = "origin"
        currentTrip.orientationPoint = "New York City"
        currentTrip.waypoints = ["Omaha", "New Orleans", "Salt Lake", "Jackson", "Tampa"]
        
        //add code that presents popup that asks if you want to save this trip, and use current date as key
        currentTrip.saveTripToDefaults(key: tripKey, trip: currentTrip)
    }
    
    
    func deleteRow(sender: UIButton, indexPath : IndexPath, tableView : UITableView) {
        currentTrip.waypoints.remove(at:indexPath.row)
        tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
    }
    
    func buttonTouch(sender: UIButton) {
        print("Button Touch")
    }
    

    
    // MARK: Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if self.currentTrip.waypoints.count == 0 {
            return 2
        } else {
            return (self.currentTrip.waypoints.count) + 1
        }
        
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DestinationCell")! as! PlanTripCellTableViewCell
        
        
        
        // Set the name
        if indexPath.row == 0 {
            cell.mainLabel?.text = "Origin"
            cell.textInput?.text = currentTrip.orientationPoint
            //Disappear "Clear Button
            
            

        } else {
            cell.mainLabel?.text = "Destination"
            if currentTrip.waypoints == [] {
                cell.textInput?.text = ""
            } else {
                cell.textInput?.text = currentTrip.waypoints[indexPath.row - 1 ]

            }        }

       /* if let detailTextLabel = cell.detailTextLabel {
            let stopsText = point
            detailTextLabel.text = "Point: \(stopsText)"
        } */

        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .delete
        {
            currentTrip.waypoints.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableViewRowAnimation.automatic)
        }
    }
}
