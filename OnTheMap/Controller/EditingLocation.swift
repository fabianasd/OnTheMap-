//
//  EditingLocation.swift
//  OnTheMap
//
//  Created by Fabiana Petrovick on 02/05/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//
//
import UIKit
import MapKit
import CoreLocation

class EditingLocation: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var findMap: UIButton!
    @IBOutlet weak var lodingActivity: UIActivityIndicatorView!
    
    var locationManager:CLLocationManager!
    var userLocation:CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationTextField.text = "Enter Your Location Here"
        locationTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        determineMyCurrentLocation()
    }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func locationTextField(_ sender: UITextField) {
        sender.text = ""
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0] as CLLocation
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    @IBAction func findMap(_ sender: UIButton) {
        geocodePosition(newLocation: locationTextField.text!)
        self.setLoadingIn(true)
    }
    
    @IBAction func cancel(_ sender: Any) {
        print("cancel")
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "search" {
            if(userLocation != nil)
            {
                if let destinationVC = segue.destination as? SearchLocationController {
                    print(userLocation.coordinate.latitude)
                    
                    destinationVC.editingMap =
                        Map(createdAt: "",
                            firstName: "",
                            lastName: "",
                            latitude:  userLocation.coordinate.latitude,
                            longitude: userLocation.coordinate.longitude,
                            mapString: "",
                            mediaString: "",
                            mediaURL: "",
                            objectId: "",
                            uniqueKey: "",
                            updatedAt: "")
                }
            }
            if(userLocation == nil){
                print("error")
            }
        }
    }
        
    func geocodePosition(newLocation: String) {
        CLGeocoder().geocodeAddressString(newLocation) { (newMarker, error) in
            if let error = error {
                self.showAlert(title: "Location Incorrect", message: "Check the location informed!")
                self.setLoadingIn(false)
                print("Location not found.")
            } else {
                var location: CLLocation?
                if let marker = newMarker, marker.count > 0 {
                    location = marker.first?.location
                }
                
                if let location = location {
                    self.userLocation = location
                    self.performSegue(withIdentifier: "search", sender: location)
                } else {
                    self.showAlert(title: "Alert", message: "Please try again later.")
                    self.setLoadingIn(false)
                    print("there was an error.")
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func setLoadingIn(_ loadingIn: Bool) {
        if loadingIn {
            lodingActivity.startAnimating()
        } else {
            lodingActivity.stopAnimating()
            findMap.isEnabled = !loadingIn
        }
    }
}
