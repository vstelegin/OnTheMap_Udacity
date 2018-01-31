//
//  ParseAPI.swift
//  OnTheMap
//
//  Created by Chase on 28/01/2018.
//  Copyright © 2018 s0w4. All rights reserved.
//

import Foundation

class ParseAPI: Client{
    let parseUrl = "https://parse.udacity.com/parse/classes/StudentLocation"
    let parseKeyHeaders = [
        "X-Parse-Application-Id" : "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr",
        "X-Parse-REST-API-Key" : "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    ]
    static let shared = ParseAPI()
    
    func getStudents( completionHandler: @escaping (_ students: [ParseStudent]?, _ error: String?) -> Void) {
        
        
        let request = prepareRequest(apiMethodURL: parseUrl, parameters: "order=-updatedAt&limit=100", httpMethod: "GET", headers: parseKeyHeaders)
        
        makeRequest(request){jsonData in
            guard let results = jsonData!["results"] as? [[String : AnyObject]] else {
                print ("Bad response")
                completionHandler(nil, "Bad response")
                return
            }
            
            
            var students: [ParseStudent] = []
            
            for student in results {
                students.append(ParseStudent(dictionary: student))
            }
            
            completionHandler(students, nil)
        }
    }
}
