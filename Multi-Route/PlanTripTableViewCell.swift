//
//  PlanTripTableViewCell.swift
//  Multi-Route
//
//  Created by David Edwards on 11/7/16.
//  Copyright © 2016 David Edwards. All rights reserved.
//

import UIKit

class PlanTripTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var cellLabel: UILabel!
    
    @IBOutlet weak var cellButton: UIButton!
    
    @IBOutlet weak var cellTextInput: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
