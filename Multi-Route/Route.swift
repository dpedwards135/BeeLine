//
//  Route.swift
//  Multi-Route
//
//  Created by David Edwards on 10/21/16.
//  Copyright © 2016 David Edwards. All rights reserved.
//

import UIKit
import Gloss

struct Route: Decodable {

        
    let legs: [Leg]
    let waypointOrder : [Int]
        
    
    init?(json: JSON) {
            legs = ("legs" <~~ json)!
            waypointOrder = ("waypoint_order" <~~ json)!
        }
    

}

