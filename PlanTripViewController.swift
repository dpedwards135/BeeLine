//
//  PlanTripViewController.swift
//  Multi-Route
//
//  Created by David Edwards on 10/4/16.
//  Copyright © 2016 David Edwards. All rights reserved.
//
import UIKit
import Gloss

// MARK: - ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate

class PlanTripViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    var currentTrip = Trip(orientation: "", orientationPoint: "", waypoints: ["", ""])
    var directionsMileage : Double = 0
    var waypointOrder : [Int] = []
    var stopDetails : [StopDetail] = []
    var analyzedTrip : AnalyzedTrip?
    
    
    
    @IBOutlet weak var saveTripButton: UIButton!

    
    
    let defaults = UserDefaults.standard
    
    var tripKey = ""
    
    var currentTripKey = "currentTrip"
    
    
    @IBOutlet var tableView: UITableView!
    
    @IBAction func submitTrip(_ sender: AnyObject) {
        
        print("Submitting Trip")
        writeCurrentTrip()
        saveTrip()
        analyzedTrip = AnalyzedTrip(currentTrip: currentTrip, viewControllerSender: self)
        print("Got AnalyzedTrip \(analyzedTrip!.directionsMileage)")
        
 

        //getCounterOrientationPoint() //Gets Destination, Builds URL, Pulls Directions and Distances
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "Current Trip Segue") {
            let currentTripViewController : CurrentTripVC = segue.destination as! CurrentTripVC
            
            //currentTripViewController.analyzedTrip = analyzedTrip
            
            print("Preparing for Segue")
        }
    }


    
    @IBAction func saveToMyTrips(_ sender: AnyObject) {
        
        writeCurrentTrip()
        
        let dateformatter = DateFormatter()
        
        dateformatter.dateStyle = DateFormatter.Style.short
        
        dateformatter.timeStyle = DateFormatter.Style.long
        
        let myTripKey = dateformatter.string(from: Date())
        
        currentTrip.saveTripToDefaults(key: myTripKey, trip: currentTrip)
        
        var tripIndexKey = "tripIndex"
        
        if let objectCheck : AnyObject? = defaults.object(forKey: tripIndexKey) as AnyObject?? {
            
            var tripIndexArray = defaults.object(forKey: tripIndexKey) as! [String]
            
            print(tripIndexArray)
            
            tripIndexArray.append(myTripKey)
            
            defaults.set(tripIndexArray, forKey: tripIndexKey)
        } else {
            var tripIndexArray : [String] = []
            tripIndexArray.append(myTripKey)
            
            defaults.set(tripIndexArray, forKey: tripIndexKey)
        }
        let alertController = UIAlertController(title: "Multi-Route", message:
            "Your trip has been saved to My Trips", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    

    
    override func viewDidLoad() {
        
        //self.tableView.allowsMultipleSelectionDuringEditing = true
        
        //Put code here that checks if there is a key sent in to access a new trip, otherwise assign "currentTrip" key
        // ELSE:
        if tripKey == "" {
            
            tripKey = currentTripKey
            print("Assigning Current Trip Key")

        }
        if let objectCheck : AnyObject? = defaults.object(forKey: tripKey) as AnyObject??  {
        } else {
            print("No Default Current Found")
            currentTrip.orientation = "Origin"
            currentTrip.orientationPoint = ""
            currentTrip.waypoints = [""]
            tableView.reloadData()
            currentTrip.saveTripToDefaults(key: tripKey, trip: currentTrip)
        }
        currentTrip = currentTrip.readTripFromDefaults(key: tripKey)
        //What I want to have happen: If there is no key sent in then just access currentTrip. Whatever is in the view when you exit, that is saved as "currentTrip", if a key is sent in to this view, use that to access the trip instead.

    }
    
    func saveTrip() {
        //Create SAVE TRIP button so that you don't get the popup every time
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        /*
        currentTrip.orientation = "origin"
        currentTrip.orientationPoint = "New York City"
        currentTrip.waypoints = ["Omaha", "New Orleans", "Salt Lake", "Jackson", "Tampa"]
        */
 
        //add code that presents popup that asks if you want to save this trip, and use current date as key

        writeCurrentTrip()
        currentTrip.saveTripToDefaults(key: currentTripKey, trip: currentTrip)
    }
    
    func writeCurrentTrip() {
        let orientationPointIndexPath = IndexPath(row: 0, section: 0)
        
        currentTrip.orientation = "origin"
        
        var orientationPointCell = tableView.cellForRow(at: orientationPointIndexPath) as! PlanTripCellTableViewCell
        currentTrip.orientation = orientationPointCell.mainLabel.text!
        currentTrip.orientationPoint = orientationPointCell.textInput.text!
        
        var numberOfRows = tableView.numberOfRows(inSection: 0)
        currentTrip.waypoints.removeAll()
        
        for i in 1...(numberOfRows-2) {
            var waypointIndex = IndexPath(row: i, section: 0)
            var waypointCell = tableView.cellForRow(at: waypointIndex) as! PlanTripCellTableViewCell
            var waypoint = waypointCell.textInput.text!
            currentTrip.waypoints.append(waypoint)
        }
        
        
        

    }

    

    
    // MARK: Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if self.currentTrip.waypoints.count == 0 {
            return 3
        } else {
            return (self.currentTrip.waypoints.count) + 2
        }
        
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       /* var cell = tableView.dequeueReusableCell(withIdentifier: "DestinationCell")! as! PlanTripCellTableViewCell  */
        
        
        
        if indexPath.row <= currentTrip.waypoints.endIndex {
            
        
            
            var cell = tableView.dequeueReusableCell(withIdentifier:"DestinationCell")! as! PlanTripCellTableViewCell
            
            
            // Set the name
            if indexPath.row == 0 {
                cell.mainLabel?.text = currentTrip.orientation
                cell.textInput?.text = currentTrip.orientationPoint
                cell.clearButton?.setTitle("Origin/Destination", for: UIControlState.normal)
                cell.clearButton?.addTarget(self, action: #selector(originDestinationSwitch), for: UIControlEvents.touchUpInside)
                
                
                
            } else if indexPath.row == 1 {
                cell.mainLabel?.text = "Stop"
                if currentTrip.waypoints == [] {
                    cell.textInput?.text = ""
                } else {
                    cell.textInput?.text = currentTrip.waypoints[indexPath.row - 1 ]
                    
                }
                cell.clearButton?.setTitle("", for: UIControlState.normal)
                //cell.clearButton?.addTarget(self, action: #selector(originDestinationSwitch), for: UIControlEvents.touchUpInside)
                cell.clearButton?.isEnabled = false
                
                
                
            } else{
                cell.mainLabel?.text = "Stop"
                if currentTrip.waypoints == [] {
                    cell.textInput?.text = ""
                } else {
                    cell.textInput?.text = currentTrip.waypoints[indexPath.row - 1 ]
                    cell.clearButton.tag = indexPath.row - 1
                    cell.clearButton.addTarget(self, action: #selector(removeWaypoint), for: UIControlEvents.touchUpInside)
                    
                }
                
            }
            return cell
        } else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "AddButtonCell") as! AddButtonCell
            cell.addButton.addTarget(self, action: #selector(addWaypoint), for: UIControlEvents.touchUpInside)
            
            return cell
            
        }
        
        
    }
    
    

    func originDestinationSwitch(sender: UIButton) {
        var indexPath = IndexPath(row: 0, section: 0)
        
        var cell = tableView.cellForRow(at: indexPath) as! PlanTripCellTableViewCell
        var orientationType = cell.mainLabel.text!
        if orientationType == "Origin" {
            cell.mainLabel.text = "Destination"
        } else {
            cell.mainLabel.text = "Origin"
        }
    }
    
    func addWaypoint() {
        if currentTrip.waypoints.count <= 21 {
        
            writeCurrentTrip()
            currentTrip.waypoints.append("")
            tableView.reloadData()
        } else {
            return
        }
    }
    
    func removeWaypoint(sender:UIButton) {
        writeCurrentTrip()
        
        var waypointIndex = sender.tag
        
        currentTrip.waypoints.remove(at: waypointIndex)
        
        tableView.reloadData()
    }
    
    func saveStop() {
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
    //private func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) {
        print("DidDeselect")
        var checkIndexPath = IndexPath(row: 0, section: 0)
        if indexPath == checkIndexPath {
            print("This was the origin row")
        } else {
            print("This was waypoint \(String(describing: indexPath))")
        }
        //Upon deselecting a row: 
        //if row number = 0, save editText field to currentTrip.origin.
        //else save editText field to currentTrip.waypoints[row number]
        
        //This replaces writeCurrentTrip, because all elements should be saved prior to needing to run that function
        
        //I will also need to change the tableView set up so that it checks the currentTrip for all the cell data and populates if there is something there and keeps it blank if there isn't
    }
    
}
