//
//  Element.swift
//  Multi-Route
//
//  Created by David Edwards on 10/23/16.
//  Copyright © 2016 David Edwards. All rights reserved.
//

import UIKit
import Gloss

class Element: Decodable {
    
    let distance: Distance
    let status : String
    
    // MARK: - Deserialization
    
    required init?(json: JSON) {
        
        guard let distance: Distance = "distance" <~~ json else {
            return nil
        }
        self.status = ("status" <~~ json)!
        
        self.distance = distance
        
        
        
    }
    
}

