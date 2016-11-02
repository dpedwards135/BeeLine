//
//  StartLocation.swift
//  Multi-Route
//
//  Created by David Edwards on 11/1/16.
//  Copyright © 2016 David Edwards. All rights reserved.
//

import UIKit

import Gloss

class StartLocation: Decodable {
    
    
    let startLat: Double
    let startLong: Double
    
    required init?(json: JSON) {
        startLat = ("lat" <~~ json)!
        startLong = ("lng" <~~ json)!
        
    }
    
}



