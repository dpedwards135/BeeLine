//
//  InviteFriendsVCViewController.swift
//  Multi-Route
//
//  Created by David Edwards on 10/19/16.
//  Copyright © 2016 David Edwards. All rights reserved.
//

import UIKit

class InviteFriendsVCViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func invite(_ sender: AnyObject) {
        
        let text = "Join me on MultiRoute"
        
        let controller = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        self.present(controller, animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
