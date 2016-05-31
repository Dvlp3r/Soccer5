//
//  Person.swift
//  soccer5
//
//  Created by Andrei Nechaev on 5/30/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

enum Type: String {
    case Facebook = "facebook"
    case Contact = "contacts"
    
    static func from(string: String) -> Type {
        if string == "facebook" {
            return Type.Facebook
        } else {
            return Type.Contact
        }
    }
}

protocol Person {
    var id: Int { get }
    var type: Type { get }
    var name: String? { get set }
}
