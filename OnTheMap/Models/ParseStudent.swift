//
//  ParseStudent.swift
//  OnTheMap
//
//  Created by Chase on 27/02/2018.
//  Copyright © 2018 s0w4. All rights reserved.
//

import Foundation

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
        objectId = dictionary["objectId"] as? String ?? defaultValue
        uniqueKey = dictionary["uniqueKey"] as? String ?? defaultValue
        firstName = dictionary["firstName"] as? String ?? defaultValue
        lastName = dictionary["lastName"] as? String ?? defaultValue
        mapString = dictionary["mapString"] as? String ?? defaultValue
        mediaUrl = dictionary["mediaURL"] as? String ?? defaultValue
        latitude = dictionary["latitude"] as? Double ?? 0
        longitude = dictionary["longitude"] as? Double ?? 0
    }
}
