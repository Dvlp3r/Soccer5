//
//  WebService.swift
//  soccer5
//
//  Created by Sebastian Misas on 5/19/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

let BaseURL = "https://soccer5api.herokuapp.com"

enum APIType {
    case User
    case Reservation
    case Location
    
    func stringValue() -> String {
        switch self {
        case .User:
            return "users"
        case .Reservation:
            return "Reservation"
        case .Location:
            return "Location"
        }
    }
}




class WebService {
    
    
    class func send(
        method: Alamofire.Method,
        atURL url:String,
        headers: [String : String]?,
        parameters: [String: AnyObject]?,
        successBlock:((response:AnyObject?) -> Void),
        failureBlock:((message:String) -> Void)) {
        
        print("Initiated request at " + url)
       
        Alamofire.request(
            method,
            url,
            headers: headers,
            parameters: parameters,
            encoding: .JSON)
            .responseJSON {
                (response) -> Void in
                
                let headers = response.response?.allHeaderFields
                let errorMsg = headers?["errorMessage"]
                if headers != nil {
                    let jsonHeaders = JSON(headers!)
                    var headerFields = HeaderFields()
                    if jsonHeaders["Access-Token"] != nil {
                        headerFields.access_token = jsonHeaders["Access-Token"].string!
                        headerFields.client = jsonHeaders["Client"].string!
                        headerFields.expiry = jsonHeaders["Expiry"].string!
                        headerFields.token_type = jsonHeaders["Token-Type"].string!
                        headerFields.uid = jsonHeaders["Uid"].string!
                    }
                    returnHeaders = [
                        "access-token": headerFields.access_token,
                        "client": headerFields.client,
                        "expiry": headerFields.expiry,
                        "token-type": headerFields.token_type,
                        "uid": headerFields.uid
                    ]
                    
                } else {
                    print("No headers from request")
                }
                
                
                

                guard let code = response.response?.statusCode else {
                    failureBlock(message: "No connection")
                    print(response.response?.statusCode)
                    return
                }

                guard code == 200 else {
                    print(code)
                    switch code {
                    case 401:
                        failureBlock(message: String(code))
                    case 417:
                        failureBlock(message: (errorMsg as! String))
                    default:
                        failureBlock(message: "Invalid HTTP response")
                    }
                    return
                }
                
                if let httpError = response.result.error {
                    failureBlock(message: "Serialization Error! \(httpError.code)")
                    return
                }
                
                successBlock(response: response.result.value)
        }
    }
}