//
//  globals.swift
//  soccer5
//
//  Created by Sebastian Misas on 5/20/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import Foundation
enum FieldType {
    case Field5v5
    case Field6v6
    case Field7v7
    
    func stringValue() -> String {
        switch self {
        case .Field5v5:
            return "5v5"
        case .Field6v6:
            return "6v6"
        case .Field7v7:
            return "7v7"
        }
    }
}