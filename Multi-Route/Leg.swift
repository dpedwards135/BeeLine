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
    
    init?(json: JSON) {
        distance = ("distance" <~~ json)!
    }
    
}
