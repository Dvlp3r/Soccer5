//
//  MyFriendsViewController.swift
//  soccer5
//
//  Created by Greg Salvesen on 5/20/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import UIKit
import AddressBook

class MyFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    let addressBookRef: ABAddressBook = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
    var allContacts: NSArray!
    var allFriends: NSArray!
    @IBOutlet weak var contactsTableView: UITableView!
    @IBOutlet weak var friendsTableView: UITableView!
    @IBOutlet weak var inviteView: UIView!
    var indexInfo = [[String:AnyObject]]()
    var contactCells: NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        contactsTableView.hidden = true
        
        let inviteTapGesture = UITapGestureRecognizer(target: self, action: #selector(MyFriendsViewController.invitePeople))
        inviteView.addGestureRecognizer(inviteTapGesture)
        
        let authorizationStatus = ABAddressBookGetAuthorizationStatus()
        
        switch authorizationStatus {
        case .Denied, .Restricted:
            displayCantAddContactAlert()
        case .Authorized:
            pullContactInfo()
        case .NotDetermined:
            promptForAddressBookRequestAccess()
        }
        
        FacebookLoginHelper.friendListOfUser({
            friends in
            guard friends != nil else {
                return
            }
            self.allFriends = friends
            self.setUpIndexes()
            self.contactsTableView.reloadData()
            
        })
    }
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            contactsTableView.hidden = true
            friendsTableView.hidden = false
            break
        case 1:
            contactsTableView.hidden = false
            friendsTableView.hidden = true
            break
        default:
            break
        }
    }
    
    func setUpIndexes() {
        if(allContacts == nil && allFriends == nil) {
            return
        }
        var curFriendIdx = 0
        var curContactIdx = 0
        while(curFriendIdx < allFriends.count || curContactIdx < allContacts.count) {
            var curDict = [String: AnyObject]()
            if(allContacts == nil || curContactIdx >= allContacts.count) {
                curDict["index"] = curFriendIdx
                curDict["type"] = "facebook"
                curFriendIdx += 1
            } else if(allFriends == nil || curFriendIdx >= allFriends.count) {
                curDict["index"] = curContactIdx
                curDict["type"] = "contact"
                curContactIdx += 1
            } else {
                let curFriend = allFriends.objectAtIndex(curFriendIdx) as! FacebookFriend
                let curFriendName = curFriend.name
                let curContact = allContacts.objectAtIndex(curContactIdx)
                let curContactName = ABRecordCopyCompositeName(curContact).takeRetainedValue() as String
                
                if(curFriendName > curContactName) {
                    curDict["index"] = curContactIdx
                    curDict["type"] = "contact"
                    curContactIdx += 1
                } else {
                    curDict["index"] = curFriendIdx
                    curDict["type"] = "facebook"
                    curFriendIdx += 1
                }
            }
            
            curDict["shouldInvite"] = false
            indexInfo.append(curDict)
        }
    }
    
    func pullContactInfo() {
        let source: ABRecord = ABAddressBookCopyDefaultSource(addressBookRef).takeRetainedValue()
        
        allContacts = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBookRef, source, ABPersonSortOrdering(kABPersonSortByFirstName)).takeRetainedValue()
        
        
    }
    
    func invitePeople() {
        var contactsArr = [[String: AnyObject]]()
        for contact in indexInfo {
            if contact["shouldInvite"] as! Bool == true {
                var contactInfo = [String: AnyObject]()
                let type = contact["type"] as! String
                let index = contact["index"] as! Int
                
                if type == "facebook"  {
                    let curFriend = allFriends.objectAtIndex(index) as! FacebookFriend
                    let curFriendName = curFriend.name!
                    contactInfo["contact"] = curFriendName
                    contactInfo["type"] = "facebook"
                } else if type == "contact" {
                    let curContact = allContacts.objectAtIndex(index)
                    let curContactName = ABRecordCopyCompositeName(curContact).takeRetainedValue()
                    contactInfo["contact"] = curContactName
                    contactInfo["type"] = "contact"
                }
                contactsArr.append(contactInfo)
            }
        }
        let defaults = NSUserDefaults.standardUserDefaults()
        
        guard var curContacts = defaults.arrayForKey("friends") else {
            defaults.setValue(contactsArr, forKey: "friends")
            defaults.synchronize()
            return
        }
        
        for newContact in contactsArr {
            let newName = newContact["contact"] as! String
            var exists = false
            
            for oldContact in curContacts {
                let oldName = oldContact.objectForKey("contact") as! String
                if(newName == oldName) {
                    exists = true
                    break
                }
            }
            if(exists != true) {
                curContacts.append(newContact)
            }
        }
        print(curContacts)
        defaults.setObject(curContacts, forKey: "friends")
        defaults.synchronize()
    }
    
    func promptForAddressBookRequestAccess() {
        ABAddressBookRequestAccessWithCompletion(addressBookRef) {
            (granted: Bool, error: CFError!) in
            dispatch_async(dispatch_get_main_queue()) {
                if !granted {
                    self.displayCantAddContactAlert()
                } else {
                    print("Just authorized")
                }
            }
        }
    }
    
    func displayCantAddContactAlert() {
        let cantAddContactAlert = UIAlertController(title: "Cannot fetch contacts",
                                                    message: "You must give the app permission to access your contacts first.",
                                                    preferredStyle: .Alert)
        cantAddContactAlert.addAction(UIAlertAction(title: "Change Settings",
            style: .Default,
            handler: { action in
                self.openSettings()
        }))
        cantAddContactAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        presentViewController(cantAddContactAlert, animated: true, completion: nil)
    }
    
    func openSettings() {
        let url = NSURL(string: UIApplicationOpenSettingsURLString)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == contactsTableView) {
            var total = 0
            if(allContacts != nil){
                total += allContacts.count
            }
            if(allFriends != nil) {
                total += allFriends.count
            }
            return total
        } else if(tableView == friendsTableView) {
            let defaults = NSUserDefaults.standardUserDefaults()
            guard let friends = defaults.objectForKey("friends") as? NSArray else {
                return 0
            }
            return friends.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let contactCell: MyFriendsTableViewCell = tableView.dequeueReusableCellWithIdentifier("contactCell", forIndexPath: indexPath) as! MyFriendsTableViewCell
        
        if(tableView == contactsTableView) {
            if(indexInfo.count != 0) {
                let curDict = indexInfo[indexPath.row]
                
                let index = curDict["index"] as! Int
                let type = curDict["type"] as! String
                let hidden = !(curDict["shouldInvite"] as! Bool)
                
                let frame = CGRect(x: 15, y: 5, width: contactCell.frame.size.height - 10, height: contactCell.frame.size.height - 10)
                
                let imageView = UIImageView(frame: frame)
                contactCell.check.hidden = hidden
                if(type == "contact") {
                    let curContact = allContacts.objectAtIndex(index)
                    let curContactName = ABRecordCopyCompositeName(curContact).takeRetainedValue() as String
                    let image =  ABPersonCopyImageDataWithFormat(curContact, kABPersonImageFormatThumbnail)
                    if(image != nil) {
                        contactCell.icon.image = UIImage(data: image.takeRetainedValue())
                        contactCell.icon.layer.cornerRadius = contactCell.icon.frame.size.width / 2
                        contactCell.icon.clipsToBounds = true
                    } else {
                        contactCell.icon.image = UIImage(named: "ProfilePicPlaceHolder")
                    }
                    contactCell.contentView.addSubview(imageView)
                    contactCell.label.text = curContactName
                } else if(type == "facebook") {
                    let curFriend = allFriends.objectAtIndex(index) as! FacebookFriend
                    let curFriendName = curFriend.name
                    if(curFriend.picture != nil) {
                        contactCell.icon.image = curFriend.picture
                        contactCell.icon.layer.cornerRadius = contactCell.icon.frame.size.width / 2
                        contactCell.icon.clipsToBounds = true
                    } else {
                        contactCell.icon.image = UIImage(named: "ProfilePicPlaceHolder")
                    }
                    contactCell.contentView.addSubview(imageView)
                    contactCell.label.text = curFriendName
                }
                
                contactCell.label.textColor = UIColor.whiteColor()
            }
        } else if(tableView == friendsTableView) {
            let defaults = NSUserDefaults.standardUserDefaults()
            guard let friends = defaults.objectForKey("friends") as? NSArray else {
                return contactCell
            }
            print(friends)
            let curFriend = friends.objectAtIndex(indexPath.row) as! NSMutableDictionary
            contactCell.label.text = curFriend["contact"] as? String
            contactCell.icon.image = UIImage(named: "ProfilePicPlaceHolder")
        }
        
        return contactCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var curInfo = indexInfo[indexPath.row]
        let shouldInvite = !(curInfo["shouldInvite"] as! Bool)
        
        let curCell = tableView.cellForRowAtIndexPath(indexPath) as! MyFriendsTableViewCell
        curCell.check.hidden = !shouldInvite
        curInfo["shouldInvite"] = shouldInvite
        
        indexInfo[indexPath.row] = curInfo
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