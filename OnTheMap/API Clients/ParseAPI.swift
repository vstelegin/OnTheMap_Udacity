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
    
    // Singleton
    static let shared = ParseAPI()
    
    // Get last 100 Pars students
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
    
    
    // Check if student's record exists in Parse DB
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
    
    
    // Post new student to the Parse
    func postStudent(_ student: ParseStudent, completionHandler: @escaping (_ error: String?) -> Void ){
        let body = studentToBodyString(student: student)
        let headers = parseKeyHeaders.merging(["Content-Type": "application/json"]) { (current, _) in current }
        let request = prepareRequest(apiMethodURL: parseUrl, httpMethod: "POST", headers: headers, body: body)
        
        makeRequest(request){jsonData in
            guard let results = jsonData!["createdAt"] as? String else {
                completionHandler ("Error posting new student")
                return
            }
            print ("created new record at \(results)")
            completionHandler(nil)
        }
    }
    
    // Update Parse student's info
    func putStudent(_ student: ParseStudent, completionHandler: @escaping (_ error: String?) -> Void){
        let body = studentToBodyString(student: student)
        let headers = parseKeyHeaders.merging(["Content-Type": "application/json"]) { (current, _) in current }
        let request = prepareRequest(apiMethodURL: "\(parseUrl)/\(student.objectId)", httpMethod: "PUT", headers: headers, body: body)
        
        makeRequest(request){jsonData in
            guard let results = jsonData!["updatedAt"] as? String else {
                completionHandler ("Error updating student's location")
                return
            }
            print ("updated at \(results)")
            completionHandler(nil)
        }
    }
    
    // Convert ParseStudent object into String
    func studentToBodyString(student : ParseStudent) -> String {
        let body = "{\"uniqueKey\": \"\(student.uniqueKey)\", \"firstName\": \"\(student.firstName)\", \"lastName\": \"\(student.lastName)\",\"mapString\": \"\(student.mapString)\", \"mediaURL\": \"\(student.mediaUrl)\",\"latitude\": \(student.latitude), \"longitude\": \(student.longitude)}"
        return body
    }
    
    
}

