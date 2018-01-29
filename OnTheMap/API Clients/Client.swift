//
//  Client.swift
//  OnTheMap
//
//  Created by Chase on 28/01/2018.
//  Copyright © 2018 s0w4. All rights reserved.
//

import Foundation

class Client{
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

            completionHandler(jsonData)
            
        }
        task.resume()
    }
    
}
