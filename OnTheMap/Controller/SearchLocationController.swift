//
//  SearchLocationController.swift
//  OnTheMap
//
//  Created by Fabiana Petrovick on 09/05/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//

import UIKit
import MapKit

class SearchLocationController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var linkLinkedin: UITextField!
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    var editingMap:Map!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.linkLinkedin.text = "Enter a Link to Share Here"
        linkLinkedin.delegate = self
        
        self.mapView.delegate = self
    }
    
    @IBAction func linkLinkedinTextField(_ sender: UITextField) {
        sender.text = ""
    }
    
    func handleStudentResponse(studentResponse: StudentResponse?, error: Error?) {
        if let response = error {
            self.showAlert(title: "Warning", message: "URL not informed!")
        } else {
            DispatchQueue.main.async {
                self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func submit(_ sender: UIButton) {
        
        if let url = URL(string: self.linkLinkedin.text!),(UIApplication.shared.canOpenURL(url))
        {
            editingMap.mediaURL = linkLinkedin.text!
            MapModel.maplist.append(editingMap)
            OTMUser.postStudentLocation(uniqueKey: editingMap.uniqueKey ?? " ", firstName: "On The Map", lastName: editingMap.lastName ?? " ", mapString: editingMap.mapString ?? " ", mediaURL: linkLinkedin.text!, latitude: editingMap.latitude, longitude: editingMap.longitude, completion:handleStudentResponse(studentResponse:error:))
        }
        else {
            self.showAlert(title: "Warning", message: "URL not informed correct! Exemple: https://")
        }
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        addPinToMap()
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
    
    func addPinToMap() {
        let lat = CLLocationDegrees(editingMap.latitude as! Double)
        let long = CLLocationDegrees(editingMap.longitude as! Double)
        
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let first = editingMap.firstName as! String
        let last = editingMap.lastName as! String
        let mediaURL = editingMap.mediaURL as! String
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        self.mapView.addAnnotation(annotation)
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

