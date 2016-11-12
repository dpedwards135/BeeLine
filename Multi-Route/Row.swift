//
//  Row.swift
//  Multi-Route
//
//  Created by David Edwards on 10/23/16.
//  Copyright © 2016 David Edwards. All rights reserved.
//

import UIKit
import Gloss


class Row: Decodable {
    
    
    
    let elements: [Element]
    
    // MARK: - Deserialization
    
    required init?(json: JSON) {
        
        guard let elements: [Element] = "elements" <~~ json else {
            return nil
        }
        
        self.elements = elements
        
        
    }
    
}
