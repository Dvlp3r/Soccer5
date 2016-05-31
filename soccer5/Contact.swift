//
//  Contact.swift
//  soccer5
//
//  Created by Andrei Nechaev on 5/30/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

class Contact: Person {
    let id: Int
    let type: Type
    var name: String?
    
    init(dict: [String: AnyObject]) {
        id = dict["index"] as! Int
        type = Type.from(dict["type"] as! String)
    }
}
