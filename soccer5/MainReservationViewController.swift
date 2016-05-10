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


class MainReservationViewController: UIViewController, AKPickerViewDataSource, AKPickerViewDelegate, THDatePickerDelegate, UIGestureRecognizerDelegate {
    
    // example
    var listOfReservations = [
        //TODO: populate this dictionary with reservations from backend
        [
            "User_id": "data",
            "field": "data",
            "date": "data",
            "time": "data",
            "location": "data"
        ],
        
    ]
    
    var reservationTime: String = ""
    var reservationDate: String = ""
    var reservationLocation: String = ""
    var reservationField: String = ""
    var ud = User()
    
    
    let times = ["6:00 AM", "7:00 AM", "8:00 AM", "9:00 AM", "10:00 AM", "11:00 AM", "12:00 PM", "1:00 PM", "2:00 PM", "3:00 PM", "4:00 PM", "5:00 PM", "6:00 PM", "7:00 PM", "8:00 PM", "9:00 PM", "10:00 PM", "11:00 PM"]
    var curDate : NSDate? = NSDate()
  
    //custom date picker
    lazy var datePicker:THDatePickerViewController = {
        var dp = THDatePickerViewController.datePicker()
        dp.delegate = self
        dp.setAllowClearDate(false)
        dp.setClearAsToday(true)
        dp.setAutoCloseOnSelectDate(false)
        dp.setAllowSelectionOfSelectedDate(true)
        dp.setDisableHistorySelection(true)
        dp.setDisableFutureSelection(false)
        dp.selectedBackgroundColor = UIColor(red: 125/255.0, green: 208/255.0, blue: 0/255.0, alpha: 1.0)
        dp.currentDateColor = UIColor(red: 242/255.0, green: 121/255.0, blue: 53/255.0, alpha: 1.0)
        dp.currentDateColorSelected = UIColor.yellowColor()
        return dp
    }()
    
    // formater for date picker
    lazy var formatter: NSDateFormatter = {
        var tmpFormatter = NSDateFormatter()
        tmpFormatter.dateFormat = "dd/MM/yyyy"
        return tmpFormatter
    }()
    

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var locationOutlet: UILabel!
    @IBOutlet weak var pickerView: AKPickerView!
    @IBOutlet weak var fieldControlOutlet: UISegmentedControl!
    @IBOutlet weak var fieldImage: UIImageView!
    @IBOutlet weak var selectedDateOutlet: UIBarButtonItem!
    @IBOutlet weak var reservationBtnOutlet: UIButton!

    @IBAction func indexChanged(sender: UISegmentedControl) {
     
        reservationField = fieldControlOutlet.titleForSegmentAtIndex(fieldControlOutlet.selectedSegmentIndex)!
        updateFieldsUI()
        updateUIWithReservedFields()
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
    
    @IBAction func makeReservationBtn(sender: AnyObject) {
        let alert = UIAlertController(title: nil, message: "Do you want to reserve \(reservationField) field at \(reservationLocation) on \(reservationDate) at \(reservationTime)?" , preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default , handler: { action in
            // if user wants to reserve, save fields to reservation model

            let reservationDataArr = [
                "User_id": self.ud.userFBID!,
                "field": self.reservationField,
                "date": self.reservationDate,
                "time": self.reservationTime,
                "location": self.reservationLocation
            ]
            self.listOfReservations.append(reservationDataArr)
            
            // TODO: Implement backend to save reservation
            // present an alert on success
            let successAlert = UIAlertController(title: nil, message: "Reservation is successfully made" , preferredStyle: UIAlertControllerStyle.Alert)
            successAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(successAlert, animated: true, completion: nil)
            self.updateUIWithReservedFields()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }

    @IBAction func choseLocationBtn(sender: AnyObject) {
        performSegueWithIdentifier("ReservationToLocationSegue", sender: self)
    }
    
    // unwind from locations and update the reservation location
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        if(segue.sourceViewController .isKindOfClass(SoccerLocationsViewController))
        {
            let controller:SoccerLocationsViewController = segue.sourceViewController as! SoccerLocationsViewController
            locationOutlet.text = controller.updatedSelection
            reservationLocation = controller.updatedSelection
            
        }
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateFieldsUI()
        updateUIWithReservedFields()
        

        // default reservation settings:
        reservationTime = times[0]
        reservationField = fieldControlOutlet.titleForSegmentAtIndex(fieldControlOutlet.selectedSegmentIndex)!
        reservationDate = formatter.stringFromDate(curDate!)
        reservationLocation = locationOutlet.text!
        
        fieldControlOutlet.exclusiveTouch = true
        selectedDateOutlet.title = formatter.stringFromDate(curDate!)
        setPickerViewOptions()
        
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        var swipeLeft = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
        
        
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
       
    }
    
    // updating field selection on swipe gesture
    func sideMenuWillOpen() {
        print("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
        print("sideMenuWillClose")
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        print("sideMenuShouldOpenSideMenu")
        return true
    }
    
    func sideMenuDidClose() {
        print("sideMenuDidClose")
    }
    
    func sideMenuDidOpen() {
        print("sideMenuDidOpen")
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.Right:
                
                fieldControlOutlet.selectedSegmentIndex = (fieldControlOutlet.selectedSegmentIndex + 1) % fieldControlOutlet.numberOfSegments
                indexChanged(fieldControlOutlet)
            
            case UISwipeGestureRecognizerDirection.Left:
                
                fieldControlOutlet.selectedSegmentIndex = (fieldControlOutlet.selectedSegmentIndex - 1) % fieldControlOutlet.numberOfSegments
                if(fieldControlOutlet.selectedSegmentIndex == -1){
                    fieldControlOutlet.selectedSegmentIndex = fieldControlOutlet.numberOfSegments-1
                }
                
                indexChanged(fieldControlOutlet)
                
            default:
                break
            }
        }
    }
    
    // functions for custom date picker settings 
    //------------------------------------------------
    
    func convertCfTypeToString(cfValue: Unmanaged<NSString>!) -> String?{
        let value = Unmanaged<CFStringRef>.fromOpaque(
            cfValue.toOpaque()).takeUnretainedValue() as CFStringRef
        if CFGetTypeID(value) == CFStringGetTypeID(){
            return value as String
        } else {
            return nil
        }
    }
    
    func refreshTitle() {
        selectedDateOutlet.title = formatter.stringFromDate(curDate!)
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
        reservationDate = formatter.stringFromDate(selectedDate)
        updateUIWithReservedFields()
    }
    
    // TODO: set current hour to picker view selected time as default
    func grabCurrentHour() -> Int{
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute], fromDate: date)
        let hour = components.hour
        return hour
    }
    
    // custom picker view functions
    
    func numberOfItemsInPickerView(pickerView: AKPickerView) -> Int {
       
        return times.count
    }
    
    func pickerView(pickerView: AKPickerView, titleForItem item: Int) -> String {
       
        return times[item]
    }
    
    func pickerView(pickerView: AKPickerView, didSelectItem item: Int) {
        reservationTime = times[item]
        updateFieldsUI()
        updateUIWithReservedFields()
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
    
    func updateUIWithReservedFields() {
        for reservation in listOfReservations {
            // check to see if all fields match if they do change UI to booked
            if reservation["time"]! == reservationTime && reservation["date"]! == reservationDate && reservation["location"]! == reservationLocation && reservation["field"]! == reservationField {
                fieldImage.image = UIImage(named: "icon-field-booked.png")
                reservationBtnOutlet.hidden = true
            }
        }
    }
    
    func updateFieldsUI() {
        switch fieldControlOutlet.selectedSegmentIndex
        {
            case 0:
                fieldImage.image = UIImage(named: "icon-field-5-5-portrait.png")
            case 1:
                fieldImage.image = UIImage(named: "icon-field-6-6.png")
            case 2:
                fieldImage.image = UIImage(named: "icon-field-7-7.png")
            case 3:
                fieldImage.image = UIImage(named: "icon-field-8-8.png")
            default:
                break;
        }
        reservationBtnOutlet.hidden = false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}


