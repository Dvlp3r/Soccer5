//
//  MyFriendsTableViewCell.swift
//  soccer5
//
//  Created by Greg Salvesen on 5/24/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import UIKit

class MyFriendsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var check: UIImageView!
    @IBOutlet weak var label: UILabel!
    var isHidden: Bool!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isHidden = true
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}