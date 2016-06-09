//
//  FriendCell.swift
//  soccer5
//
//  Created by Jennifer Duffey on 6/8/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import UIKit
import Contacts


@available(iOS 9.0, *)
class FriendCell: UITableViewCell
{
    @IBOutlet var friendLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var checkImageView: UIImageView!
    
    //var isHidden: Bool = false
    
    var friend: Friend?
    {
        didSet
        {
            self.layoutView()
        }
    }
    
    func layoutView()
    {
        let contact = self.friend!.contactValue as CNContact
        
        let fullName = CNContactFormatter.stringFromContact(contact, style: .FullName)
        
        self.friendLabel.text = fullName //"\(self.friend!.firstName) \(self.friend!.lastName)"
        
        if self.friend?.profileImage != nil
        {
            self.iconImageView.image = self.friend?.profileImage
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    /*
    override func setSelected(selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }*/
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        
        self.friendLabel.text = ""
        self.iconImageView.image = UIImage(named: "ProfilePicPlaceHolder")
        self.accessoryType = UITableViewCellAccessoryType.None
    }

}
