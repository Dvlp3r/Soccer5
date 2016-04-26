//
//  ReservationViewController.swift
//  soccer5
//
//  Created by Sebastian Misas on 4/21/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import UIKit
import AKPickerView_Swift

class ReservationViewController: UIViewController, AKPickerViewDataSource, AKPickerViewDelegate {
    
    var dateSelected = false
    var timeSelected = true
    let times = ["12:00 AM", "1:00 AM", "2:00 AM", "3:00 AM", "4:00 AM", "5:00 AM", "6:00 AM", "7:00 AM", "8:00 AM", "9:00 AM", "10:00 AM", "11:00 AM", "12:00 PM", "1:00 PM", "2:00 PM", "3:00 PM", "4:00 PM", "5:00 PM", "6:00 PM", "7:00 PM", "8:00 PM", "9:00 PM", "10:00 PM", "11:00 PM"]
    
    var dates: [NSDate] = []
    
    @IBOutlet weak var pickerView: AKPickerView!
    @IBOutlet weak var locationNameLabel: UILabel!
    
    @IBAction func menuBtn(sender: AnyObject) {
    }
    @IBAction func locationOfReservBtn(sender: AnyObject) {
    }

    @IBAction func dateForReservBtn(sender: AnyObject) {
        dateSelected = true
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pickerView.hidden = true
        
        addDatesToArray()

        
        if dateSelected == true {
            timeSelected = false
            pickerView.accessibilityElements?.removeAll()
            addDatesToPickerView(dates)
            pickerView.reloadData()
            
        } else if timeSelected == true {
            
            addTimesToPickerView(times)
        }
        
    }
    
    func addTimesToPickerView(times: NSArray) {
        for time in times {
            func pickerView(pickerView: AKPickerView, titleForItem item: Int) -> String {
                
                return time as! String
                
            }
        }
    }
    
    func addDatesToArray() {
        let ti:NSTimeInterval = 24*60*60 //one day
        let dateFrom = NSDate() //Now
        let dateTo = dateFrom.dateByAddingTimeInterval(24*60*60*30) //30 Days later
        
        var nextDate = NSDate()
        var endDate = dateTo.dateByAddingTimeInterval(ti)
        
        while nextDate.compare(endDate) == NSComparisonResult.OrderedAscending
        {
            dates.append(nextDate)
        }
        
        print(dates)
    }
    
    func addDatesToPickerView(dates: NSArray) {
        for date in dates {
            func pickerView(pickerView: AKPickerView, titleForItem item: Int) -> String {
                
                return date as! String
                
            }
        }
    }
    
    func numberOfItemsInPickerView(pickerView: AKPickerView) -> Int {
        if dateSelected == true {
            return dates.count
        }else if timeSelected == true {
            return self.times.count
        } else {
            return 0
        }
    }
    

    func pickerView(pickerView: AKPickerView, didSelectItem item: Int) {
        
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
