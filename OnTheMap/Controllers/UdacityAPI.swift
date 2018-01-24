//
//  UdacityAPI.swift
//  OnTheMap
//
//  Created by Chase on 20/01/2018.
//  Copyright © 2018 s0w4. All rights reserved.
//

import Foundation

class UdacityAPI {
    
    var sessionID: String? = nil
    var userID: String? = nil
    let sessionURL = "https://www.udacity.com/api/session"
    
    func getSession(username : String, password: String, completionHandler: @escaping (_ error: String?) -> Void){
        
        let headers = [
            "Accept": "application/json",
            "Content-Type": "application/json",
        ]
        let bodyURL = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        let request = prepareRequest(apiMethodURL: sessionURL, httpMethod: "POST", headers: headers, body: bodyURL)
        //completionHandler("deep ok0")
        
        makeRequest(request) {error in
            completionHandler(error)
        }
        
    }
    
    func deleteSession() {
        var request = prepareRequest(apiMethodURL: sessionURL, httpMethod: "DELETE")
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie}
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        makeRequest(request) {_ in}
        
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
    
    func makeRequest(_ request : URLRequest, completionHandler:  @escaping (_ error: String?) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            if error != nil { // Handle error…
                return
            }
            
            if let data = data {
                DispatchQueue.main.async {
                    let range = Range(5..<data.count)
                    let newData = data.subdata(in: range) /* subset response data! */
                    let newDataString = String(data: newData, encoding: .utf8)!
                    print (newDataString)
                    completionHandler (newDataString)
                }
            }
            
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
