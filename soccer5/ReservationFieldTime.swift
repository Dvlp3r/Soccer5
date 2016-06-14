//
//  File.swift
//  soccer5
//
//  Created by Jennifer Duffey on 6/12/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import UIKit

struct ReservationFieldTime
{
    var time: String
    var twelveHRSymbol: String
    
    init(time: String, twelveHRSymbol: String)
    {
        self.time = time
        self.twelveHRSymbol = twelveHRSymbol
    }
    
    func getTimeString() -> String
    {
        return "\(self.time) \(self.twelveHRSymbol)"
    }
}