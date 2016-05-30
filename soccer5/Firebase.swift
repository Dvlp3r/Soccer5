//
//  Firebase.swift
//  soccer5
//
//  Created by Sebastian Misas on 5/30/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage

let firebase_url = FIRDatabase.database().reference()

class Firebase {
    var _base_ref = firebase_url
    var _chat_ref = firebase_url.child("Chat")
    var _Game_chat_ref = firebase_url.child("game_chat")
    
    var base_ref: FIRDatabaseReference {
        return _base_ref
    }
    var chat_ref: FIRDatabaseReference {
        return _chat_ref
    }
    
    func returnGameChat(game_id: String) -> FIRDatabaseReference {
        return _Game_chat_ref.child(game_id)
    }
    
    func returnDirectChat(friend_id: String) -> FIRDatabaseReference {
        return _chat_ref.child(User().userID!).child(friend_id)
    }
    
    var AllUsersDirectChats: FIRDatabaseReference {
        return _chat_ref.child(User().userID!)
    }
    
    var AllUsersGameChats: FIRDatabaseReference {
        return _chat_ref.child(User().userID!)
    }
    

    
    
}