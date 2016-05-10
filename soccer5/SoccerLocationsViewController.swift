//
//  SoccerLocationsViewController.swift
//  soccer5
//
//  Created by Sebastian Misas on 4/28/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import UIKit

class SoccerLocationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var soccerLocationsArray = ["Soccer 5 Tropical Park", "Soccer 5 Kendall", "Soccer 5 Hialeah"]
    var updatedSelection:String = ""
    var searchActive : Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchLocationOutlet: UISearchBar!
    @IBOutlet weak var menuButton: UIBarButtonItem!

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        searchLocationOutlet.delegate = self
        
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        // Do any additional setup after loading the view.
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
        self.view.endEditing(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        for location in soccerLocationsArray {
            if searchText == location {
                
                self.tableView.reloadData()
            }
        }
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return soccerLocationsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("locationCell") as! SoccerLocationTableViewCell
        cell.locationName.text = soccerLocationsArray[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        updatedSelection = soccerLocationsArray[indexPath.row]
        self.performSegueWithIdentifier("unwindToMain", sender: self)
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
