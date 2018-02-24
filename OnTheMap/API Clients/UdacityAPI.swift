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
    static let shared = UdacityAPI()
    
    override func processResponseData(data: Data?) -> Data? {
        return data?.subdata(in: Range(5..<data!.count))
    }
    
    // Get Udacity Session (Login)
    func getSession(username : String, password: String, completionHandler: @escaping (_ error: String?) -> Void){
        
        let headers = [
            "Accept": "application/json",
            "Content-Type": "application/json",
        ]
        let bodyURL = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        let request = prepareRequest(apiMethodURL: sessionURL, httpMethod: "POST", headers: headers, body: bodyURL)
        
        makeRequest(request) {jsonData, errorString in
            
            guard errorString == nil else {
                completionHandler(errorString)
                return
            }
            if let error = jsonData as? [String : AnyObject], let errorMessage = error["error"] as? String {
                completionHandler (errorMessage)
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
            DataStorage.shared.user = UdacityUser(dictionary: ["userId":"\(userID)"])
            completionHandler(nil)
        }
    }
    
    // Delete Udacity Session (Logout)
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
        
        makeRequest(request) {jsonData, errorString in
            guard errorString == nil else{
                completionHandler(errorString)
                return
            }
            completionHandler(nil)
        }
        
    }
    
    // Get Udacity user data with user_id
    func getUser(userId: String, completionHandler: @escaping (_ user: UdacityUser?, _ _error: String?) -> Void){
        let udacityGetUSerURL = "https://www.udacity.com/api/users/"
        let udacityGetCurrentUserURL = udacityGetUSerURL + (DataStorage.shared.user!.userId)
        let request = prepareRequest(apiMethodURL: udacityGetCurrentUserURL, httpMethod: "GET")
        makeRequest(request){jsonData, errorString in
            guard errorString == nil else{
                completionHandler(nil, errorString)
                return
            }
            guard let userData = jsonData!["user"] as? [String : AnyObject] else {
                print ("No user data in response")
                return
            }
            guard let firstName = userData["first_name"] as? String, let lastName = userData["last_name"] as? String else {
                print ("No user's firstname or lastname in response")
                return
            }
            let user = UdacityUser(dictionary: [
                "userId": userId,
                "firstName": firstName,
                "lastName": lastName
                ])
            completionHandler(user, nil)
        }
   
    }
}
