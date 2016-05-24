//
//  UserDefault.swift
//  soccer5
//
//  Created by Sebastian Misas on 3/28/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import Foundation
struct User {

    let ud:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    var userFBID:String? {
        get {
            return ud.objectForKey("UserFBID") as? String
        } set {
            ud.setObject(newValue, forKey: "UserFBID")
        }
    }
    
    var userFBFullName:String? {
        get {
            return ud.objectForKey("UserFBName") as? String
        } set {
            ud.setObject(newValue, forKey: "UserFBName")
        }
    }
    
    var userFBFirstName:String? {
        get {
            return ud.objectForKey("UserFBFirstName") as? String
        } set {
            ud.setObject(newValue, forKey: "UserFBFirstName")
        }
    }
    
    var userEmail:String? {
        get {
            return ud.objectForKey("UserEmail") as? String
        } set {
            ud.setObject(newValue, forKey: "UserEmail")
        }
    }

    
    var userFBProfileURL:String? {
        get {
            return ud.objectForKey("UserFBProfileURL") as? String
        } set {
            ud.setObject(newValue, forKey: "UserFBProfileURL")
        }
    }
    
    var userFriendsList:[String]? {
        get {
            return ud.objectForKey("UserFriendsList") as? [String]
        } set {
            ud.setObject(newValue, forKey: "UserFriendsList")
        }
    }
    
    var selectedLocation:String? {
        get {
            return ud.objectForKey("selectedLocation") as? String
        } set {
            ud.setObject(newValue, forKey: "selectedLocation")
        }
    }
//    
//    var userPhone:String? {
//        get {
//            return  ud.objectForKey("UserPhone")
//        } set {
//            ud.setObject(newValue, forKey: "UserPhone")
//        }
//    }
//    
//    var userReservations:[Reservation]? {
//        get {
//            return  ud.objectForKey("UserReservations")
//        } set {
//            ud.setObject(newValue, forKey: "UserReservations")
//        }
//    }
//    var userInvitedGameReservations:[Reservation]? {
//        get {
//            return  ud.objectForKey("UserInvitedGameReservations")
//        } set {
//            ud.setObject(newValue, forKey: "UserInvitedGameReservations")
//        }
//    }
//    
    static func saveUserFriendsToUserDefaults() {
        FacebookLoginHelper.friendListOfUser() {
            friends in
            guard let friends = friends else {
                return
            }
            var arrayOfIds = [String]()
            for friend in friends {
                arrayOfIds.append(friend.fbID!)
            }
            var user = User()
            user.userFriendsList = arrayOfIds
        }
    }
    
    
    
}