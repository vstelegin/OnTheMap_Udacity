//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Chase on 31/01/2018.
//  Copyright © 2018 s0w4. All rights reserved.
//

import Foundation
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate{
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
    }
    
    func getStudentCoordinate(_ student: ParseStudent) -> CLLocationCoordinate2D{
        let lat = CLLocationDegrees(student.latitude)
        let long = CLLocationDegrees(student.longitude)
        let coordinate = CLLocationCoordinate2D (latitude: lat, longitude: long)
        return coordinate
    }
    
    func refresh() {
        mapView.removeAnnotations(mapView.annotations)
        var annotations = [MKPointAnnotation]()
        for student in DataStorage.shared.students{
            let annotation = MKPointAnnotation()
            annotation.coordinate = getStudentCoordinate(student)
            annotation.title = student.fullName
            annotation.subtitle = student.mediaUrl
            annotations.append(annotation)
        }
        self.mapView.addAnnotations(annotations)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationId = "annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationId)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationId)
            annotationView!.canShowCallout = true
            annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            openUrl((view.annotation?.subtitle!)!)
        }
    }
    
}
