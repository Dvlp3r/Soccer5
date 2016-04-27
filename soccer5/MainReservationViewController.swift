//
//  MainReservationViewController.swift
//  soccer5
//
//  Created by Sebastian Misas on 4/26/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import UIKit
import AKPickerView_Swift
import THCalendarDatePicker

class MainReservationViewController: UIViewController, AKPickerViewDataSource, AKPickerViewDelegate, THDatePickerDelegate {
    
    let times = ["6:00 AM", "7:00 AM", "8:00 AM", "9:00 AM", "10:00 AM", "11:00 AM", "12:00 PM", "1:00 PM", "2:00 PM", "3:00 PM", "4:00 PM", "5:00 PM", "6:00 PM", "7:00 PM", "8:00 PM", "9:00 PM", "10:00 PM", "11:00 PM"]
    var curDate : NSDate? = NSDate()
    
    lazy var datePicker:THDatePickerViewController = {
        var dp = THDatePickerViewController.datePicker()
        dp.delegate = self
        dp.setAllowClearDate(false)
        dp.setClearAsToday(true)
        dp.setAutoCloseOnSelectDate(false)
        dp.setAllowSelectionOfSelectedDate(true)
        dp.setDisableHistorySelection(true)
        dp.setDisableFutureSelection(false)
        //dp.autoCloseCancelDelay = 5.0
        dp.selectedBackgroundColor = UIColor(red: 125/255.0, green: 208/255.0, blue: 0/255.0, alpha: 1.0)
        dp.currentDateColor = UIColor(red: 242/255.0, green: 121/255.0, blue: 53/255.0, alpha: 1.0)
        dp.currentDateColorSelected = UIColor.yellowColor()
        return dp
    }()
    
    lazy var formatter: NSDateFormatter = {
        var tmpFormatter = NSDateFormatter()
        tmpFormatter.dateFormat = "dd/MM/yyyy"
        return tmpFormatter
    }()
    
    @IBOutlet weak var pickerView: AKPickerView!
    @IBOutlet weak var fieldControlOutlet: UISegmentedControl!
    
    @IBOutlet weak var selectedDateOutlet: UIButton!
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch fieldControlOutlet.selectedSegmentIndex
        {
        case 0:
            print("First selected")
        case 1:
            print("Second Segment selected")
        default:
            break; 
        }
    }
    @IBAction func choseDateBtn(sender: AnyObject) {
        datePicker.date = curDate
        datePicker.setDateHasItemsCallback({(date:NSDate!) -> Bool in
            let tmp = (arc4random() % 30) + 1
            return tmp % 5 == 0
        })
        presentSemiViewController(datePicker, withOptions: [
            convertCfTypeToString(KNSemiModalOptionKeys.shadowOpacity) as String! : 0.3 as Float,
            convertCfTypeToString(KNSemiModalOptionKeys.animationDuration) as String! : 0.5 as Float,
            convertCfTypeToString(KNSemiModalOptionKeys.pushParentBack) as String! : true as Bool
            ])
        
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedDateOutlet.setTitle((curDate != nil ? formatter.stringFromDate(curDate!) : "No date selected"), forState: UIControlState.Normal)
        setPickerViewOptions()
        
        // Do any additional setup after loading the view.
    }
    
    func convertCfTypeToString(cfValue: Unmanaged<NSString>!) -> String?{
        /* Coded by Vandad Nahavandipoor */
        let value = Unmanaged<CFStringRef>.fromOpaque(
            cfValue.toOpaque()).takeUnretainedValue() as CFStringRef
        if CFGetTypeID(value) == CFStringGetTypeID(){
            return value as String
        } else {
            return nil
        }
    }
    
    func refreshTitle() {
        selectedDateOutlet.setTitle((curDate != nil ? formatter.stringFromDate(curDate!) : "No date selected"), forState: UIControlState.Normal)
    }
    func datePickerDonePressed(datePicker: THDatePickerViewController!) {
        curDate = datePicker.date
        refreshTitle()
        dismissSemiModalView()
    }
    
    func datePickerCancelPressed(datePicker: THDatePickerViewController!) {
        dismissSemiModalView()
    }
    
    func datePicker(datePicker: THDatePickerViewController!, selectedDate: NSDate!) {
        print("Date selected: ", formatter.stringFromDate(selectedDate))
    }
    

    func grabCurrentHour() -> Int{
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute], fromDate: date)
        let hour = components.hour
        return hour
    }
    
    func numberOfItemsInPickerView(pickerView: AKPickerView) -> Int {
       
        return times.count
      
        
    }
    
    func pickerView(pickerView: AKPickerView, titleForItem item: Int) -> String {
       
        return times[item]
        
    }
    
    func pickerView(pickerView: AKPickerView, didSelectItem item: Int) {
        print("selected: \(times[item])")
    }
    
    func setPickerViewOptions() {
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        pickerView.font = UIFont(name: "HelveticaNeue-Light", size: 20)!
        pickerView.highlightedFont = UIFont(name: "HelveticaNeue", size: 22)!
        pickerView.pickerViewStyle = .Wheel
        pickerView.backgroundColor = UIColor.clearColor()
        pickerView.textColor = UIColor.whiteColor()
        pickerView.maskDisabled = false
        pickerView.interitemSpacing = 20
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 

}


