//
//  WebService.swift
//  soccer5
//
//  Created by Sebastian Misas on 5/19/16.
//  Copyright © 2016 Dvlper. All rights reserved.
//

import Foundation
import Alamofire

enum APIType {
    case User
    case Reservation
    case Location
    
    func stringValue() -> String {
        switch self {
        case .User:
            return "users"
        case .Reservation:
            return "deals"
        case .Location:
            return "merchants"
        }
    }
}

class WebService {
    
    class func postAt(
        url:String,
        parameters: [String: AnyObject]?,
        successBlock:((response:AnyObject?) -> Void),
        failureBlock:((message:String) -> Void)) {
        
        print("Initiated Post request at " + url)
        
        Alamofire.request(
            Method.POST,
            url,
            parameters: parameters,
            encoding: .JSON)
            .responseJSON {
                (response) -> Void in
                
                let headers = response.response?.allHeaderFields
                let errorMsg = headers?["errorMessage"]
                
                guard let code = response.response?.statusCode else {
                    failureBlock(message: "No connection")
                    return
                }
                guard code == 200 else {
                    print(code)
                    switch code {
                    case 401:
                        print(401)
                        successBlock(response: response.result.value)
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
    
    class func putAt(
        url:String,
        parameters: [String: AnyObject]? = nil,
        successBlock:((response:AnyObject?) -> Void),
        failureBlock:((message:String) -> Void)) {
        
        print("Initiated Put request at " + url)
        
        Alamofire.request(
            .PUT,
            url,
            parameters: parameters,
            encoding: .JSON
            ).responseJSON {
                (response) -> Void in
                
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                let statusCode = response.response?.statusCode
                print(response)
                guard statusCode == 200 else {
                    failureBlock(message: "Invalid HTTP response")
                    return
                }
                
                if let httpError = response.result.error {
                    failureBlock(message: "Serialization Error! \(httpError.code)")
                    return
                }
                
                successBlock(response: response.result.value)
            }.responseString { (response) -> Void in
                print("response")
        }
        
    }
    
    class func getAt(url:String, parameters: [String: AnyObject]? = nil,
                     successBlock:((response:AnyObject?) -> Void),
                     failureBlock:((message:String) -> Void))
    {
        print(url)
        Alamofire.request(
            Method.GET,
            url,
            parameters: parameters,
            encoding: .JSON)
            .responseJSON {
                (response) -> Void in
                print(response)
                
                guard let code = response.response?.statusCode else {
                    failureBlock(message: "No connection")
                    return
                }
                
                let headers = response.response?.allHeaderFields
                let errorMsg = headers?["errorMessage"]
                
                guard code == 200 else {
                    print(code)
                    switch code {
                    case 401:
                        print(401)
                        successBlock(response: response.result.value)
                    case 417:
                        failureBlock(message: (errorMsg as! String))
                    default:
                        failureBlock(message: "Invalid HTTP response")
                    }
                    return
                }
                
                
                successBlock(response: response.result.value)
        }
    }
    
    class func deleteAt(url:String, parameters: [String: AnyObject]? = nil,
                        successBlock:((response:AnyObject?) -> Void),
                        failureBlock:((message:String) -> Void))
    {
        print(url)
        Alamofire.request( Method.DELETE, url, parameters: parameters, encoding: .JSON)
            .responseJSON {
                (response) -> Void in
                print(response)
                
                guard let code = response.response?.statusCode else {
                    failureBlock(message: "No connection")
                    return
                }
                
                let headers = response.response?.allHeaderFields
                let errorMsg = headers?["errorMessage"]
                
                guard code == 200 else {
                    print(code)
                    switch code {
                    case 401:
                        print(401)
                        successBlock(response: response.result.value)
                    case 417:
                        failureBlock(message: (errorMsg as! String))
                    default:
                        failureBlock(message: "Invalid HTTP response")
                    }
                    return
                }
                
                
                successBlock(response: response.result.value)
        }
    }
    
}