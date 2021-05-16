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

class EditingLocation: UIViewController, CLLocationManagerDelegate {
    
    /*
     
     para fazer o planejamento tecnico vou precisar:
     
     cancelar alteracao e retornar para a tela anterior
     digitar a localizacao
     chamar a funcao de procurar no mapa
     
     */
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var findMap: UIButton!
    
    var locationManager:CLLocationManager!
    var userLocation:CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.text = "Enter Your Location Here"
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
            //locationManager.startUpdatingHeading()
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
        //EMITIR UM UIALERT AQUI!!!!!
        print("Error aquiiii \(error)")
    }
    
    @IBAction func findMap(_ sender: UIButton) {
        // salvar a localizacao informada no locationTextField para pesquisar na  tela SearchLocation
        print("findMap")
        self.performSegue(withIdentifier: "search", sender: nil)
        
        //        OTMUser.postStudentLocation() { studentResponse, error in
        //            //    MapModel.maplist = GetUserResponse
        //            self.performSegue(withIdentifier: "search", sender: nil)
        //        }
    }
    
    //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    //        print("Aqui!")
    //        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
    //        print("locations = \(locValue.latitude) \(locValue.longitude)")
    //    }
    
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
                print("erro aquiiiiii")
            }
        }
    }
    
}
