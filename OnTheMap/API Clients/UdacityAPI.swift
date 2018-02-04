//
//  UdacityAPI.swift
//  OnTheMap
//
//  Created by Chase on 20/01/2018.
//  Copyright © 2018 s0w4. All rights reserved.
//

//import Foundation
import UIKit

class UdacityAPI: Client{
    

    let sessionURL = "https://www.udacity.com/api/session"
    
    //let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func processResponseData(data: Data?) -> Data? {
        return data?.subdata(in: Range(5..<data!.count))
    }
    
    func getSession(username : String, password: String, completionHandler: @escaping (_ error: String?) -> Void){
        
        let headers = [
            "Accept": "application/json",
            "Content-Type": "application/json",
        ]
        let bodyURL = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        let request = prepareRequest(apiMethodURL: sessionURL, httpMethod: "POST", headers: headers, body: bodyURL)
        
        makeRequest(request) {jsonData in
            
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
            DataStorage.shared.sessionID = sessionID
            DataStorage.shared.userID = userID
            
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
    
    
    class func sharedInstance() -> UdacityAPI {
        struct Singleton {
            static var sharedInstance = UdacityAPI()
        }
        return Singleton.sharedInstance
    }
    
}
