//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Chase on 05/02/2018.
//  Copyright © 2018 s0w4. All rights reserved.
//

import UIKit
import MapKit

class InfoPostingInputViewController: UIViewController, UITextFieldDelegate{
    var mapString : String?
    var coordinate : CLLocationCoordinate2D?
    @IBOutlet weak var mapStringTextField : UITextField!
    @IBOutlet weak var mediaURLTextField : UITextField!
    
    // Read Location and URL from user's input, then present next map view controller
    @IBAction func findLocation(){
        guard let mapString = mapStringTextField?.text , mapString != "" else{
            showErrorAlert(message: "Wrong location")
            return
        }
        guard let mediaURL = mediaURLTextField.text, mediaURL != "" else{
            showErrorAlert(message: "Wrong URL")
            return
        }
        DataStorage.shared.student!.mediaUrl = mediaURL
        LoadingIndicatorOverlay.shared.showIndicator(view)
        CLGeocoder().geocodeAddressString(mapString){location, error in
            LoadingIndicatorOverlay.shared.hideIndicator()
            guard error == nil else{
                self.showErrorAlert(message: "Error finding location")
                return
            }
            self.mapString = mapString
            self.coordinate = location!.first!.location!.coordinate
            self.performSegue(withIdentifier: "ShowLocationMap", sender: self.coordinate)
        }
    }
    
    // Prepare segue to cast coordinate to the next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let infoPostingMap = segue.destination as? InfoPostingMapViewController {
            infoPostingMap.coordinate = sender as? CLLocationCoordinate2D
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        mapStringTextField.delegate = self
        mediaURLTextField.delegate = self
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == mapStringTextField {
            textField.resignFirstResponder()
            mediaURLTextField.becomeFirstResponder()
        }
        else {
            findLocation()
        }
        return true
    }
    
    @IBAction func userDidTapView(){
        HideKeyboard(view)
    }
}
    

