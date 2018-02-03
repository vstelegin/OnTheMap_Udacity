//
//  UIViewControllerExtension.swift
//  OnTheMap
//
//  Created by Chase on 24/01/2018.
//  Copyright © 2018 s0w4. All rights reserved.
//

import UIKit

extension UIViewController{
    
    func showErrorAlert(message: String, dismissButtonTitle: String = "Dismiss"){
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: dismissButtonTitle, style: UIAlertActionStyle.cancel){
            action in alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(dismissAction)
        self.present(alertController, animated: true, completion: nil)
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
        let app = UIApplication.shared
        if let url = URL(string: url), app.canOpenURL(url){
            app.open(url)
        }
        else {
            showErrorAlert(message: "Bad URL...")
        }
    }
}
