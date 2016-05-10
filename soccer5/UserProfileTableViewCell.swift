//
//  UserProfileTableViewCell.swift
//  soccer5
//
//  Created by Sebastian Misas on 5/2/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import UIKit

class UserProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var img_userProfile: UIImageView!
    @IBOutlet weak var lbl_userName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        img_userProfile.layer.borderWidth = 2
        img_userProfile.layer.borderColor = UIColor.whiteColor().CGColor
        img_userProfile.layer.cornerRadius = 50
        img_userProfile.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
