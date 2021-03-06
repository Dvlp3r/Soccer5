//
//  FacebookLoginHelper.swift
//  soccer5
//
//  Created by Sebastian Misas on 3/28/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import Firebase
import FirebaseAuth
import Foundation

class FacebookLoginHelper {
    // Response will return Dictionary of User profile.
    // Token is facbook Token string
    // id is unique fbID for the user
    class func login(controller:UIViewController, successBlock:(status:Bool,response:AnyObject?, token:String?, id:String?) -> Void) {
        
        
        let loginManager = FBSDKLoginManager()
        loginManager.logInWithReadPermissions(["public_profile","email","user_friends"], fromViewController: controller) {
            (result,error ) -> Void in
            if (error != nil) {
                successBlock(status: false, response: nil, token: nil,id: nil )
                return
            }
            
            if result.isCancelled {
                successBlock(status: false, response: nil , token: nil,id: nil)
            } else {
                
                let tokenString = result.token.tokenString
                let credentials = FIRFacebookAuthProvider.credentialWithAccessToken(tokenString)
                FIRAuth.auth()?.signInWithCredential(credentials, completion: { (user, error) in
                    if let user = user {
                        print(user)
                    } else {
                        print(error)
                    }
                })
                
                FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,first_name,last_name,picture.width(1000).height(1000),birthday,gender"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                    if error != nil {
                        successBlock(status: false, response: nil, token: nil,id: nil)
                        
                    } else {
                        // id , name
                        successBlock(status: true, response: result, token: tokenString ,id: result["id"] as? String)
                        
                    }
                    
                })
            }
        }
    }
    
    class func friendListOfUser(completionHandler:([FacebookFriend]?) -> ()) {
        
        FBSDKGraphRequest(graphPath: "me",
            parameters: ["fields":"friends"]).startWithCompletionHandler(
                {
                    (connection, result, error) -> Void in
                    if error == nil {
                        let friendsData = result["friends"]?["data"] as? NSArray
                        guard let friendsArray = friendsData else  {
                            return
                        }
                        var arrayOfFriends = [FacebookFriend]()
                        for friendDictionary in friendsArray {
                            let friend = FacebookFriend()
                            friend.fbID = friendDictionary["id"] as? String
                            friend.name = friendDictionary["name"] as? String
                            arrayOfFriends.append(friend)
                        }
                        completionHandler(arrayOfFriends)
                        
                    } else {
                        completionHandler(nil)
                        print("Error Getting Friends \(error)");
                        
                    }
            })
        
    }
}