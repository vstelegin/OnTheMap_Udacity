//
//  Client.swift
//  OnTheMap
//
//  Created by Chase on 28/01/2018.
//  Copyright © 2018 s0w4. All rights reserved.
//

import Foundation

class Client{
    
    func prepareRequest(apiMethodURL: String, parameters: String = "", httpMethod: String, headers: [String:String]? = nil, body: String? = nil) -> URLRequest{
        var apiMethodURL = apiMethodURL
        
        if parameters != "" {
            apiMethodURL += "?" + parameters
        }
        
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
    
    func makeRequest(_ request : URLRequest, _ completionHandler:  @escaping (_ jsonData: AnyObject?) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            if error != nil {
                print ("Connection error")
                return
            }
            
            guard let data = self.processResponseData(data: data) else {
                print("Bad response data")
                completionHandler(nil)
                return
            }
            
            print(String(data: data, encoding: .utf8)!)
            // Parse data
            let jsonData: AnyObject!
            do {
                jsonData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            } catch {
                print ("JSON conversion error")
                completionHandler(nil)
                return
            }

            completionHandler(jsonData)
            
        }
        task.resume()
    }
    
    func processResponseData(data: Data?) -> Data? {
        return data!
    }
    
}
