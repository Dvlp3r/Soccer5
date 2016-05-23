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
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    let addressBookRef: ABAddressBook = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
    var allContacts: NSArray!
    var allFriends: NSArray!
    @IBOutlet weak var contactsTableView: UITableView!
    var indexInfo: NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        let authorizationStatus = ABAddressBookGetAuthorizationStatus()
        indexInfo = NSMutableArray()
        
        switch authorizationStatus {
        case .Denied, .Restricted:
            displayCantAddContactAlert()
        case .Authorized:
            pullContactInfo()
        case .NotDetermined:
            promptForAddressBookRequestAccess()
        }
        
        contactsTableView.layoutMargins = UIEdgeInsetsMake(0, 80, 0, 0)
        
        FacebookLoginHelper.friendListOfUser({
            friends in
            guard friends != nil else {
                print("Hello")
                return
            }
            print("Set all friends")
            self.allFriends = friends
            self.setUpIndexes()
            self.contactsTableView.reloadData()
        
        })
    }
    
    func setUpIndexes() {
        if(allContacts == nil && allFriends == nil) {
            return
        }
        var curFriendIdx = 0
        var curContactIdx = 0
        while(curFriendIdx < allFriends.count || curContactIdx < allContacts.count) {
            let curDict: NSMutableDictionary = NSMutableDictionary()
            if(allContacts == nil || curContactIdx >= allContacts.count) {
                curDict.setObject(curFriendIdx, forKey: "index")
                curDict.setObject("facebook", forKey: "type")
                curFriendIdx += 1
            } else if(allFriends == nil || curFriendIdx >= allFriends.count) {
                curDict.setObject(curContactIdx, forKey: "index")
                curDict.setObject("contact", forKey: "type")
                curContactIdx += 1
            } else {
                let curFriend = allFriends.objectAtIndex(curFriendIdx) as! FacebookFriend
                let curFriendName = curFriend.name
                let curContact = allContacts.objectAtIndex(curContactIdx)
                let curContactName = ABRecordCopyCompositeName(curContact).takeRetainedValue() as String
                
                if(curFriendName > curContactName) {
                    curDict.setObject(curContactIdx, forKey: "index")
                    curDict.setObject("contact", forKey: "type")
                    curContactIdx += 1
                } else {
                    curDict.setObject(curFriendIdx, forKey: "index")
                    curDict.setObject("facebook", forKey: "type")
                    curFriendIdx += 1
                }
            }
            indexInfo.addObject(curDict)
        }
    }
    
    func pullContactInfo() {
        let source: ABRecord = ABAddressBookCopyDefaultSource(addressBookRef).takeRetainedValue()
        
        allContacts = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBookRef, source, ABPersonSortOrdering(kABPersonSortByFirstName)).takeRetainedValue() 
        
        
    }
    
    func promptForAddressBookRequestAccess() {
        var err: Unmanaged<CFError>? = nil
        
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
        var total = 0
        if(allContacts != nil){
            total += allContacts.count
        }
        if(allFriends != nil) {
            total += allFriends.count
        }
        return total
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let contactCell = tableView.dequeueReusableCellWithIdentifier("contactCell", forIndexPath: indexPath)
        
        if(indexInfo.count != 0) {
            let curDict = indexInfo.objectAtIndex(indexPath.row) as! NSMutableDictionary
            
            print(indexPath.row)
            print(curDict)
            
            let index = curDict.objectForKey("index") as! Int
            let type = curDict.objectForKey("type") as! String
            
            if(type == "contact") {
                let curContact = allContacts.objectAtIndex(index)
                let curContactName = ABRecordCopyCompositeName(curContact).takeRetainedValue() as String
                print(curContactName)
                let image =  ABPersonCopyImageDataWithFormat(curContact, kABPersonImageFormatThumbnail)
                let imageView = UIImageView(frame: CGRect(x: 15, y: 5, width: contactCell.frame.size.height - 10, height: contactCell.frame.size.height - 10))
                if(image != nil) {
                    imageView.layer.cornerRadius = imageView.frame.height / 2
                    imageView.clipsToBounds = true
                    imageView.image = UIImage(data: image.takeRetainedValue())
                } else {
                    imageView.image = UIImage(named: "ProfilePicPlaceHolder")
                }
                contactCell.contentView.addSubview(imageView)
                contactCell.textLabel?.text = curContactName
            } else if(type == "facebook") {
                let curFriend = allFriends.objectAtIndex(index) as! FacebookFriend
                let curFriendName = curFriend.name
                contactCell.textLabel?.text = curFriendName
            }
        }
        
        contactCell.textLabel?.textColor = UIColor.whiteColor()
        return contactCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("gameDetailSegue", sender: self)
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