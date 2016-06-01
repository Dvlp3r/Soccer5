//
//  LoginViewController.swift
//  soccer5
//
//  Created by Sebastian Misas on 3/28/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Firebase

class LoginViewController: UIViewController {
    var faceBookID:String?
    var facebookToken:String?
    var facebookProfileUrl:String?
    var fullName:String = ""
    var firstName: String = ""
    var email:String = ""
    var dealDict = [String: AnyObject]()
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBAction func dontHaveAnAccountBtn(sender: AnyObject) {
        performSegueWithIdentifier("toRegisterSegue", sender: self)
    }
    @IBAction func signInBtn(sender: AnyObject) {
    }
    @IBAction func loginWithFacebook(sender: AnyObject) {
        
        
        FacebookLoginHelper.login(self) {
            (status, response, token, id) -> Void in
            
            guard let resp = response where status else {
//                ErrorHandler.displayAlert("Facebook login failed!", message: "", okAction: nil)
                return
            }
            
            let json = JSON(resp)
            print(token)
            if let url = json["picture"]["data"]["url"].string {
                self.facebookProfileUrl = url
            }
            
            var firstName = String()
            if let name = json["first_name"].string {
                firstName = name
            }
            
            if let lastName = json["last_name"].string {
                firstName = "\(firstName) \(lastName)"
            }
            
            if let FBemail = json["email"].string {
                self.email = FBemail
                let dbRef = FIRDatabase.database().reference()
                dbRef.child("user").setValue([
                    "email": FBemail,
                    "name": firstName
                    ])
                
                dbRef

            }
            
            self.fullName = firstName
            self.faceBookID = id
            self.facebookToken = token
            self.firstName = firstName
            
            // if first time loging in with facebook go to location settings else go to main page
            
            // setting info to user defaults
            // replace and call function below when api is built
            var ud = User()
            ud.userFBID = self.faceBookID
            ud.userFBFullName = self.fullName
            ud.userFBFirstName = self.firstName
            ud.userFBProfileURL = self.facebookProfileUrl
            ud.userEmail = self.email
            
            self.performSegueWithIdentifier("MainView", sender: self)
            //            self.initiateRequestToServer()
        }
        
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}