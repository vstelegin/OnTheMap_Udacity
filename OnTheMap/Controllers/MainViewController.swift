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
        refresh()
        
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
    
    @IBAction func refresh(){
        
        ParseAPI.shared.getStudents() {students, error in
            self.performUIUpdatesOnMain {
                DataStorage.shared.students = students!
                (self.viewControllers![1] as! TableViewController).refresh()
                (self.viewControllers![0] as! MapViewController).refresh()
            }
            
        }
        
    }
    
}
