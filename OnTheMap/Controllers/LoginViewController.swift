//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Chase on 31/10/2017.
//  Copyright © 2018 s0w4. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        usernameTextField.textContentType = .username
        passwordTextField.textContentType = .password
    }

    // Login button
    @IBAction func loginPressed() {
        guard !usernameTextField.text!.isEmpty || !passwordTextField.text!.isEmpty else {
            performUIUpdatesOnMain {
                self.showErrorAlert(message: "Username or Password is Empty")
            }
            return
        }
        LoadingIndicatorOverlay.shared.showIndicator(view)
        UdacityAPI.shared.getSession(username: usernameTextField.text!, password: passwordTextField.text!) {result in
            self.performUIUpdatesOnMain {
                
                guard result == nil else{
                    self.showErrorAlert(message: result!)
                    LoadingIndicatorOverlay.shared.hideIndicator()
                    return
                }
                self.presentViewControllerWithIdentifier(controller: self, identifier: "NavigationController")
                LoadingIndicatorOverlay.shared.hideIndicator()
            }
        }
    }
    
    // Signup button
    @IBAction func signupPressed() {
        UIApplication.shared.open(URL(string: "https://auth.udacity.com/sign-up")!, completionHandler: nil)
    }
    
    // Handle keyboard issues
    func textFieldShouldReturn(_ textField : UITextField) -> Bool {
        if textField == usernameTextField {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        }
        else {
            loginPressed()
        }
        return true
    }
    @IBAction func userDidTapView(){
        HideKeyboard(view)
    }
  

}

