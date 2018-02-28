//
//  UdacityUser.swift
//  OnTheMap
//
//  Created by Chase on 27/02/2018.
//  Copyright © 2018 s0w4. All rights reserved.
//

import Foundation

struct UdacityUser {
    var userId: String
    var firstName: String
    var lastName: String
    init(dictionary: [String: String] = [:]) {
        userId = dictionary["userId"] ?? ""
        firstName = dictionary["firstName"] ?? ""
        lastName = dictionary["lastName"] ?? ""
    }
}
