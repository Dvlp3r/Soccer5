//
//  GameViewController.swift
//  soccer5
//
//  Created by Sebastian Misas on 5/19/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {


    @IBOutlet weak var gameTitle: UIButton!
    @IBOutlet weak var gameTime: UILabel!
    @IBOutlet weak var gameDate: UILabel!
    @IBOutlet weak var gameLocation: UILabel!
    @IBOutlet weak var tableView: UITableView!

    @IBAction func gameDetailsBtn(sender: AnyObject) {
        performSegueWithIdentifier("gameDetailsSegue", sender: self)
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        if(segue.sourceViewController .isKindOfClass(GameDetailsViewController))
        {
            let controller:GameDetailsViewController = segue.sourceViewController as! GameDetailsViewController
            // Update game settings
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCellWithIdentifier("gamePlayerCell", forIndexPath: indexPath) as! gamePlayerTableViewCell
        // TODO: Update UI for each row with games mofication Options
        
        return Cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

}
