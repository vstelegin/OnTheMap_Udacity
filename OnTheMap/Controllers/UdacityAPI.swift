//
//  UdacityAPI.swift
//  OnTheMap
//
//  Created by Chase on 20/01/2018.
//  Copyright © 2018 s0w4. All rights reserved.
//

//import Foundation
import UIKit

class UdacityAPI {
    
    //var sessionID: String? = nil
    //var userID: String? = nil
    let sessionURL = "https://www.udacity.com/api/session"
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func getSession(username : String, password: String, completionHandler: @escaping (_ error: String?) -> Void){
        
        let headers = [
            "Accept": "application/json",
            "Content-Type": "application/json",
        ]
        let bodyURL = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        let request = prepareRequest(apiMethodURL: sessionURL, httpMethod: "POST", headers: headers, body: bodyURL)
        
        makeRequest(request) {jsonData in
            
            guard jsonData != nil else{
                completionHandler("Wrong server responce")
                return
            }
            if let error = jsonData as? [String : AnyObject], let errorMessage = error["error"] as? String {
                completionHandler (errorMessage)
                print (errorMessage)
                return
            }
            
            guard let account = jsonData!["account"] as? [String: AnyObject], let userID = account["key"] as? String else {
                return
            }
            
            
            guard let session = jsonData!["session"] as? [String: AnyObject], let sessionID = session["id"] as? String else {
                return
            }
            
            self.appDelegate.sessionID = sessionID
            self.appDelegate.userID = userID
            
            completionHandler(nil)
        }
        
    }
    
    func deleteSession(completionHandler: @escaping (_ error: String?) -> Void) {
        var request = prepareRequest(apiMethodURL: sessionURL, httpMethod: "DELETE")
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie}
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        makeRequest(request) {jsonData in
            completionHandler(nil)
        }
        
    }
    func prepareRequest(apiMethodURL: String, httpMethod: String, headers: [String:String]? = nil, body: String? = nil) -> URLRequest{
        var request = URLRequest(url: URL(string: apiMethodURL)!)
        request.httpMethod = httpMethod
            if headers != nil {
                for (header, value) in headers! {
                    request.addValue(value, forHTTPHeaderField: header)
                }
            }
        if body != nil {
            request.httpBody = body?.data(using: .utf8)
        }
        return request
    }
    
    func makeRequest(_ request : URLRequest, completionHandler:  @escaping (_ jsonData: AnyObject?) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            if error != nil {
                print ("Connection error")
                return
            }
            
            guard let data = data else {
                return
            }
            
            // Remove first 5 characters
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            let newDataString = String(data: newData, encoding: .utf8)
            print (newDataString!)
            
            // Parse data
            let jsonData: AnyObject!
            do {
                jsonData = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
            } catch {
                print ("JSON conversion error")
                completionHandler(nil)
                return
            }
            /*
            if let error = jsonData as? [String : AnyObject], let errorMessage = error["error"] as? String {
                    completionHandler (errorMessage)
                    print (errorMessage)
                    return
            }
            guard let account = jsonData["account"] as? [String: AnyObject], let userID = account["key"] as? String else {
                return
            }
            
            guard let session = jsonData["session"] as? [String: AnyObject], let sessionID = session["id"] as? String else {
                return
            }
            */
            //self.appDelegate.sessionID = sessionID
            //self.appDelegate.userID = userID
          
            completionHandler(jsonData)
            
        }
        task.resume()
    }
    
    class func sharedInstance() -> UdacityAPI {
        struct Singleton {
            static var sharedInstance = UdacityAPI()
        }
        return Singleton.sharedInstance
    }
    
}
