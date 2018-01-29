//
//  MainViewController.swift
//  OnTheMap
//
//  Created by Chase on 25/01/2018.
//  Copyright © 2018 s0w4. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ParseAPI.shared.getStudents() {students, error in
            DataStorage.shared.students = students!
        }
    }
    
    @IBAction func logoutPressed() {
        UdacityAPI.sharedInstance().deleteSession(){ error in
            
            guard error == nil else{
                self.performUIUpdatesOnMain {
                    self.showErrorAlert(message: error!)
                }
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
