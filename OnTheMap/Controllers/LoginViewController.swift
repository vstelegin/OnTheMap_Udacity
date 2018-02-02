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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.usernameTextField.delegate = self as? UITextFieldDelegate
        self.passwordTextField.delegate = self as? UITextFieldDelegate
        usernameTextField.textContentType = .username
        passwordTextField.textContentType = .password
        
        usernameTextField.text = "vstelegin@gmail.com"
        passwordTextField.text = "Hdv-4Jb-wtV-Q7o"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginPressed() {
        
        
        loginHideKeyboard()
        
        guard !usernameTextField.text!.isEmpty || !passwordTextField.text!.isEmpty else {
            performUIUpdatesOnMain {
                self.showErrorAlert(message: "Username or Password is Empty")
            }
            return
        }
        
        
        LoadingIndicatorOverlay.shared.showIndicator(view)
        
        UdacityAPI.sharedInstance().getSession(username: usernameTextField.text!, password: passwordTextField.text!) {result in
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

