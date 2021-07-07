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
    
    var locationManager:CLLocationManager!
    var userLocation:CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationTextField.text = "Enter Your Location Here"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        determineMyCurrentLocation()
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
     //   unsubscribeFromKeyboardNotifications()
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
        unsubscribeFromKeyboardNotifications()
        geocodePosition(newLocation: locationTextField.text!)
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
    
    func showAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    func geocodePosition(newLocation: String) {
        CLGeocoder().geocodeAddressString(newLocation) { (newMarker, error) in
            if let error = error {
                self.showAlert(title: "Location Incorrect", message: "Check the location informed!")
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
                    print("there was an error.")
                }
            }
        }
    }
    
    // MARK: -- Keyboard methods
    @objc func keyboardWillShow(_ notification:Notification) {
        if locationTextField.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification) * (+1)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notication:Notification) -> CGFloat {
        let userInfo = notication.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
