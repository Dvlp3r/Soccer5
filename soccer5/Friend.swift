//
//  Friend.swift
//  soccer5
//
//  Created by Jennifer Duffey on 6/8/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import Contacts

struct Friend: Equatable
{
    let firstName: String
    let lastName: String
    var email: String?
    var phoneNumber: String?
    let profileImage: UIImage?
    var invited: Bool = false
    
    
    init(firstName: String, lastName: String, email: String, phoneNumber: String, profileImage: UIImage?, invited: Bool)
    {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
        self.profileImage = profileImage
        self.invited = invited
    }
}

func == (lhs: Friend, rhs: Friend) -> Bool
{
    return (lhs.firstName == rhs.firstName && lhs.lastName == rhs.lastName && lhs.email == rhs.email)
}

extension Friend
{
    
    @available(iOS 9.0, *)
    var contactValue: CNContact
    {
        let contact = CNMutableContact()
        contact.givenName = firstName
        contact.familyName = lastName
        
        if self.email != nil
        {
            contact.emailAddresses =
            [
                CNLabeledValue(label: CNLabelWork, value: self.email!)
            ]
        }
        
        if self.phoneNumber != nil
        {
            contact.phoneNumbers =
            [
                CNLabeledValue(label: CNLabelPhoneNumberiPhone, value: CNPhoneNumber.init(stringValue: self.phoneNumber!))
            ]
        }
        
        if self.profileImage != nil
        {
            let imageData = UIImageJPEGRepresentation(self.profileImage!, 1)
            contact.imageData = imageData
        }
        
        return contact.copy() as! CNContact
    }
    
    @available(iOS 9.0, *)
    init(contact: CNContact, invited: Bool)
    {
        self.firstName = contact.givenName
        self.lastName = contact.familyName
        
        for email in contact.emailAddresses
        {
            let emailAddress = email.value as! String
            
            if emailAddress.isEmpty == false
            {
                self.email = emailAddress
                break
            }
        }
        
        
     //   self.email = contact.emailAddresses.first?.value as! String
        
        for number in contact.phoneNumbers
        {
            let identifier = (number as CNLabeledValue).label
            
            if identifier == CNLabelPhoneNumberiPhone || identifier == CNLabelPhoneNumberMobile
            {
                let phoneNumber = (number as CNLabeledValue).value as! CNPhoneNumber
                
                self.phoneNumber = phoneNumber.stringValue
                break
            }
        }
        
        if let imageData = contact.imageData
        {
            self.profileImage = UIImage(data: imageData)
        }
        else
        {
            self.profileImage = nil
        }
        
        self.invited = invited
    }
}