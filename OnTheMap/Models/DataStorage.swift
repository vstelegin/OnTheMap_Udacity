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
    var user: UdacityUser? = nil
    var student : ParseStudent? = nil
    var students : [ParseStudent] = [ParseStudent]()
    
    class var shared: DataStorage {
        struct Static {
            static let instance: DataStorage = DataStorage()
        }
        return Static.instance
    }
}
