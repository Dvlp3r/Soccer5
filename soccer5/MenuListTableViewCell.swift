//
//  MenuListTableViewCell.swift
//  soccer5
//
//  Created by Sebastian Misas on 5/2/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import UIKit

class MenuListTableViewCell: UITableViewCell {

    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var icon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
