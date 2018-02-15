//
//  InfoPostingMapViewController.swift
//  OnTheMap
//
//  Created by Chase on 08/02/2018.
//  Copyright © 2018 s0w4. All rights reserved.
//

import UIKit
import MapKit

class InfoPostingMapViewController : UIViewController{
    var coordinate : CLLocationCoordinate2D?
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setPin(coordinate!)
    }
    
    func setPin(_ coordinate: CLLocationCoordinate2D){
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "My location"
        
        let region = MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.01, 0.01))
        performUIUpdatesOnMain {
            self.mapView.addAnnotation(annotation)
            self.mapView.setRegion(region, animated: true)
            self.mapView.regionThatFits(region)
        }
    }
    
    @IBAction func finish(){
        LoadingIndicatorOverlay.shared.showIndicator(view)
        UdacityAPI.sharedInstance().getUser(userId: DataStorage.shared.userID!){user,error in
            self.performUIUpdatesOnMain {
                LoadingIndicatorOverlay.shared.hideIndicator()
                
            }
            
            var student = ParseStudent([
                "firstName": user!.firstName as AnyObject,
                "lastName": user!.lastName as AnyObject,
                "latitude": Double(self.coordinate!.latitude) as AnyObject,
                "longitude": Double(self.coordinate!.longitude) as AnyObject,
                "mediaURL": "link" as AnyObject,
                "mapString": "location" as AnyObject,
                "uniqueKey": user!.userId as AnyObject,
                "objectId": "" as AnyObject])
            if DataStorage.shared.student == nil {
                ParseAPI.shared.postStudent(student, completionHandler: self.finishHandler)
            } else {
                print ("ObjectID: \(DataStorage.shared.student!.objectId)")
                student.objectId = DataStorage.shared.student!.objectId
                ParseAPI.shared.putStudent(student, completionHandler: self.finishHandler)
            }
        }
    }
    
    func finishHandler(error: String?){
        performUIUpdatesOnMain {
            print ("HANDLER")
            LoadingIndicatorOverlay.shared.hideIndicator()
            guard error == nil else {
                self.showErrorAlert(message: error!)
                return
            }
            
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
        
    }
}
