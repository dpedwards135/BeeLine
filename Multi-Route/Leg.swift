//
//  Leg.swift
//  Multi-Route
//
//  Created by David Edwards on 10/21/16.
//  Copyright © 2016 David Edwards. All rights reserved.
//

import Gloss

struct Leg: Decodable {
    
    
    let distance: Distance
    let startLocation : StartLocation
    let endLocation : EndLocation
    
    init?(json: JSON) {
        distance = ("distance" <~~ json)!
        startLocation = ("start_location" <~~ json)!
        endLocation = ("end_location" <~~ json)!
    }
    
}
