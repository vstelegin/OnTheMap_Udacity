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
    var parseKeyHeaders = [
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
                students.append(ParseStudent(student))
            }
            completionHandler(students, nil)
        }
    }
    
    func checkStudent(_ uniqueKey: String, completionHandler: @escaping (_ student: ParseStudent?, _ error: String?) -> Void){
        let parameters = ("where={\"uniqueKey\":\"\(uniqueKey)\"}").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let request = prepareRequest(apiMethodURL: parseUrl, parameters: parameters!, httpMethod: "GET", headers: parseKeyHeaders)
        
        makeRequest(request){jsonData in
            guard let results = jsonData!["results"] as? [[String : AnyObject]] else {
                print ("Bad response")
                completionHandler(nil, "Bad response")
                return
            }
            if let student = results.first {
                completionHandler(ParseStudent(student), nil)
            }
            else{
                
                completionHandler(nil, nil)
            }
        }
    }
    
    func postStudent(_ student: ParseStudent, completionHandler: (_ error: String?) -> Void ){
        let body = "{\"uniqueKey\": \"\(student.uniqueKey)\", \"firstName\": \"\(student.firstName)\", \"lastName\": \"\(student.lastName)\",\"mapString\": \"\(student.mapString)\", \"mediaURL\": \"\(student.mediaUrl)\",\"latitude\": \(student.latitude), \"longitude\": \(student.longitude)}"
        let headers = parseKeyHeaders.merging(["Content-Type": "application/json"]) { (current, _) in current }
        let request = prepareRequest(apiMethodURL: parseUrl, httpMethod: "POST", headers: headers, body: body)
        
        makeRequest(request){jsonData in
            guard let results = jsonData!["createdAt"] as? String else {
                print ("Error posting new student")
                return
            }
            print (results)
        }
        
    }
}

