//
//  SignUpViewController.swift
//  soccer5
//
//  Created by Sebastian Misas on 3/28/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    var faceBookID:String?
    var facebookToken:String?
    var facebookProfileUrl:String?
    var fullName:String = ""
    var email:String = ""


    @IBOutlet weak var phoneNumberInput: UITextField!
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
            
            // if first time loging in with facebook go to location settings else go to main page
            
            // setting info to user defaults
            // replace and call function below when api is built
            var ud = User()
            ud.userFBID = self.faceBookID
            ud.userFBFullName = self.fullName
            ud.userFBProfileURL = self.facebookProfileUrl
            ud.userEmail = self.email
            
            
            self.performSegueWithIdentifier("MainView", sender: self)
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
