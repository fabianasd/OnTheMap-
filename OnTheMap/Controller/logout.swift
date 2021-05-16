//
//  logout.swift
//  OnTheMap
//
//  Created by Gabriel Petrovick on 15/05/21.
//  Copyright © 2021 Fabiana Petrovick. All rights reserved.
//


import UIKit

extension UIViewController {
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        print("aquiii")
        if(OTMUser.logout != nil)
        {
            logoutResponse(id: "", expiration: "")
        }
        print("saindooooooo")
        self.dismiss(animated: true, completion: nil)
    }
    
}
