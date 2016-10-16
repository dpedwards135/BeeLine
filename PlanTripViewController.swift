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
    
    var currentTrip = Trip(orientation: "origin", orientationPoint: "New York City", waypoints: ["New Orleans", "Boston"])
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        /*
        
        defaults.removeObject(forKey: "currentTrip")

        if defaults.object(forKey: "currentTrip") == nil {
            var array1 : [String] = [String]()
            array1.append("spaghetti")
            array1.append("")
            array1.append("")
            array1.append("end")
            
            defaults.set(array1, forKey: "currentTrip")
            defaults.synchronize()
        } else {
            var array1 : [String] = [String]()
            array1.append("linguine")
            array1.append("")
            array1.append("")
            array1.append("end")
            
            defaults.set(array1, forKey: "currentTrip")
            defaults.synchronize()
        }
        
        defaults.set("Linguine", forKey: "currentTrip")
        
        if let testArray : AnyObject? = defaults.object(forKey: "currentTrip") as AnyObject?? {
            var savedTrip : [NSString] = testArray! as! [NSString]
            print(savedTrip)
        }
        */
        //let def = UserDefaults.standard
        var key = "keySave"
        
        var array1: [NSString] = [NSString]()
        array1.append("value 1")
        array1.append("value 2")
        
        //save
        var defaults = UserDefaults.standard
        defaults.set(array1, forKey: key)
        defaults.synchronize()
        
        //read
        if let testArray : AnyObject? = defaults.object(forKey: key) as AnyObject?? {
            var readArray : [NSString] = testArray! as! [NSString]
            print(readArray)
        }
        

    }
    
    func saveTripToDefaults(trip : Trip) {
        var key = "keySave"
        
        var array1: [NSString] = [NSString]()
        array1.append("value 1")
        array1.append("value 2")
        
        //save
        var defaults = UserDefaults.standard
        defaults.set(array1, forKey: key)
        defaults.synchronize()
        
        //read
        if let testArray : AnyObject? = defaults.object(forKey: key) as AnyObject?? {
            var readArray : [NSString] = testArray! as! [NSString]
            print(readArray)
        }

    }
    
    func readTripFromDefaults(key : String) -> Trip {
        
        var key = key
        
        var readArray : [NSString]
        
        var savedTrip = Trip(orientation: "", orientationPoint: "", waypoints: [])
        
        readArray = defaults.object(forKey: key) as! [NSString]
        
        print(readArray)
        
        savedTrip.orientation = readArray[0] as String
        
        savedTrip.orientationPoint = readArray[1] as String
        
        var waypointsArray : [NSString] = []
        
        var i = 1
        while i <= readArray.count {
            waypointsArray.append(readArray[i+1])
            i += 1
        }
        
        return savedTrip
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        //defaults.set((orientation: "origin", orientationPoint: "Richmond, VA", waypoints: ["Farmville, VA", "Lynchburg, VA", "Charlotte, NC"]), forKey: "currentTrip")
 
        //defaults.set("SuperCal", forKey: "currentTrip")
        print("View Disappearing")
        var readArray : [NSString]  = defaults.object(forKey: "keySave") as! [NSString]
        print(readArray)
    }
    
    // MARK: Properties
    
    // Get current trip
    
    
        
        //Trip(orientation: "origin", orientationPoint: "Richmond, VA", waypoints: ["Farmville, VA", "Lynchburg, VA", "Charlotte, NC"])
    
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
