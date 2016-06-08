//
//  SignUpViewController.swift
//  soccer5
//
//  Created by Sebastian Misas on 3/28/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import UIKit
import SwiftyJSON

class RegisterViewController: UIViewController {
    var faceBookID:String?
    var facebookToken:String?
    var facebookProfileUrl:String?
    var fullName:String = ""
    var email:String = ""
    var ud = User()


    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var phoneNumberInput: VSTextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var nameInput: UITextField!
    
    @IBAction func alreadyHasAccBtn(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func backBtn(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func signInWithFBBtn(sender: AnyObject) {
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
            
            self.ud.userFBID = self.faceBookID
            self.ud.userFBFullName = self.fullName
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
                                
                    self.performSegueWithIdentifier("ToMainFromRegister", sender: self)
                                
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
                                            
                            self.performSegueWithIdentifier("ToMainFromRegister", sender: self)
                                            
                            self.ud.userID = String(json["data"]["id"])
                            print("created a user with id: \(self.ud.userID)")
                        },
                        failureBlock: { (message) in
                            print("Failed to sign up with fb")
                                            
                        })
                    }
            })

        }
    }
    @IBAction func registerBtn(sender: AnyObject) {
        if phoneNumberInput.text == "" || passwordInput.text == "" || nameInput.text == "" {
            ErrorHandler.displayAlert("One of the fields is blank", message: "", okAction: nil)
        
        } else {
            self.spinner.hidden = false
            self.spinner.startAnimating()
            
            WebService.send(.POST,
            atURL: "\(BaseURL)/auth",
            headers: nil,
            parameters: [
                "phone":"\(phoneNumberInput.formattedString)",
                "password":"\(passwordInput.text)",
                "password_confirmation":"\(passwordInput.text)",
                "name":"\(nameInput.text)"
            ],
            successBlock: { (response) in
                guard let Resp = response else {
                    return
                }
                let json = JSON(Resp)
                            
                self.performSegueWithIdentifier("ToMainFromRegister", sender: self)
                self.ud.userID = String(json["data"]["id"])
                self.ud.userPhone = json["data"]["phone"].string
                
                print("created a user with id: \(self.ud.userID)")
                            
            },
            failureBlock: { (message) in
                print(message)
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
        phoneNumberInput.setFormatting("###-###-####", replacementChar: "#")
        spinner.hidden = true
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
