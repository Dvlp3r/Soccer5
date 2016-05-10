//
//  GameModificationsViewController.swift
//  soccer5
//
//  Created by Sebastian Misas on 5/9/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import UIKit

class GameModificationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let changeDetailCell = tableView.dequeueReusableCellWithIdentifier("changeDetailCell", forIndexPath: indexPath) as! ChangeDetailTableViewCell
        // TODO: Update UI for each row with games mofication Options
        
        return changeDetailCell
        
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
