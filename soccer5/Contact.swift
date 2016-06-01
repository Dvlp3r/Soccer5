//
//  Contact.swift
//  soccer5
//
//  Created by Andrei Nechaev on 5/30/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//
import AddressBook

class Contact {
    let id: String
    let type: Type
    let name: String
    let image: UIImage
    var invited: Bool
    
    init(fb: FacebookFriend, invited: Bool) {
        id = fb.fbID!
        name = fb.name!
        type = .Facebook
        image = fb.picture ?? UIImage(named: "ProfilePicPlaceHolder")!
        self.invited = invited
    }
    
    init(ab: AnyObject, invited: Bool) {
        id = "\(arc4random())"
        name = ABRecordCopyCompositeName(ab).takeRetainedValue() as String
        type = .Contact
        
        if let picture =  ABPersonCopyImageDataWithFormat(ab, kABPersonImageFormatThumbnail) {
            image = UIImage(data: picture.takeRetainedValue())!
        } else {
            image = UIImage(named: "ProfilePicPlaceHolder")!
        }
        
        self.invited = invited
    }
    
    init(dict: [String: AnyObject], invited: Bool) {
        id = dict["id"] as! String
        name = dict["name"] as! String
        type = Type.from(dict["type"] as! String)
        image = UIImage(data: dict["image"] as! NSData)!
        self.invited = invited
    }
    
    func toDictionary() -> [String: AnyObject] {
        let tmpDir = NSTemporaryDirectory() + "/\(type.rawValue)/\(name)/ava.png"
        let data = UIImagePNGRepresentation(image)!
        NSFileManager.defaultManager().createFileAtPath(tmpDir, contents: data, attributes: nil)
        return [
            "id": id,
            "name": name,
            "type": type.rawValue,
            "image": tmpDir
        ]
    }
}
