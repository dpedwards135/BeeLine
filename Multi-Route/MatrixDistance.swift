//
//  MatrixDistance.swift
//  Multi-Route
//
//  Created by David Edwards on 10/23/16.
//  Copyright © 2016 David Edwards. All rights reserved.
//

import UIKit
import Gloss


class MatrixDistance: Decodable {
    
    
    
    let rows: [Row]
    
    // MARK: - Deserialization
    
    required init?(json: JSON) {
        
        guard let rows: [Row] = "rows" <~~ json else {
            return nil
        }
        
        self.rows = rows
        
        
    }
    
}
