//
//  UserDefault.swift
//  soccer5
//
//  Created by Sebastian Misas on 3/28/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import Foundation
struct User {
    //UserDefault
    let ud:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    var userFBID:String? {
        get {
            return ud.objectForKey("kUserFBID") as? String
        } set {
            //Should be saved while user has successfully logged in through facebook SDK.
            //And logged verified from our server.
            ud.setObject(newValue, forKey: "kUserFBID")
        }
    }
    
    var userFBFullName:String? {
        get {
            return ud.objectForKey("kUserFBName") as? String
        } set {
            ud.setObject(newValue, forKey: "kUserFBName")
        }
    }
    
    var userFBFirstName:String? {
        get {
            return ud.objectForKey("kUserFBFirstName") as? String
        } set {
            ud.setObject(newValue, forKey: "kUserFBFirstName")
        }
    }
    
    var userEmail:String? {
        get {
            return ud.objectForKey("kUserEmail") as? String
        } set {
            ud.setObject(newValue, forKey: "kUserEmail")
        }
    }

    
    var userFBProfileURL:String? {
        get {
            return ud.objectForKey("kUserFBProfileURL") as? String
        } set {
            ud.setObject(newValue, forKey: "kUserFBProfileURL")
        }
    }
    
    var userFriendsList:[String]? {
        get {
            return ud.objectForKey("kUserFriendsList") as? [String]
        } set {
            ud.setObject(newValue, forKey: "kUserFriendsList")
        }
    }
    

    
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