//
//  MyFriendsViewController.swift
//  soccer5
//
//  Created by Greg Salvesen on 5/20/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import UIKit
import AddressBook
import Firebase
import FirebaseAuth

class MyFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let dbRef = FIRDatabase.database().reference()
    
    let addressBookRef = ABAddressBookCreateWithOptions(nil, nil).takeRetainedValue()
    
    var allContacts = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
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
            guard let friends = friends else {
                return
            }
            for friend in friends {
                let contact = Contact(fb: friend, invited: false)
                if !self.allContacts.contains({ $0.name == contact.name }) {
                    self.allContacts.append(contact)
                }
            }
            
            self.tableView.reloadData()
            
        })
    }
    
    
    func pullContactInfo() {
        let source: ABRecord = ABAddressBookCopyDefaultSource(addressBookRef).takeRetainedValue()
        
        let allContacts = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBookRef, source, ABPersonSortOrdering(kABPersonSortByFirstName)).takeRetainedValue() as [AnyObject]
        
        for c in allContacts {
            let contact = Contact(ab: c, invited: false)
            if !self.allContacts.contains({ $0.name == contact.name }) {
                self.allContacts.append(contact)
            }
        }
        
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
        cantAddContactAlert.addAction( UIAlertAction(title: "Change Settings",
            style: .Default,
            handler: { action in
                self.openSettings()
        }) )
        
        cantAddContactAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        presentViewController(cantAddContactAlert, animated: true, completion: nil)
    }
    
    func openSettings() {
        let url = NSURL(string: UIApplicationOpenSettingsURLString)
        UIApplication.sharedApplication().openURL(url!)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(segmentedControl.selectedSegmentIndex == 1) {
            return allContacts.count
        } else {
//            let friends = defaults.arrayForKey("friends")
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let contactCell: MyFriendsTableViewCell = tableView.dequeueReusableCellWithIdentifier("contactCell", forIndexPath: indexPath) as! MyFriendsTableViewCell
        
        if(segmentedControl.selectedSegmentIndex == 1) {
                let contact = allContacts[indexPath.row]
                let frame = CGRect(x: 15, y: 5, width: contactCell.frame.size.height - 10, height: contactCell.frame.size.height - 10)
                let imageView = UIImageView(frame: frame)
                contactCell.check.hidden = !(contact.invited ?? false)
            
                contactCell.icon.image = contact.image
                contactCell.icon.layer.cornerRadius = contactCell.icon.frame.width / 2
                contactCell.icon.clipsToBounds = true
                contactCell.contentView.addSubview(imageView)
                contactCell.label.text = contact.name
            
                contactCell.label.textColor = UIColor.whiteColor()
        } else {
//            guard let friends = defaults.objectForKey("friends") as? [AnyObject] else {
//                return contactCell
//            }
//            print(friends)
//            let curFriend = friends[indexPath.row]
//            contactCell.label.text = curFriend["contact"] as? String
//            contactCell.icon.image = UIImage(named: "ProfilePicPlaceHolder")
        }
        
        return contactCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let contact = allContacts[indexPath.row]
        let curCell = tableView.cellForRowAtIndexPath(indexPath) as! MyFriendsTableViewCell
        curCell.check.hidden = !contact.invited
        contact.invited = !contact.invited
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print(#function)
    }
  
    @IBAction func inviteButtonWasPressed(sender: UIButton) {
        let invited = allContacts.filter({ $0.invited })
        if let user = FIRAuth.auth()?.currentUser {
            for i in invited {
                dbRef.child("user").child(user.uid).child("friends").child("\(i.id)").setValue(i.toDictionary())
            }
        }
        print("Invited: \(invited)")
//        defaults.setObject(new, forKey: "friends")
//        defaults.synchronize()
    }
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        tableView.reloadData()
    }
}