//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Fabiana Petrovick on 26/04/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listStudents()
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func addStudentsToMap(locations: [Map]) {
        var annotations = [MKPointAnnotation]()
        
        for map in locations {
            
            
            let lat = CLLocationDegrees(map.latitude as! Double)
            let long = CLLocationDegrees(map.longitude as! Double)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = map.firstName as! String
            let last = map.lastName as! String
            let mediaURL = map.mediaURL as! String
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            annotations.append(annotation)
        }
        
        self.mapView.addAnnotations(annotations)
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
    //        func mapViewList(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    //
    //            if control == annotationView.rightCalloutAccessoryView {
    //                let app = UIApplication.shared
    //                app.openURL(NSURL(string: (annotationView.annotation?.subtitle!!)!)! as URL)
    //            }
    //        }
    
    // MARK: - Sample Data
    
    func listStudents() {
        OTMUser.getStudentLocation(completion: handleStudentResponse(maps:success:error:))
    }
    
    func handleStudentResponse(maps: [Map], success: Bool, error: Error?) {
        addStudentsToMap(locations: maps)
    }
    
    func hardCodedLocationData() -> [[String : Any]] {
        return []
    }
    
    @IBAction func editingLocation() {

    let alert = UIAlertController(title: "UIAlertController", message: "Would you like to continue learning how to use iOS alerts?", preferredStyle: UIAlertController.Style.alert)

        alert.addAction((UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            self.performSegue(withIdentifier: "Location", sender: nil)
        })))
    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

    self.present(alert, animated: true, completion: nil)
    }
//
//    func editing(getUserResponse: GetUserResponse?, error: Error?) {
//        if GetUserResponse.CodingKeys.lastName != nil {
//                self.performSegue(withIdentifier: "Location", sender: nil)
////               } else { //valida email e senha
////                   showEditingFailure(message: error?.localizedDescription ?? "")
////               }
//           }
    }
        
    
//    func showEditingFailure(message: String) {
//        print("aqui no showEditingFailure ")
//        let alertVC = UIAlertController(title: "User Cadastred", message: message, preferredStyle: .alert)
//        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//       // show(alertVC, sender: nil)
//      //  present(alertVC, animated: true, completion: nil)
//
 //   @IBAction func showAlertButtonTapped(_ sender: UIButton) {

        // create the alert
//        let alert = UIAlertController(title: "UIAlertController", message: "Would you like to continue learning how to use iOS alerts?", preferredStyle: UIAlertController.Style.alert)
//
//        // add the actions (buttons)
//        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: nil))
//        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
//
//        // show the alert
//        self.present(alert, animated: true, completion: nil)
//    // }
//}

//}
