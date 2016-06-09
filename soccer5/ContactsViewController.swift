//
//  File.swift
//  soccer5
//
//  Created by Jennifer Duffey on 6/8/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import MessageUI

@available(iOS 9.0, *)
class ContactsViewController: UIViewController
{
    @IBOutlet var contactView: ContactView!
    @IBOutlet var contactTableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var menuButton: UIBarButtonItem!
    
    var checkedItem: Int = -1
    
    var contacts = [Friend]()
    
    var selectedContacts = [Friend]()

    
    var selectedIndex: Int = 0
    {
        didSet
        {
            self.getContacts()
        }
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    /*
    @available(iOS 9.0, *)
    func showContacts()
    {
       // if #available(iOS 9.0, *)
        //{
            let contactPicker = CNContactPickerViewController()
            contactPicker.delegate = self
            contactPicker.predicateForEnablingContact = NSPredicate(format: "phoneNumbers.@count > 0")
            self.presentViewController(contactPicker, animated: true, completion: nil)
        //}
        //else
        //{
            // Fallback on earlier versions
        //}
    }*/
    
    @available(iOS 9.0, *)
    func getContacts()
    {
        self.contacts.removeAll()
        
        if self.selectedIndex == 1
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
            {
                let fetchRequest = CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactImageDataKey])
                
              //  if #available(iOS 9.0, *)
               // {
                    let store = CNContactStore()
                    
                    do
                    {
                        try store.enumerateContactsWithFetchRequest(fetchRequest, usingBlock:
                        {
                            contact, cursor in
                                
                            let newContact = contact as CNContact
                            let friend = Friend(contact: newContact, invited: false)
                            self.contacts.append(friend)
                        })
                        
                        dispatch_async(dispatch_get_main_queue(),
                        {
                            self.contactTableView.reloadData()
                        })
                    }
                    catch
                    {
                        print("ERROR")
                    }
            })
        }

        self.contactTableView.reloadData()
    }
    
    func sendMessages()
    {
        var phoneNumbers = [String]()
        
        //MARK: UNCOMMENT TO SEND MESSAGE TO SELECTED CONTACTS WITH A PHONE NUMBER
        /*
        for friend in self.selectedContacts
        {
            if friend.phoneNumber?.isEmpty == false
            {
                phoneNumbers.append(friend.phoneNumber!)
            }
        }*/
        
        //MARK: UNCOMMENT AND ADD YOUR PHONE NUMBER HERE TO TEST SENDING MESSAGE TO YOURSELF
        phoneNumbers.append("123456789")
        
        let messageVC = MFMessageComposeViewController()
        messageVC.body = "Join Me"
        messageVC.recipients = phoneNumbers
        messageVC.messageComposeDelegate = self
        
        self.presentViewController(messageVC, animated: true, completion: nil)
    }
    
    @IBAction func segmentChanged(sender: UISegmentedControl)
    {
        self.selectedIndex = sender.selectedSegmentIndex
    }
    
    @IBAction func invite(sender: AnyObject)
    {
        self.sendMessages()
    }
}

@available(iOS 9.0, *)
extension ContactsViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.contacts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        if let friendCell = tableView.dequeueReusableCellWithIdentifier("ContentCellIdentifier") as? FriendCell
        {
            let friend = self.contacts[indexPath.row]
            
            friendCell.friend = friend
            
            if self.selectedContacts.contains(friend) == true
            {
                friendCell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
            else
            {
                friendCell.accessoryType = UITableViewCellAccessoryType.None
            }

            return friendCell
        }
        
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        self.checkedItem = indexPath.row
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? FriendCell
        {
            let friend = self.contacts[indexPath.row]
            
            if let friendIndex = self.selectedContacts.indexOf(friend)
            {
                self.selectedContacts.removeAtIndex(friendIndex)
                
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            else
            {
                self.selectedContacts.append(friend)
                
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
        }
    }

}


@available(iOS 9.0, *)
extension ContactsViewController: CNContactPickerDelegate
{
    @available(iOS 9.0, *)
    func contactPicker(picker: CNContactPickerViewController, didSelectContacts contacts: [CNContact])
    {
        
    }
}

@available(iOS 9.0, *)
extension ContactsViewController: MFMessageComposeViewControllerDelegate
{
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult)
    {
        print("MESSAGE SENT")
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}