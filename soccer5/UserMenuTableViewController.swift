//
//  SideMenuViewController.swift
//  soccer5
//
//  Created by Sebastian Misas on 5/2/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class UserMenuTableViewController: UITableViewController,SWRevealViewControllerDelegate {
    let userProfile = 0
    let ReserveField = 1
    let UpcomingGames = 2
    let Locations = 3
    let MessageCenter = 4
    let Notifications = 5
    let MyFriends = 6
    let MyProfile = 7
    
    let tableThemeColor = UIColor(red: 2/255, green: 167/255, blue: 77/255, alpha: 1.0)
    
    var userMenuList:[String] = ["Reserve A Field","Upcoming Games", "Locations","Message Center", "Notifications", "My Friends", "My Profile"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = tableThemeColor
        self.tableView.separatorStyle = .None
        self.revealViewController().rearViewRevealWidth = 285
        self.tableView.reloadData()
        self.revealViewController().panGestureRecognizer()
        self.revealViewController().tapGestureRecognizer()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.revealViewController().frontViewController.view.userInteractionEnabled = false
        self.revealViewController().frontViewController.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    override func viewWillDisappear(animated: Bool) {
        self.revealViewController().frontViewController.view.userInteractionEnabled = true
    }

    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userMenuList.count+1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == userProfile)
        {
            return 175
        }
        else
        {
            return 50
        }
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (indexPath.row == userProfile)
        {
            let cellIdentifier = "UserProfileTableViewCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UserProfileTableViewCell
            
            if isAFacbookUser() == true {
                if (((User().userFBProfileURL)) != nil){
                    Alamofire.request(.GET, NSURL(string:User().userFBProfileURL!)!)
                        .responseImage { response in
                            if let image = response.result.value {
                                cell.img_userProfile.image = image
                            }
                    }
                
                }
                else{
                    cell.img_userProfile.image = UIImage(named: "ProfilePicPlaceHolder")
                }
            
                if(User().userFBFullName?.characters.count > 14){
                    cell.lbl_userName.text = User().userFBFirstName!
                }else{
                
                    cell.lbl_userName.text = User().userFBFullName!
                }
                
            } else {
                cell.img_userProfile.image = UIImage(named: "ProfilePicPlaceHolder")
            }
            
            return cell
            
        }
        else
        {
            let cellIdentifier = "MenuListTableViewCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MenuListTableViewCell
            cell.lbl_title.text = userMenuList[indexPath.row-1]
            switch indexPath.row {
            case 1:
                cell.icon.image = UIImage(named: "icon-new-game")
            case 2:
                cell.icon.image = UIImage(named: "icon-games")
            case 3:
                cell.icon.image = UIImage(named: "icon-calendar")
            case 4:
                cell.icon.image = UIImage(named: "icon-message-sidebar")
            case 5:
                cell.icon.image = UIImage(named: "icon-notif-sidebar")
            case 6:
                cell.icon.image = UIImage(named: "icon-invite")
            case 7:
                cell.icon.image = UIImage(named: "icon-settings")
            default:
                break
            }
            
            return cell
        }
        
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if (indexPath.row != userProfile){
        
            // TODO Peform segues
            if (indexPath.row == ReserveField){
                let controller = storyboard!.instantiateViewControllerWithIdentifier("Main")
                let navCtrl = BaseNavigationController(rootViewController: controller)
                self.revealViewController().pushFrontViewController(navCtrl, animated: true)
            }
            else if(indexPath.row == UpcomingGames){
                let controller = storyboard!.instantiateViewControllerWithIdentifier("UpcomingGamesController")
                let navCtrl = GameNavigationController(rootViewController: controller)
                self.revealViewController().pushFrontViewController(navCtrl, animated: true)
                
            }
            else if(indexPath.row == Locations){
                let controller = storyboard!.instantiateViewControllerWithIdentifier("locationsController")
                let navCtrl = BaseNavigationController(rootViewController: controller)
                self.revealViewController().pushFrontViewController(navCtrl, animated: true)
                
            }
            else if(indexPath.row == MessageCenter){
                let controller = storyboard!.instantiateViewControllerWithIdentifier("messageCenter")
                let navCtrl = MessageCenterNavigationController(rootViewController: controller)
                self.revealViewController().pushFrontViewController(navCtrl, animated: true)
            }
            else if (indexPath.row == Notifications){
                let controller = storyboard!.instantiateViewControllerWithIdentifier("notificationController")
                let navCtrl = MessageCenterNavigationController(rootViewController: controller)
                self.revealViewController().pushFrontViewController(navCtrl, animated: true)
                
            }
            else if (indexPath.row == MyFriends)
            {
                var controllerIdentifier: String
                
                if #available(iOS 9.0, *)
                {
                    controllerIdentifier = "ContactsViewController"
                }
                else
                {
                    controllerIdentifier = "MyFriendsController"
                }
               
                let controller = storyboard!.instantiateViewControllerWithIdentifier(controllerIdentifier)
                let navCtrl = GameNavigationController(rootViewController: controller)
                self.revealViewController().pushFrontViewController(navCtrl, animated: true)
            }
            else if (indexPath.row == MyProfile){
                let controller = storyboard!.instantiateViewControllerWithIdentifier("ProfileViewNav")
                let navCtrl = BaseNavigationController(rootViewController: controller)
                self.revealViewController().pushFrontViewController(navCtrl, animated: true)
            }
            
        } else {
            let controller = storyboard!.instantiateViewControllerWithIdentifier("ProfileViewNav")
            let navCtrl = BaseNavigationController(rootViewController: controller)
            self.revealViewController().pushFrontViewController(navCtrl, animated: true)
        }
        
        
        
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
