//
//  Step.swift
//  Multi-Route
//
//  Created by David Edwards on 11/3/16.
//  Copyright © 2016 David Edwards. All rights reserved.
//

import UIKit

import Gloss

struct Step: Decodable {

        
        
        let polyline: Polyline

        
        init?(json: JSON) {
            polyline = ("polyline" <~~ json)!
      
        }
        
}

struct Polyline : Decodable {
    
    let points : String
    
    init?(json: JSON) {
        points = ("points" <~~ json)!
        
    }
}
