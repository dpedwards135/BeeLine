//
//  PlaceID.swift
//  Multi-Route
//
//  Created by David Edwards on 11/1/16.
//  Copyright © 2016 David Edwards. All rights reserved.
//

import UIKit
import Gloss

struct GeocodedWaypoint: Decodable {
    
    
    let placeID : String
    
    
    init?(json: JSON) {
        placeID = ("place_id" <~~ json)!
    }
    
    
}
