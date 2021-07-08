//
//  OnTheMapViewControllerList.swift
//  OnTheMap
//
//  Created by Fabiana Petrovick on 26/04/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//

import UIKit
import MapKit

class MapViewControllerList: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pin: UIBarButtonItem!
    @IBOutlet weak var exit: UIBarButtonItem!
    @IBOutlet weak var refresh: UIBarButtonItem!
    
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = OTMUser.getStudentLocation() { map, response, error in
            MapModel.maplist = map
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

extension MapViewControllerList: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MapModel.maplist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MapTableViewCell")!
        
        let map = MapModel.maplist[indexPath.row]
        
        cell.textLabel?.text = map.firstName
        cell.detailTextLabel?.text = map.mediaURL
        cell.imageView?.image = UIImage(named: "icon_pin")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = MapModel.maplist[indexPath.row]
        if let url =  URL(string: data.mediaURL){
            UIApplication.shared.open(url, options: [:])
        } else {
            let alert = UIAlertController(title: "Error", message: "Failed open URL", preferredStyle: .alert )
            alert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
                return
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func editingLocation() {
        let alert = UIAlertController(title: "UIAlertController", message: "Would you like to continue learning how to use iOS alerts?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction((UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            self.performSegue(withIdentifier: "Location", sender: nil)
        })))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func addStudentsToMap(locations: [Map]) {
        for map in locations {
            
            let first = map.firstName as! String
            let last = map.lastName as! String
            let mediaURL = map.mediaURL as! String
        }
    }
    
    func listStudents() {
        OTMUser.getStudentLocation(completion: handleStudentResponse(maps:success:error:))
    }
    
    func handleStudentResponse(maps: [Map], success: Bool, error: Error?) {
        addStudentsToMap(locations: maps)
    }
    
    @IBAction func refreshMap(_ sender: Any) {
        listStudents()
    }
}


