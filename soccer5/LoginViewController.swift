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
    var ud = User()
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var facbookBtnOutlet: UIButton!
    @IBOutlet weak var confirmBtnOutlet: UIButton!
    @IBOutlet weak var signInLabel: UILabel!
    @IBOutlet weak var backBtnOutlet: UIButton!
    @IBOutlet weak var signInBtnOutlet: UIButton!
    @IBOutlet weak var phoneNumberTextField: VSTextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func dontHaveAnAccountBtn(sender: AnyObject) {
        performSegueWithIdentifier("toRegisterSegue", sender: self)
    }
    @IBAction func confirmSignIn(sender: AnyObject) {
        if self.passwordTextField.text == "" {
            ErrorHandler.displayAlert("You have not entered a password", message: "", okAction: nil)
        } else {
            self.spinner.hidden = false
            self.spinner.startAnimating()
            
            WebService.send(.POST,
            atURL: "\(BaseURL)/auth/sign_in",
            headers: nil,
            parameters: [
                "phone":"\(phoneNumberTextField.formattedString)",
                "password":"\(self.passwordTextField.text)"
            ],
            successBlock: { (response) in
                guard let Resp = response else {
                    return
                }
                let json = JSON(Resp)
                
                self.performSegueWithIdentifier("MainView", sender: self)

                
                self.ud.userID = String(json["data"]["id"])
                self.ud.userPhone = json["data"]["phone"].string
                print("logged in a user with id: \(self.ud.userID)")
            },
            failureBlock: { (message) in
                if message == "401" {
                    ErrorHandler.displayAlert("", message: "Invalid login credentials", okAction: nil)
                    self.spinner.stopAnimating()
                    self.spinner.hidden = true
                }
            })
        }
    }
    
    @IBAction func signInBtn(sender: AnyObject) {
        
        if self.phoneNumberTextField.text == "" {
            ErrorHandler.displayAlert("Please provide a phone number", message: "", okAction: nil)
            
        } else if self.phoneNumberTextField.text?.characters.count < 10{
            ErrorHandler.displayAlert("Please provide a full phone number", message: "", okAction: nil)
            
        } else {
            
            self.facbookBtnOutlet.hidden = true
            self.signInBtnOutlet.hidden = true
            self.phoneNumberTextField.hidden = true
            self.passwordTextField.hidden = false
            self.confirmBtnOutlet.hidden = false
            self.backBtnOutlet.hidden = false
            self.signInLabel.text = "Confirm"
        }
        
        
    }

    @IBAction func backBtn(sender: AnyObject) {
        self.facbookBtnOutlet.hidden = false
        self.signInBtnOutlet.hidden = false
        self.phoneNumberTextField.hidden = false
        self.passwordTextField.hidden = true
        self.confirmBtnOutlet.hidden = true
        self.backBtnOutlet.hidden = true
        self.signInLabel.text = "Sign in"
    }
    @IBAction func loginWithFacebook(sender: AnyObject) {

        
        FacebookLoginHelper.login(self) {
            (status, response, token, id) -> Void in
            
            guard let resp = response where status else {
//                ErrorHandler.displayAlert("Facebook login failed!", message: "", okAction: nil)
                return
            }
            
            let json = JSON(resp)

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
            self.ud.userFBID = self.faceBookID
            self.ud.userFBFullName = self.fullName
            self.ud.userFBFirstName = self.firstName
            self.ud.userFBProfileURL = self.facebookProfileUrl
            self.ud.userEmail = self.email
            self.spinner.hidden = false
            self.spinner.startAnimating()
            
            WebService.send(.POST,
                atURL: "\(BaseURL)/auth/sign_in",
                headers: nil,
                parameters: [
                "fb_id":"\(self.ud.userFBID!)",
                "access_token":"\(token!)"
                ],
                successBlock: { (response) in
                    guard let Resp = response else {
                        return
                    }
                    var json = JSON(Resp)
                    
                    
                    self.performSegueWithIdentifier("MainView", sender: self)
                    
                    self.ud.userID = String(json["data"]["id"])
                    print("logged in a user with id: \(self.ud.userID)")
                },
                failureBlock: { (message) in
                    if message == "401" {
                        WebService.send(.POST,
                            atURL: "\(BaseURL)/auth",
                            headers: nil,
                            parameters: [
                                "fb_id":"\(self.ud.userFBID!)",
                                "access_token":"\(token!)"
                            ],
                            successBlock: { (response) in
                                guard let Resp = response else {
                                    return
                                }
                                var json = JSON(Resp)
                                print(json)
                                
                                self.performSegueWithIdentifier("MainView", sender: self)

                                self.ud.userID = String(json["data"]["id"])
                                print("created a user with id: \(self.ud.userID)")
                            },
                            failureBlock: { (message) in
                                print("\(message): Failed to sign up with fb")
                            
                        })
                    }
            })
            
        }
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        spinner.stopAnimating()
        spinner.hidden = true

    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        phoneNumberTextField.setFormatting("###-###-####", replacementChar: "#")
        spinner.hidden = true
        // setting a default location for user 
        if ud.selectedLocation == nil {
            ud.selectedLocation = "Soccer 5 Kendall"
        }
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}