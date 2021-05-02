//
//  OnTheMapViewControllerList.swift
//  OnTheMap
//
//  Created by Fabiana Petrovick on 26/04/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//

import UIKit


class MapViewControllerList: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //chamada para TMDBClient. Nesse modelo a matriz resultante de filmes é definida como a matriz no modelo de filme
        //            _ = TMDBClient.getWatchlist() { movies, error in
        //                MovieModel.watchlist = movies
        //                self.tableView.reloadData()
        _ = OTMUser.studentLocation() { map, response, error in
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MapModel.maplist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MapTableViewCell")!
        
        let map = MapModel.maplist[indexPath.row]

        cell.textLabel?.text = map.firstName == "" ? map.lastName : map.firstName
        cell.imageView?.image = UIImage(named: "icon_pin") //imagem padrao da pasta assests
                      
        return cell
    }
}


