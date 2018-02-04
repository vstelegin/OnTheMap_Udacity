//
//  DataStorage.swift
//  OnTheMap
//
//  Created by Chase on 28/01/2018.
//  Copyright © 2018 s0w4. All rights reserved.
//

import Foundation

class DataStorage {
    var sessionID: String? = nil
    var userID : String? = nil
    //var user: UdacityUser? = nil
    var student: ParseStudent? = nil
    var students: [ParseStudent] = [ParseStudent]()
    
    class var shared: DataStorage {
        struct Static {
            static let instance: DataStorage = DataStorage()
        }
        return Static.instance
    }
}
/*
struct UdacityUser {
    var id: String = ""
    var firstName: String = ""
    var lastName: String = ""

    init(dictionary: [String: AnyObject]) {
        id = dictionary["id"] as! String
        firstName = dictionary["firstName"] as! String
        lastName = dictionary["lastName"] as! String
    }
}
*/
struct ParseStudent {
    var objectId: String
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaUrl: String
    var latitude: Double
    var longitude: Double
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    init(_ dictionary: [String: AnyObject]) {
        let defaultValue = "n/a"
        objectId = dictionary["objectId"] as! String!
        uniqueKey = dictionary["uniqueKey"] as? String ?? defaultValue
        firstName = dictionary["firstName"] as? String ?? defaultValue
        lastName = dictionary["lastName"] as? String ?? defaultValue
        mapString = dictionary["mapString"] as? String ?? defaultValue
        mediaUrl = dictionary["mediaURL"] as? String ?? defaultValue
        latitude = dictionary["latitude"] as? Double ?? 0
        longitude = dictionary["longitude"] as? Double ?? 0
    }
}
