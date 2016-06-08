//
//  EmbededProfileViewController.swift
//  soccer5
//
//  Created by Sebastian Misas on 5/5/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let password = 0
    let email = 1
    let card = 2
    let phoneNumber = 3
    let notifications = 4
    let logout = 5
    
    var picker = UIImagePickerController()
    var personalInfoArray = ["Password", "Email", "Card", "Phone Number"]
    var additionalArray = ["Notifications", "Logout"]
    var newPorfilePic:UIImage = UIImage()
    var ud = User()

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var PersonalTable: UITableView!
    @IBOutlet weak var AdditionalTable: UITableView!
    @IBAction func updatePictureBtn(sender: AnyObject) {
        picker.allowsEditing = false
        picker.sourceType = .PhotoLibrary
        presentViewController(picker, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        PersonalTable.delegate = self
        PersonalTable.dataSource = self
        AdditionalTable.dataSource = self
        AdditionalTable.delegate = self
        
        profilePic.layer.cornerRadius = 50
        profilePic.clipsToBounds = true
        
        // check if user is using facebook
        if isAFacbookUser() == true {
            if User().userFBID != nil {
                if (((User().userFBProfileURL)) != nil){
                    Alamofire.request(.GET, NSURL(string:User().userFBProfileURL!)!)
                        .responseImage { response in
                            if let image = response.result.value {
                                self.profilePic.image = image
                        }
                }
                
            }
            else{
                profilePic.image = UIImage(named: "ProfilePicPlaceHolder")
            }
            
                profileName.text = User().userFBFullName!
            }
        } else {
            profilePic.image = UIImage(named: "ProfilePicPlaceHolder")
        }
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        // TODO: save this image and update user settings
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        profilePic.image = chosenImage
    
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == PersonalTable {
            return personalInfoArray.count
        } else {
            return additionalArray.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if tableView == PersonalTable {
            let personalCell = tableView.dequeueReusableCellWithIdentifier("personalInfoCell", forIndexPath: indexPath) as! PersonalInfoTableViewCell
            switch indexPath.row {
                
            case 0:
                personalCell.icon.image = UIImage(named: "icon-password")
                personalCell.label.text = personalInfoArray[indexPath.row]
                
            case 1:
                personalCell.icon.image = UIImage(named: "icon-email")
                personalCell.label.text = personalInfoArray[indexPath.row]
                
            case 2:
                personalCell.icon.image = UIImage(named: "icon-card")
                personalCell.label.text = personalInfoArray[indexPath.row]
                
            case 3:
                personalCell.icon.image = UIImage(named: "icon-phone-number")
                personalCell.label.text = personalInfoArray[indexPath.row]
                
                
            default:
                break
            }
            return personalCell
            
        } else {
            
            let additionalCell = tableView.dequeueReusableCellWithIdentifier("additionalSettingsCell", forIndexPath: indexPath) as! AdditionalSettingsTableViewCell
            switch indexPath.row {
            case 0:
                additionalCell.icon.image = UIImage(named: "icon-notif-profile")
                additionalCell.label.text = additionalArray[indexPath.row]
            case 1:
                additionalCell.icon.hidden = true
                additionalCell.switchOutlet.hidden = true
                additionalCell.label.text = additionalArray[indexPath.row]
            default:
                break
            }
            
            return additionalCell
            
        }
        
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView == PersonalTable {
            return tableView.frame.height / 4.5
        } else {
            return tableView.frame.height / 2.5
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == PersonalTable {
            let personalCell = tableView.dequeueReusableCellWithIdentifier("personalInfoCell", forIndexPath: indexPath) as! PersonalInfoTableViewCell
            switch indexPath.row {
            
                
            default:
                break
            }
            
        } else {
            
            let additionalCell = tableView.dequeueReusableCellWithIdentifier("additionalSettingsCell", forIndexPath: indexPath) as! AdditionalSettingsTableViewCell
            switch indexPath.row {
  
                // logout
            case 1:
                WebService.send(.DELETE,
                    atURL: "\(BaseURL)/auth/sign_out",
                    headers: returnHeaders,
                    parameters: nil,
                    successBlock: { (response) in
                        guard let Resp = response else {
                            return
                        }
                        print(JSON(Resp))
                        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController")
                        let navCtrl = LoginNavigationController(rootViewController: controller)
                        self.revealViewController().pushFrontViewController(navCtrl, animated: true)

                        print("Logged out user with id: \(self.ud.userID!)")
                    },
                    failureBlock: { (message) in
                        print("\(message): Failed to logout user")
                                    
                })
            default:
                break
            }
            
        }
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
