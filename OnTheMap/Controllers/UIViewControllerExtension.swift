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
        let controllerToPresent = controller.storyboard!.instantiateViewController(withIdentifier: identifier)
        present(controllerToPresent, animated: animated, completion: completion)
    }
}
