//
//  NearbyPlaces.swift
//  Multi-Route
//
//  Created by David Edwards on 11/4/16.
//  Copyright © 2016 David Edwards. All rights reserved.
//

import Gloss

struct NearbyPlaces: Decodable {
    
    let results: [Result]

    
    // MARK: - Deserialization
    
    init?(json: JSON) {
        self.results = ("results" <~~ json)!

        
        
    }
    
}

struct Result: Decodable {
    
    let geometry : Geometry
    let name : String
    
    
    // MARK: - Deserialization
    
    init?(json: JSON) {
        self.geometry = ("geometry" <~~ json)!
        self.name = ("name" <~~ json)!
        
        
    }
    
}

struct Geometry: Decodable {
    
    let location : Location
    
    
    
    // MARK: - Deserialization
    
    init?(json: JSON) {
        self.location = ("location" <~~ json)!
    }
    
}

struct Location: Decodable {
    
    let lat : Double
    let long : Double
    
    
    // MARK: - Deserialization
    
    init?(json: JSON) {
        self.lat = ("lat" <~~ json)!
        self.long = ("lng" <~~ json)!
        
        
    }
    
}


 
