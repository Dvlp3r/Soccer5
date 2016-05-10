//
//  PersonalInfoTableViewCell.swift
//  soccer5
//
//  Created by Sebastian Misas on 5/4/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import UIKit

class PersonalInfoTableViewCell: UITableViewCell {


    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
