//
//  PlanTripVC.swift
//  Multi-Route
//
//  Created by David Edwards on 11/7/16.
//  Copyright © 2016 David Edwards. All rights reserved.
//

import UIKit

class PlanTripVC: UITableViewController, UITextFieldDelegate {
    
    var currentTrip = Trip(orientation: "", orientationPoint: "", waypoints: ["", ""])
    var tripKey = ""
    var rowSelected = 0

    
    
    @IBAction func submitTrip(_ sender: AnyObject) {
        
        for waypoint in currentTrip.waypoints {
            if waypoint.characters.count < 2 {
                let alertController = UIAlertController(title: "Multi-Route", message:
                    "Please fill or clear all inputs", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
                return
            }
        }
        
        if !Reachability.isConnectedToNetwork() {
            let alertController = UIAlertController(title: "Multi-Route", message:
                "No internet connection", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        currentTrip.saveTripToDefaults(key: tripKey, trip: currentTrip)
        let analyzedTrip = AnalyzedTrip(currentTrip: currentTrip, viewControllerSender: self)
    }
    
    
    
    @IBAction func saveToMyTrips(_ sender: AnyObject) {
        print("Saving Trip")
        
        let defaults = UserDefaults.standard
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
   
    @IBAction func addWaypoint(_ sender: AnyObject) {
        
            if currentTrip.waypoints.count <= 21 {
                
              
                currentTrip.waypoints.append("")
                tableView.reloadData()
            } else {
                return
            }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if tripKey == "" {
            
            tripKey = "currentTrip"
            
        }
        let defaults = UserDefaults.standard
        if let objectCheck : AnyObject? = defaults.object(forKey: tripKey) as AnyObject??  {
            currentTrip = currentTrip.readTripFromDefaults(key: tripKey)
        } else {
            print("No Default Current Found")
            currentTrip.orientation = "Origin"
            currentTrip.orientationPoint = ""
            currentTrip.waypoints = [""]
            //tableView.reloadData()
            //currentTrip.saveTripToDefaults(key: tripKey, trip: currentTrip)
        }
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        print(currentTrip.waypoints.count)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var numberOfRows : Int?
        if currentTrip.waypoints.count < 2 {
            numberOfRows = 3
        } else {
            numberOfRows = currentTrip.waypoints.count + 2
        }
        return numberOfRows!
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //var cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell", for: indexPath) as! PlanTripTableViewCell
        
        if indexPath.row == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell", for: indexPath) as! PlanTripTableViewCell
            cell.cellLabel.text = currentTrip.orientation
            cell.cellTextInput.text = currentTrip.orientationPoint
            cell.cellTextInput.tag = indexPath.row
            cell.cellTextInput.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
            cell.cellButton.setTitle("Origin/Destination", for: UIControlState.normal)
            cell.cellButton.addTarget(self, action: #selector(self.originDestinationSwitch), for: UIControlEvents.touchUpInside)
            
            return cell
        } else if indexPath.row <= currentTrip.waypoints.count{
            var cell = tableView.dequeueReusableCell(withIdentifier: "reuseCell", for: indexPath) as! PlanTripTableViewCell
            var tag = indexPath.row-1
                
            cell.cellTextInput.text = currentTrip.waypoints[tag]
            cell.cellTextInput.tag = indexPath.row
            cell.cellTextInput.addTarget(self, action: #selector(didChangeText), for: .editingChanged)
            
            cell.cellLabel.text = "Stop"
            cell.cellButton.setTitle("Clear", for: UIControlState.normal)
            cell.cellButton.addTarget(self, action: #selector(self.removeWaypoint), for: UIControlEvents.touchUpInside)
            cell.cellButton.tag = tag
            return cell
            
        } else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "AddButtonCell") as! AddButtonCell
            cell.addButton.addTarget(self, action: #selector(addWaypoint), for: UIControlEvents.touchUpInside)
            
            return cell
            
        }
        
       
        
    }
    
 
    
    //Use this function to save everything as it is typed
    func didChangeText(sender: Any) {
        print("Changed Text, Row Selected:")
        print(rowSelected)
        print("Number of Waypoints:")
        print(currentTrip.waypoints.count)
        for waypoint in currentTrip.waypoints {
            print(waypoint)
        }
        var indexPath = IndexPath(row: rowSelected, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! PlanTripTableViewCell
        
        let rowNumber = indexPath.row
        
        if rowNumber == 0 {
            currentTrip.orientationPoint = cell.cellTextInput.text!
        } else {
            currentTrip.waypoints[rowNumber-1] = cell.cellTextInput.text!
        }
        
        //print(cell.cellTextInput.text!)
        
        
    }
    /*
    func stopEditing(sender : Any) {
        
        let indexPath = IndexPath(row: rowSelected, section: 0)
        saveRowInfo(indexPath: indexPath)
        print("Stop Editing")
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("Did end displaying function")
        
        if cell is PlanTripTableViewCell {
            var cell = cell as! PlanTripTableViewCell
            cell.cellTextInput.resignFirstResponder()
            
            print("Does this print the cell's text?")
            var text = cell.cellTextInput.text
            print(text)
            
            if indexPath.row == 0 {
                currentTrip.orientationPoint = text!
            } else {
                currentTrip.waypoints[indexPath.row - 1] = text!
            }
            
            
            
            //saveRowInfo(indexPath: indexPath)
            print("Saving Row Info")
        } else {
            return
        }
        
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


    func textFieldDidBeginEditing(_ textField: UITextField) {
        //print("Start Editing")
        rowSelected = textField.tag
        let selectedIndexPath = IndexPath(row: rowSelected, section: 0)
        tableView.selectRow(at: selectedIndexPath, animated: false, scrollPosition: UITableViewScrollPosition.middle)
    }
    
    /*
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if rowSelected != nil {
      
            let selectedIndexPath = IndexPath(row: rowSelected, section: 0)
            saveRowInfo(indexPath: selectedIndexPath)
        }
        
    }
 
    
    func saveRowInfo(indexPath : IndexPath) {
        print("Check 1")
        let cell = tableView.cellForRow(at: indexPath) as! PlanTripTableViewCell
        
        print("Check 2")
        let rowNumber = indexPath.row
        
        if rowNumber == 0 {
            currentTrip.orientationPoint = cell.cellTextInput.text!
        } else {
            currentTrip.waypoints[rowNumber-1] = cell.cellTextInput.text!
        }
        
        print(cell.cellTextInput.text!)
    
    }
*/
    func originDestinationSwitch(sender: UIButton) {
        var indexPath = IndexPath(row: 0, section: 0)
        
        var cell = tableView.cellForRow(at: indexPath) as! PlanTripTableViewCell
        var orientationType = cell.cellLabel.text!
        if orientationType == "Origin" {
            cell.cellLabel.text = "Destination"
            currentTrip.orientation = "Destination"
        } else {
            cell.cellLabel.text = "Origin"
            currentTrip.orientation = "Origin"
        }
    }
    
    func removeWaypoint(sender:UIButton) {
        
        var waypointIndex = sender.tag
        
        currentTrip.waypoints.remove(at: waypointIndex)
        
        tableView.reloadData()
    }

}
