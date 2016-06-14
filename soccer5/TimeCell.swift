//
//  TimeCell.swift
//  soccer5
//
//  Created by Jennifer Duffey on 6/13/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import UIKit

class TimeCell: UICollectionViewCell
{
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var timeSymbol: UILabel!
    @IBOutlet var verticalLine: UIView!
    
    var reservationTime: ReservationFieldTime?
    {
        didSet
        {
            self.timeLabel.text = reservationTime?.time
            self.timeSymbol.text = reservationTime?.twelveHRSymbol
        }
    }
    
    override var selected: Bool
    {
        didSet
        {
            //self.verticalLine.hidden = (selected == true)
            
            if selected == true
            {
                self.timeLabel.textColor = UIColor.whiteColor()
            }
            else
            {
                self.timeLabel.textColor = UIColor.lightGrayColor()
            }
        }
        
    }
    
}
