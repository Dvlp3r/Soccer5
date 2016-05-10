//
//  ProfileViewController.swift
//  soccer5
//
//  Created by Sebastian Misas on 5/4/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage


class ProfileViewController: UITableViewController {
    let password = 0
    let email = 1
    let card = 2
    let phoneNumber = 3
    let notifications = 4
    let logout = 5
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var profileName: UILabel!

    var personalInfoArray = ["Password", "Email", "Card", "Phone Number"]
    var additionalArray = ["Notifications", "Logout"]
    override func viewDidLoad() {
        super.viewDidLoad()
        

        profilePic.layer.cornerRadius = 50
        profilePic.clipsToBounds = true
        
        // check if user is using facebook
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
        
        // Do any additional setup after loading the view.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return personalInfoArray.count
        } else {
            return additionalArray.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        
        if indexPath.section == 1 {
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
            
            return additionalCell
          
        }
        
    
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
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
