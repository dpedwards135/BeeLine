//
//  EndLocation.swift
//  Multi-Route
//
//  Created by David Edwards on 11/2/16.
//  Copyright © 2016 David Edwards. All rights reserved.
//

import UIKit

import Gloss

class EndLocation: Decodable {
    
    
    let endLat: Double
    let endLong: Double
    
    required init?(json: JSON) {
        endLat = ("lat" <~~ json)!
        endLong = ("lng" <~~ json)!
        
    }
    
}

