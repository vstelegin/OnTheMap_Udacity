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
        self.usernameTextField.delegate = self as? UITextFieldDelegate
        self.passwordTextField.delegate = self as? UITextFieldDelegate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginPressed() {
        loginHideKeyboard()
        if usernameTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            infoLabel.text = "Username or Password is Empty"
        } else {
            UdacityAPI.sharedInstance().getSession(username: usernameTextField.text!, password: passwordTextField.text!) {error in
                    self.infoLabel.text = error
            }
        }
    }
    
    @IBAction func logoutPressed() {
        UdacityAPI.sharedInstance().deleteSession()
    }
    
    
    func textFieldShouldReturn(_ textField : UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    private func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    private func loginHideKeyboard() {
        resignIfFirstResponder(usernameTextField)
        resignIfFirstResponder(passwordTextField)
    }
    
    @IBAction func userDidTapView(_ sender: AnyObject){
        loginHideKeyboard()
    }
  

}

