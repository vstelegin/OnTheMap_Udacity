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
                print (user!.firstName)
            }
        }
    }
}
