//
//  DropdownCell.swift
//  Yelp
//
//  Created by Olya Sorokina on 10/24/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class DropdownCell: UITableViewCell {

    @IBOutlet weak var dropdownLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
