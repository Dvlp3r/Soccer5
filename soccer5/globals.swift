//
//  globals.swift
//  soccer5
//
//  Created by Sebastian Misas on 5/20/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import Foundation
import FBSDKLoginKit

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

func isAFacbookUser() -> Bool{
    if FBSDKAccessToken.currentAccessToken() == nil {
        return false
    } else{
        return true
    }
    
}

struct ChatMessage {
    var name: String!
    var message: String!
    var image: UIImage?
    var senderID : String!
    
}

class ErrorHandler {
    
    class func displayAlert(title: String, message: String, okAction: ((UIAlertAction)->Void)?) {
        if let topController = UIApplication.topViewController() {
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: okAction)
            alertController.addAction(okAction)
            
            topController.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}

