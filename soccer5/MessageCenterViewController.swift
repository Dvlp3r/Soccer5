//
//  MessageCenterViewController.swift
//  soccer5
//
//  Created by Sebastian Misas on 5/25/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import UIKit
import Firebase

struct ChatMessage {
    var name: String!
    var message: String!
    var image: UIImage?
}

class MessageCenterViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBAction func addFriendsBtn(sender: AnyObject) {
    }
    
    let database = FIRDatabase.database()
    
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
