//
//  MenuViewController.swift
//  Multi-Route
//
//  Created by David Edwards on 10/19/16.
//  Copyright © 2016 David Edwards. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBAction func share(_ sender: AnyObject) {
        

        let text = "Have you tried Multi Route? It's the most efficient tool for trip planning!"
            
        let controller = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        self.present(controller, animated: true, completion: nil)
        print(text)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
