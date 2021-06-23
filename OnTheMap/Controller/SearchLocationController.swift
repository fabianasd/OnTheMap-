//
//  SearchLocationController.swift
//  OnTheMap
//
//  Created by Fabiana Petrovick on 09/05/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//

import UIKit
import MapKit

class SearchLocationController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var linkLinkedin: UITextField!
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    var editingMap:Map!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        linkLinkedin.text = "Enter a Link to Share Here"
        
        self.mapView.delegate = self
    }
    
    @IBAction func linkLinkedinTextField(_ sender: UITextField) {
        sender.text = ""
    }
    
    func handleStudentResponse(studentResponse: StudentResponse?, error: Error?) {
        if let response = error {
            print(error)
            print(response)
            let alert = UIAlertController(title: "Warning", message: "URL not informed!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in return
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            DispatchQueue.main.async {
                self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func submit(_ sender: Any) {
        if(linkLinkedin.text != "")
        {
            editingMap.mediaURL = linkLinkedin.text!
            MapModel.maplist.append(editingMap)
            //salvar informacoes
            OTMUser.postStudentLocation(uniqueKey: editingMap.uniqueKey ?? " ", firstName: "On The Map", lastName: editingMap.lastName ?? " ", mapString: editingMap.mapString ?? " ", mediaURL: linkLinkedin.text!, latitude: editingMap.latitude, longitude: editingMap.longitude, completion:handleStudentResponse(studentResponse:error:))
        } //senao retorna alerta
        else {
            let alert = UIAlertController(title: "Warning", message: "URL not informed!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in return
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    /* Map related functions*/
    
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
    
}

