//
//  MessageCenterViewController.swift
//  soccer5
//
//  Created by Sebastian Misas on 5/26/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import Photos

class MessageCenterViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    @IBAction func addFriends(sender: AnyObject) {
    }
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var database: FIRDatabase!
    var storage: FIRStorage!
    var messages: [ChatMessage]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        let chatRef = database.reference()
        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ConversationPreviewCell", forIndexPath: indexPath) as! ConversationPreviewTableViewCell
//        let chatMessage = messages[indexPath.row]
        //        cell.nameLabel.text = chatMessage.name
        //        cell.messageLabel.text = chatMessage.message
        //        cell.photoView.image = chatMessage.image
        return cell
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
            return 1
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("chatRoomSegue", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
