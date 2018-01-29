//
//  DataStorage.swift
//  OnTheMap
//
//  Created by Chase on 28/01/2018.
//  Copyright © 2018 s0w4. All rights reserved.
//

import Foundation


struct UdacityUser {
    var id: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    init(dictionary: [String: AnyObject]) {
        id = dictionary["id"] as! String
        firstName = dictionary["firstName"] as! String
        lastName = dictionary["lastName"] as! String
    }
}

struct ParseStudent {
    var objectId: String
    var uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaUrl: String
    var latitude: Double
    var longitude: Double
    
    init(dictionary: [String: AnyObject]) {
        objectId = dictionary["objectId"] as! String!
        uniqueKey = dictionary["uniqueKey"] as! String!
        firstName = dictionary["firstName"] as! String!
        lastName = dictionary["lastName"] as! String!
        mapString = dictionary["mapString"] as! String!
        mediaUrl = dictionary["mediaURL"] as! String!
        latitude = dictionary["latitude"] as! Double
        longitude = dictionary["longitude"] as! Double
    }
}
