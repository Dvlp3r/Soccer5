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
            
            guard status else {
                print("Facebook login failed!")
                return
            }
            
            if let url = response?["picture"]?!["data"]?!["url"] {
                self.facebookProfileUrl = url as? String
            }
            
            var fullName = String()
            var firstName = String()
            
            if let name = response?["first_name"] {
                firstName = "\(name!)"
                fullName = "\(name!)"
            }
            
            if let lastName = response?["last_name"] {
                fullName = "\(fullName) \(lastName!)"
            }
            
            
            
            if let FBemail = response?["email"] {
                self.email = "\(FBemail)"
            }

            
            self.fullName = fullName
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
    
    override func viewDidAppear(animated: Bool) {
        //self.performSegueWithIdentifier("MainView", sender: self)
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}