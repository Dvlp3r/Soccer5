//
//  Location.swift
//  soccer5
//
//  Created by Sebastian Misas on 5/19/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import Foundation
import SwiftyJSON

//class Location: Equatable {
//    
//    let id: Int
//    let address: String
//    let name: String
//    let phone: String
//    let website: String
//    let fieldTypes: [String]
//    var reservations: [Reservation]
//    
//    init(json: JSON) throws {
//        guard let locationID = json["id"].int else{
//            print("could not find location id")
//        }
//        
//        id = locationID
//        address = json["address"].string ?? "no address"
//        name = json["name"].string ?? "no name"
//        phone = json["phone"].string ?? "no phone"
//        website = json["website"].string ?? "no website"
//    
////        for field in json["fieldTypes"] {
////            fieldTypes.append(field)
////            print("appended: \(field)")
////        }
////        
////        for reservation in json["reservations"] {
////            reservations.append(reservation)
////            print("appended: \(reservation)")
////        }
//    }
//    
//}
//
//func ==(lhs: Location, rhs: Location) -> Bool {
//    return lhs.id == rhs.id
//}