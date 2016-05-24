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


class MainReservationViewController: UIViewController, AKPickerViewDataSource, AKPickerViewDelegate, THDatePickerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    

    var user = User()
    var listOfReservations = [[String : AnyObject]]()
    var reservationTime: String = ""
    var reservationDate: String = ""
    var reservationLocation: String = ""
    var reservationField: String = ""
    let times = ["6:00 AM", "7:00 AM", "8:00 AM", "9:00 AM", "10:00 AM", "11:00 AM", "12:00 PM", "1:00 PM", "2:00 PM", "3:00 PM", "4:00 PM", "5:00 PM", "6:00 PM", "7:00 PM", "8:00 PM", "9:00 PM", "10:00 PM", "11:00 PM"]
    var curDate : NSDate? = NSDate()
  

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var locationOutlet: UILabel!
    @IBOutlet weak var pickerView: AKPickerView!
    @IBOutlet weak var selectedDateOutlet: UIBarButtonItem!
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
    @IBAction func choseLocationBtn(sender: AnyObject) {
        performSegueWithIdentifier("ReservationToLocationSegue", sender: self)
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedDateOutlet.title = formatter.stringFromDate(curDate!)
        setPickerViewOptions()
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        if user.selectedLocation != nil {
            locationOutlet.text = user.selectedLocation!
        }

    }

    func sideMenuDidOpen() {
        print("sideMenuDidOpen")
    }
    
    
    // functions for custom date picker settings 
    //-------------------------------------------------------------
    
    func convertCfTypeToString(cfValue: Unmanaged<NSString>!) -> String?{
        let value = Unmanaged<CFStringRef>.fromOpaque(
            cfValue.toOpaque()).takeUnretainedValue() as CFStringRef
        if CFGetTypeID(value) == CFStringGetTypeID(){
            return value as String
        } else {
            return nil
        }
    }
    
    lazy var formatter: NSDateFormatter = {
        var tmpFormatter = NSDateFormatter()
        tmpFormatter.dateFormat = "dd/MM/yyyy"
        return tmpFormatter
    }()
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
        collectionView.reloadData()
    }
    
    // TODO: set current hour to picker view selected time as default
    func grabCurrentHour() -> Int{
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute], fromDate: date)
        let hour = components.hour
        return hour
    }
    
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
    
    // ------------------------------------------------------------
    
    
    
    // custom picker view functions
    // ------------------------------------------------------------
    
    func numberOfItemsInPickerView(pickerView: AKPickerView) -> Int {
       
        return times.count
    }
    
    func pickerView(pickerView: AKPickerView, titleForItem item: Int) -> String {
       
        return times[item]
    }
    
    func pickerView(pickerView: AKPickerView, didSelectItem item: Int) {
        reservationTime = times[item]
        collectionView.reloadData()
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
    // ----------------------------------------------------------------------------
    
    
    
    // fucntions for updating UI with reserved Fields
    // ----------------------------------------------------------------------------
    
    func isFieldReserved(fieldType: String) -> Bool {
        // TODO IMPLEMENT THIS LOGIC TO GET AT ALL RSERVATIONS FROM API
        let bool = false
        
        for reservation in listOfReservations {
            
            if reservation["time"]! as! String == reservationTime && reservation["date"]! as! String == reservationDate && reservation["location"]! as! String == reservationLocation && reservation["field"]! as! String == fieldType {
                return true
            }
        }
        return bool
    }
    
    
    // -------------------------------------------------------------------------------
    
    
    
    // custom collection views for each soccer location
    // -------------------------------------------------------------------------------
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        switch locationOutlet.text! {
        case "Soccer 5 Hialeah":
            return 1
        case "Soccer 5 Tropical Park":
            return 2
        case "Soccer 5 Kendall":
            return 3
        default:
            return 0
        }
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch locationOutlet.text! {
            case "Soccer 5 Hialeah":
                return 2
            case "Soccer 5 Tropical Park":
                return 2
            case "Soccer 5 Kendall":
                return 2
            default:
                return 0
        }
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FieldCell", forIndexPath: indexPath) as! FieldCollectionViewCell

        
        switch locationOutlet.text! {
            case "Soccer 5 Hialeah":
                switch indexPath.section{
                    case 0:
                        if indexPath.row == 0 {
                            
                            cell.fieldImage.image = UIImage(named: "field-7-7-hialeah")
                            cell.fieldType.text = FieldType.Field7v7.stringValue()
                            
                            
                        } else {
                            cell.fieldImage.image = UIImage(named: "field-7-7-hialeah")
                            cell.fieldType.text = FieldType.Field7v7.stringValue()
                        }
                    
                    default:
                        break
                    
                }
            case "Soccer 5 Tropical Park":
                switch indexPath.section{
                    case 0:
                        if indexPath.row == 0 {
                            cell.fieldType.text = FieldType.Field6v6.stringValue()
                            cell.fieldImage.image = UIImage(named: "field-6-6-tropical-park")
                        } else {
                            cell.fieldType.text = FieldType.Field5v5.stringValue()
                            cell.fieldImage.image = UIImage(named: "field-5-5-tropical-park")
                        }
                    case 1:
                        if indexPath.row == 0 {
                            cell.fieldType.text = FieldType.Field7v7.stringValue()
                            cell.fieldImage.image = UIImage(named: "field-7-7-tropical-park")
                        } else {
                            cell.fieldType.text = FieldType.Field7v7.stringValue()
                            cell.fieldImage.image = UIImage(named: "field-7-7-tropical-park")
                        }
                    
                    default:
                        break
                }
            case "Soccer 5 Kendall":
                switch indexPath.section{
                    case 0:
                        if indexPath.row == 0 {
                            cell.fieldType.text = FieldType.Field6v6.stringValue()
                            cell.fieldImage.image = UIImage(named: "field-6-6-kendall")
                        } else {
                            cell.fieldType.text = FieldType.Field7v7.stringValue()
                            cell.fieldImage.image = UIImage(named: "field-7-7-kendall")
                        }
                    case 1:
                        if indexPath.row == 0 {
                            cell.fieldType.text = FieldType.Field5v5.stringValue()
                            cell.fieldImage.image = UIImage(named: "field-5-5-kendall")
                        } else {
                            cell.fieldType.text = FieldType.Field5v5.stringValue()
                            cell.fieldImage.image = UIImage(named: "field-5-5-kendall")
                        }
                    case 2:
                        if indexPath.row == 0 {
                            cell.fieldType.text = FieldType.Field5v5.stringValue()
                            cell.fieldImage.image = UIImage(named: "field-5-5-kendall")
                        } else {
                            cell.fieldType.text = FieldType.Field5v5.stringValue()
                            cell.fieldImage.image = UIImage(named: "field-5-5-kendall")
                        }
                    
                default:
                    break
            }
        default:
            break
        }
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! FieldCollectionViewCell
        reservationTime = times[0]
        reservationField = cell.fieldType.text!
        reservationDate = formatter.stringFromDate(curDate!)
        reservationLocation = locationOutlet.text!
        
        let alert = UIAlertController(title: nil, message: "Do you want to reserve \(reservationField) field at \(reservationLocation) on \(reservationDate) at \(reservationTime)?" , preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default , handler: { action in
            // if user wants to reserve, save fields to reservation model
            
            let reservationDataArr = [
                "User_id": self.user.userFBID!,
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
            collectionView.reloadData()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}


