//
//  GameDetailsViewController.swift
//  soccer5
//
//  Created by Sebastian Misas on 5/9/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import UIKit

class GameDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBAction func goToGame(sender: AnyObject) {
        performSegueWithIdentifier("goToGame", sender: self)
    }
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        if(segue.sourceViewController .isKindOfClass(GameModificationsViewController))
        {
            let controller:GameModificationsViewController = segue.sourceViewController as! GameModificationsViewController
            // Update game settings
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let gameCell = tableView.dequeueReusableCellWithIdentifier("gameDetailCell", forIndexPath: indexPath) as! GameDetailTableViewCell
        // TODO: Update UI for each row with games details
        switch indexPath.row {
        case 0:
            gameCell.icon.image = UIImage(named: "icon-calendar")
        case 1:
            gameCell.icon.image = UIImage(named: "icon-time")
        case 2:
            gameCell.icon.image = UIImage(named: "icon-location")
        default:
            break
        }
        return gameCell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("gameDetailSegue", sender: self)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let playerCell = collectionView.dequeueReusableCellWithReuseIdentifier("playerCell", forIndexPath: indexPath) as! PlayerCollectionViewCell
        return playerCell
    }
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
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
