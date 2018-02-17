//
//  UIViewControllerExtension.swift
//  OnTheMap
//
//  Created by Chase on 24/01/2018.
//  Copyright © 2018 s0w4. All rights reserved.
//

import UIKit

extension UIViewController{
    
    @IBAction func cancel(){
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func showErrorAlert(message: String, dismissButtonTitle: String = "Dismiss"){
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: dismissButtonTitle, style: UIAlertActionStyle.cancel){
            action in alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(dismissAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showConfirmationAlert(message: String, dismissButtonTitle: String = "Cancel", actionButtonTitle : String = "OK", handler: @escaping ((UIAlertAction!) -> Void)){
        let controller = UIAlertController(title: "", message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: dismissButtonTitle, style: .default){
            (action: UIAlertAction!) in
            controller.dismiss(animated: true, completion: nil)
        })
        controller.addAction(UIAlertAction(title: actionButtonTitle, style: .default, handler: handler))
        self.present(controller, animated: true, completion: nil)
    }
    
    func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
    }
    
    func presentViewControllerWithIdentifier(controller: UIViewController, identifier: String, animated: Bool = true, completion: (() -> Void)? = nil) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controllerToPresent = storyboard.instantiateViewController(withIdentifier: identifier)
        present(controllerToPresent, animated: animated, completion: completion)
    }
    
    func openUrl (_ url: String){
        let validURL = url.contains("http") ? url : "http://\(url)"
        let escapedURL = validURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let app = UIApplication.shared
        if let escapedURL = URL(string: escapedURL), app.canOpenURL(escapedURL){
            app.open(escapedURL)
        }
        else {
            showErrorAlert(message: "Bad URL...")
        }
    }
    
}
