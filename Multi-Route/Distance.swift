//
//  Distance.swift
//  Multi-Route
//
//  Created by David Edwards on 10/21/16.
//  Copyright © 2016 David Edwards. All rights reserved.
//

import Gloss

struct Distance: Decodable {
    
    
    let value: Int
    
    init?(json: JSON) {
        value = ("value" <~~ json)!
    }
    
}
