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
    
    // Logout
    @IBAction func logout() {
        LoadingIndicatorOverlay.shared.showIndicator(view)
        UdacityAPI.shared.deleteSession(){ error in
            guard error == nil else{
                self.performUIUpdatesOnMain {
                    LoadingIndicatorOverlay.shared.hideIndicator()
                    self.showErrorAlert(message: error!)
                }
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // Open Information Posting View
    @IBAction func setLocation(){
        LoadingIndicatorOverlay.shared.showIndicator(view)
        ParseAPI.shared.checkStudent(DataStorage.shared.userID!){student, error in
            self.performUIUpdatesOnMain {
                LoadingIndicatorOverlay.shared.hideIndicator()
                guard error == nil else {
                    self.showErrorAlert(message: error!)
                    return
                }
                DataStorage.shared.student = student
                if student == nil {
                    self.presentViewControllerWithIdentifier(controller: self, identifier: "pin")
                }
                else {
                    self.showConfirmationAlert(message: "\(student!.fullName) already exists.", dismissButtonTitle: "Cancel", actionButtonTitle: "Overwrite"){ (action) in
                            self.presentViewControllerWithIdentifier(controller: self, identifier: "InfoPosting")
                    }
                }
            }
        }
    }
    
    // Refresh data from server
    @IBAction func refresh(){
        LoadingIndicatorOverlay.shared.showIndicator(view)
        ParseAPI.shared.getStudents() {students, error in
            
            self.performUIUpdatesOnMain {
                LoadingIndicatorOverlay.shared.hideIndicator()
                guard error == nil else{
                    self.showErrorAlert(message: error!)
                    return
                }
                DataStorage.shared.students = students!
                (self.viewControllers![0] as! MapViewController).refresh() // Refresh Map View
                (self.viewControllers![1] as! TableViewController).refresh() // Refresh Table View
            }
        }
    }
}
