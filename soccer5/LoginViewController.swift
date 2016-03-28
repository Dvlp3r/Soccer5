//
//  LoginViewController.swift
//  soccer5
//
//  Created by Sebastian Misas on 3/28/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    var faceBookID:String?
    var facebookToken:String?
    var facebookProfileUrl:String?
    var fullName:String = ""
    var email:String = ""

    
    @IBAction func loginWithFacebook(sender: AnyObject) {
        
        
        FacebookLoginHelper.login(self) {
            (status, response, token, id) -> Void in
            
            guard status else {
                print("Facebook login failed!")
                return
            }
            
            if let url = response?["picture"]?["data"]?["url"] {
                self.facebookProfileUrl = url as? String
            }
            
            var fullName = String()
            if let name = response?["first_name"] {
                fullName = "\(name)"
            }
            
            if let lastName = response?["last_name"] {
                fullName = "\(fullName) \(lastName)"
            }
            
            if let FBemail = response?["email"] {
                self.email = "\(FBemail)"
            }

            
            self.fullName = fullName
            self.faceBookID = id
            self.facebookToken = token
            
            // if first time loging in with facebook go to location settings else go to main page
            
            // setting info to user defaults
            // replace and call function below when api is built
            var ud = User()
            ud.userFBID = self.faceBookID
            ud.userFBFullName = self.fullName
            ud.userFBProfileURL = self.facebookProfileUrl
            ud.userEmail = self.email

            
            self.performSegueWithIdentifier("MainView", sender: self)
            //            self.initiateRequestToServer()
        }
        
    }
    // UPDATE WHEN API IS READY
    // -------------------------------------------------------------------------------------------------------
    //    func initiateRequestToServer() {
    //        self.getSignLoginAPIParameter {
    //            (parameter) -> Void in
    //
    //            WebService.postAt(APIFbLogin,
    //                parameters: parameter,
    //                successBlock: {
    //                    (response) -> Void in
    //                    self.indicator.stop()
    //
    //                    //Save facebookID in userdefaults as we need to use this id as parameter in next request.
    //                    var ud = User()
    //                    ud.userFBID = self.faceBookID
    //                    ud.userFBFullName = self.fullName
    //                    ud.userFBProfileURL = self.facebookProfileUrl
    //
    //                    guard let response = response as! [String: AnyObject]? else {
    //                        return
    //                    }
    //
    //                    guard let status = response["success"] as? Bool else {
    //                        return
    //
    //                    }
    //
    //                    if status {
    //                        //IF user location has been extracted to to home view
    //                        //ELSE show location needed controller
    //                        if let _ = self.userLocation {
    //                            self.performSegueWithIdentifier("LoginSegue", sender: nil)
    //
    //                        } else {
    //                            let controller = self.storyboard?.instantiateViewControllerWithIdentifier("NoLocationViewController")
    //                            self.showViewController(controller!, sender: nil)
    //                        }
    //
    //                    }
    //
    //                }, failureBlock: {
    //                    (message) -> Void in
    //                    self.indicator.stop()
    //            })
    //        }
    //    }
    override func viewDidLoad() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:Selector("navigateToLocation"), name:"LoginSuccessfull", object:nil)
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}