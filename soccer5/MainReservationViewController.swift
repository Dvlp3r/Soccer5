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


class MainReservationViewController: UIViewController, AKPickerViewDataSource, AKPickerViewDelegate, THDatePickerDelegate, UICollectionViewDataSource {
    

    var user = User()
    var listOfReservations = [[String : AnyObject]]()
    var reservationTime: ReservationFieldTime?
    var reservationDate: String = ""
    var reservationLocation: String = ""
    var reservationField: String = ""
    var textFieldData:String = "John"
    
    var times = [ReservationFieldTime!]()
    //["6 AM", "7 AM", "8 AM", "9 AM", "10 AM", "11 AM", "12 PM", "1 PM", "2 PM", "3 PM", "4 PM", "5 PM", "6 PM", "7 PM", "8 PM", "9 PM", "10 PM", "11 PM"]
    var curDate : NSDate? = NSDate()
  

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var timeCollectionView: ReservationCollectionView!
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

    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.setUpTimes()
        
        selectedDateOutlet.title = formatter.stringFromDate(curDate!)
        setPickerViewOptions()
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        if user.selectedLocation != nil {
            locationOutlet.text = user.selectedLocation!
        }
        collectionView.reloadData()
        WebService.send(.GET,
            atURL: "\(BaseURL)/api/v1/locations",
            headers: returnHeaders,
            parameters: nil,
            successBlock: { (response) in
                guard let Resp = response else {
                    return
                }
                            
                print(Resp)
            },
            failureBlock: { (message) in
                print(message)
        })
    }
    
    func setUpTimes()
    {
        for i in 6..<12
        {
            let time = ReservationFieldTime(time: "\(i)", twelveHRSymbol: "AM")
            self.times.append(time)
        }
        
        let time = ReservationFieldTime(time: "12", twelveHRSymbol: "PM")
        self.times.append(time)
        
        for i in 1..<13
        {
            let time = ReservationFieldTime(time: "\(i)", twelveHRSymbol: "PM")
            self.times.append(time)
        }
        
        self.timeCollectionView.reloadData()
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
        tmpFormatter.dateFormat = "dd/MM"
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
        print(selectedDate)
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
    
    
    
    // custom Time picker view functions
    // ------------------------------------------------------------
    
    func numberOfItemsInPickerView(pickerView: AKPickerView) -> Int {
       
        return self.times.count
    }
    
    
    func pickerView(pickerView: AKPickerView, titleForItem item: Int) -> String
    {
        let reservationTime = self.times[item] as ReservationFieldTime
       
        return "\(reservationTime.twelveHRSymbol)\n\(reservationTime.time)"
    }
    
    func pickerView(pickerView: AKPickerView, configureLabel label: UILabel, forItem item: Int)
    {
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = 50
        label.textAlignment = NSTextAlignment.Center
    }
    
    func pickerView(pickerView: AKPickerView, didSelectItem item: Int)
    {
        self.reservationTime = self.times[item]
        //reservationTime = times[item]
        collectionView.reloadData()
    }
    
    func setPickerViewOptions() {
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.font = UIFont(name: "HelveticaNeue-Light", size: 15)!
        pickerView.highlightedFont = UIFont(name: "HelveticaNeue", size: 20)!
        pickerView.highlightedTextColor = UIColor.whiteColor()
        pickerView.backgroundColor = UIColor.clearColor()
        pickerView.pickerViewStyle = .Wheel
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
        
        for reservation in listOfReservations
        {
            
            
            if reservation["time"]! as! String == self.reservationTime!.getTimeString() && reservation["date"]! as! String == reservationDate && reservation["location"]! as! String == reservationLocation && reservation["field"]! as! String == fieldType {
                return true
            }
        }
        return bool
    }
    
    
    // -------------------------------------------------------------------------------
    
    
    
    // custom collection views for each soccer location
    // -------------------------------------------------------------------------------
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        if collectionView == self.timeCollectionView
        {
            return 1
        }
        
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
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if collectionView == self.timeCollectionView
        {
            return self.times.count
        }
        
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
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        if collectionView == self.timeCollectionView
        {
            let time = self.times[indexPath.row]
            
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("TimeCellIdentifier", forIndexPath: indexPath) as! TimeCell
            cell.reservationTime = time
            
            return cell
        }
        
        
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
                            //cell.fieldImage.contentMode = UIViewContentMode.BottomRight
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
                            cell.fieldImage.contentMode = UIViewContentMode.Bottom
                        } else {
                            cell.fieldType.text = FieldType.Field7v7.stringValue()
                            cell.fieldImage.image = UIImage(named: "field-7-7-kendall")
                        }
                    case 1:
                        if indexPath.row == 0 {
                            cell.fieldType.text = FieldType.Field5v5.stringValue()
                            cell.fieldImage.image = UIImage(named: "field-5-5-kendall")
                            //cell.fieldImage.contentMode = UIViewContentMode.Right
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
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView
    {
        if collectionView == self.timeCollectionView
        {
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderCellIdentifier", forIndexPath: indexPath)
            return headerView
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath)
    {
        print("DID END DISPLAYING: \(indexPath.item)")
    }
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath)
    {
        print("DID HIGHLIGHT: \(indexPath.item)")
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        
        return true
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath)
    {
        print("DID DESELECT: \(indexPath.item)")
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        if collectionView == self.timeCollectionView
        {
            let time = self.times[indexPath.row]
            
         
            return
        }
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! FieldCollectionViewCell
        
        self.reservationTime = self.times[0]
        //reservationTime = times[0]
        reservationField = cell.fieldType.text!
        reservationDate = formatter.stringFromDate(curDate!)
        reservationLocation = locationOutlet.text!
        
        let alert = UIAlertController(title: nil, message: "Do you want to reserve \(reservationField) field at \(reservationLocation) on \(reservationDate) at \(reservationTime)?" , preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default , handler: { action in
            // if user wants to reserve, save fields to reservation model
            
            let reservationDataArr = [
                "User_id": self.user.userID!,
                "field": self.reservationField,
                "date": self.reservationDate,
                "time": self.reservationTime!.getTimeString(),
                "location": self.reservationLocation
            ]
            self.listOfReservations.append(reservationDataArr)
            
            // TODO: Implement backend to save reservation


//            WebService.send(.POST,
//                atURL: "\(BaseURL)/api/v1/reservations",
//                parameters:[
//                    "reservation": [
//                        
//                    ],
//                    "reservation[field_id]": "",
//                    
//                    "reservation[date]": ""
//                    
//                ],
//                successBlock: { (response) in
//                    guard let Resp = response else {
//                        return
//                    }
//                    
//                    print(Resp)
//                },
//                failureBlock: { (message) in
//                    print(message)
//            })
            
            // present an alert on success
            let successAlert = UIAlertController(title: nil, message: "Reservation is successfully made" , preferredStyle: UIAlertControllerStyle.Alert)
            successAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: nil))
            self.presentViewController(successAlert, animated: true, completion: nil)
            collectionView.reloadData()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)

        
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        if collectionView == self.timeCollectionView
        {
            let leftEdge = (collectionView.bounds.size.width - 60) / 2
            
            return UIEdgeInsets.init(top: 0, left: leftEdge, bottom: 0, right: leftEdge)
        }
        
        
        return UIEdgeInsets.init()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

extension MainReservationViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        
        let numberOfItems = self.timeCollectionView.numberOfItemsInSection(0)
        
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView)
    {
        let numberOfItems = self.timeCollectionView.numberOfItemsInSection(0)
        
        if numberOfItems > 0
        {
            for i in 0 ..< numberOfItems
            {
                let indexPath = NSIndexPath(forItem: i, inSection: 0)
                let cellSize = self.timeCollectionView.collectionView(self.timeCollectionView, layout: self.timeCollectionView.collectionViewLayout, sizeForItemAtIndexPath: indexPath)
                
                if self.timeCollectionView.offsetForItem(i) + cellSize.width / 2 > self.timeCollectionView.contentOffset.x
                {
                    self.timeCollectionView.selectItem(i, animated: true, notifySelection: true)
                    break
                    //self.timeCollectionView.selectItemAtIndexPath(NSIndexPath(forItem: item, inSection: 0), animated: true, scrollPosition: .None)
                }
                
            }
        }
        
    }

}

