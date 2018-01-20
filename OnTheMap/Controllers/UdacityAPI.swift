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
    
    func getSession(username : String, password: String){
        let headers = [
            "Accept": "application/json",
            "Content-Type": "application/json",
        ]
        let bodyURL = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}"
        let request = prepareRequest(apiMethodURL: "https://www.udacity.com/api/session", httpMethod: "POST", headers: headers, body: bodyURL)
        makeRequest(request)
    }
    
    func deleteSession(userID : String) {
        
    }
    func prepareRequest(apiMethodURL: String, httpMethod: String, headers: [String:String]?, body: String?) -> URLRequest{
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
    
    func makeRequest(_ request : URLRequest){
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
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
