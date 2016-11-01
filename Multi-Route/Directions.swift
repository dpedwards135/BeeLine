//
//  Directions.swift
//  Multi-Route
//
//  Created by David Edwards on 10/21/16.
//  Copyright © 2016 David Edwards. All rights reserved.
//

import Gloss

struct Directions: Decodable {
    
    let geocodedWaypoints: [GeocodedWaypoint]
    let routes: [Route]
    let status: String
    
    // MARK: - Deserialization
    
    init?(json: JSON) {
        self.geocodedWaypoints = ("geocoded_waypoints" <~~ json)!
        self.routes = ("routes" <~~ json)!
        self.status = ("status" <~~ json)!
        
        
    }
    
}
