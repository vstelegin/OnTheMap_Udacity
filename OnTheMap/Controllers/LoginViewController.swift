//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Chase on 31/10/2017.
//  Copyright © 2018 s0w4. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginPressed() {
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            infoLabel.text = "Username or Password is Empty"
        } else {
            UdacityAPI.sharedInstance().getSession(username: usernameTextField.text!, password: passwordTextField.text!)
        }
    }
    
    @IBAction func logoutPressed() {
        UdacityAPI.sharedInstance().deleteSession()
    }
    
    func setInfoLabel (infoString : String){
        infoLabel.text = infoString
    }
    
    private func getRequestToken(){
        
    }

}

