//
//  UpcomingGamesViewController.swift
//  soccer5
//
//  Created by Sebastian Misas on 5/9/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import UIKit

class UpcomingGamesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func reserveGameBtn(sender: AnyObject) {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("Main")
        self.revealViewController().pushFrontViewController(controller, animated: true)
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
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let gameCell = tableView.dequeueReusableCellWithIdentifier("gameCell", forIndexPath: indexPath) as! GameTableViewCell
        
        return gameCell
        
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
