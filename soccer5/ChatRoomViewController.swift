//
//  ChatRoomViewController.swift
//  soccer5
//
//  Created by Sebastian Misas on 5/25/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import Photos

class ChatRoomViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    var database: FIRDatabase!
    var storage: FIRStorage!
    var messages: [ChatMessage]!
    var username = String()
    var userId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        database = FIRDatabase.database()
        storage = FIRStorage.storage()

        if isAFacbookUser() == true{
            username = User().userFBFirstName!
            userId = User().userFBID!
        } else {
            username = User().userName!
            userId = User().userID!
        }
        
        // Do any additional setup after loading the view.
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("chatMessageCell", forIndexPath: indexPath) as! ChatMessageTableViewCell
        let chatMessage = messages[indexPath.row]
//        cell.nameLabel.text = chatMessage.name
//        cell.messageLabel.text = chatMessage.message
//        cell.photoView.image = chatMessage.image
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let chatMessage = messages[indexPath.row]
        if (chatMessage.image != nil) {
            return 345.0
        } else {
            return 58.0
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
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
